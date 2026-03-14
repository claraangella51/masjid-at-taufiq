

const express = require('express');
const router = express.Router();

// Dummy in-memory donation database (replace with real DB in production)
const donations = [];

// Midtrans webhook endpoint for donation payments
router.post('/midtrans/webhook', async (req, res) => {
  try {
    const {
      order_id,
      transaction_status,
      fraud_status,
      gross_amount
    } = req.body;

    console.log('Received Midtrans webhook:', req.body);

    // Find donation by order_id
    const donation = donations.find(d => d.order_id === order_id);

    if (!donation) {
      console.log('Donation not found:', order_id);
      return res.status(404).json({ message: 'Donation not found' });
    }

    // Update payment status based on transaction_status
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

    console.log('Donation status updated:', donation);
    res.status(200).json({ message: 'Webhook processed' });
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).json({ message: 'Webhook error' });
  }
});

module.exports = router;