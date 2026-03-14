

const midtransClient = require('midtrans-client');

// Midtrans Snap configuration
const snap = new midtransClient.Snap({
  isProduction: false, // change to true when going live
  serverKey: process.env.MIDTRANS_SERVER_KEY,
});

// Dummy in‑memory storage (replace with database later)
const donations = [];

// Create donation transaction
exports.createDonation = async (req, res) => {
  try {
    const { kategori, jenis, nominal, nama } = req.body;

    const orderId = `DONASI-${Date.now()}`;

    const parameter = {
      transaction_details: {
        order_id: orderId,
        gross_amount: nominal,
      },
      item_details: [
        {
          id: 'donasi',
          price: nominal,
          quantity: 1,
          name: `${kategori} - ${jenis}`,
        },
      ],
      customer_details: {
        first_name: nama || 'Donatur',
      },
      enabled_payments: ['qris'],
    };

    const transaction = await snap.createTransaction(parameter);

    const donation = {
      order_id: orderId,
      kategori,
      jenis,
      nominal,
      nama,
      status: 'PENDING',
      created_at: new Date(),
    };

    donations.push(donation);

    res.json({
      message: 'Transaction created',
      order_id: orderId,
      snap_token: transaction.token,
      redirect_url: transaction.redirect_url,
    });
  } catch (error) {
    console.error('Create donation error:', error);
    res.status(500).json({ message: 'Failed to create donation transaction' });
  }
};

// Midtrans webhook handler
exports.midtransWebhook = async (req, res) => {
  try {
    const { order_id, transaction_status } = req.body;

    const donation = donations.find(d => d.order_id === order_id);

    if (!donation) {
      return res.status(404).json({ message: 'Donation not found' });
    }

    if (transaction_status === 'settlement') {
      donation.status = 'PAID';
    } else if (transaction_status === 'pending') {
      donation.status = 'PENDING';
    } else if (
      transaction_status === 'deny' ||
      transaction_status === 'cancel' ||
      transaction_status === 'expire'
    ) {
      donation.status = 'FAILED';
    }

    console.log('Donation updated:', donation);

    res.status(200).json({ message: 'Webhook processed' });
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).json({ message: 'Webhook error' });
  }
};

// Get donation list (admin use)
exports.getDonations = (req, res) => {
  res.json(donations);
};