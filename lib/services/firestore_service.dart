import 'package:cloud_functions/cloud_functions.dart';

class PaymentService {
  Future<Map<String, dynamic>> createPayment(int amount) async {
    final callable = FirebaseFunctions.instance.httpsCallable('createPayment');

    final result = await callable.call({"amount": amount});

    return {
      "qr_string": result.data["qr_string"],
      "transaction_id": result.data["transaction_id"],
    };
  }
}
