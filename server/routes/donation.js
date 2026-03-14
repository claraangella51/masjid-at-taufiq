

const express = require('express');
const router = express.Router();
const midtransClient = require('midtrans-client');

// Midtrans configuration
const snap = new midtransClient.Snap({
  isProduction: false, // change to true when in production
  serverKey: process.env.MIDTRANS_SERVER_KEY,
});

// temporary in-memory donation store (replace with real database)
const donations = [];

// Create donation transaction
router.post('/create-donation', async (req, res) => {
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

    // save donation record
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
});

// Get all donations (simple admin endpoint)
router.get('/donations', (req, res) => {
  res.json(donations);
});

module.exports = router;