const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

// Function membuat transaksi pembayaran ke DOKU
exports.createPayment = functions.https.onCall(async (data, context) => {

  const amount = data.amount;
  const invoice = "INV-" + Date.now();

  const body = {
    order: {
      amount: amount,
      invoice_number: invoice
    },
    payment: {
      payment_due_date: 60
    },
    customer: {
      name: "Donatur",
      email: "donatur@email.com"
    }
  };

  try {

    const response = await axios.post(
      "https://api-sandbox.doku.com/checkout/v1/payment",
      body,
      {
        headers: {
          "Client-Id": "BRN-0208-1773552131673",
          "Secret-Key": "SK-UsXtG9aCeD3Y7dBTcy0Z",
          "Content-Type": "application/json"
        }
      }
    );

    const paymentUrl = response.data.response.payment.url;

    await admin.firestore().collection("donations").doc(invoice).set({
      amount: amount,
      status: "pending",
      payment_url: paymentUrl,
      created_at: new Date()
    });

    return {
      qr_string: response.data.response.qr_string || "",
      transaction_id: invoice,
      payment_url: paymentUrl
    };

  } catch (error) {

    console.error(error);

    throw new functions.https.HttpsError(
      "internal",
      "Payment gagal dibuat"
    );
  }

});


// Webhook dari DOKU
exports.dokuWebhook = functions.https.onRequest(async (req, res) => {
  try {

    const data = req.body;

    const invoice = data.order.invoice_number;
    const status = data.transaction.status;

    console.log("Webhook DOKU:", data);

    if (status === "SUCCESS") {

      await admin.firestore()
        .collection("donations")
        .doc(invoice)
        .update({
          status: "paid",
          paid_at: new Date()
        });

    }

    res.status(200).send("OK");

  } catch (error) {

    console.error(error);
    res.status(500).send("Webhook error");

  }
});