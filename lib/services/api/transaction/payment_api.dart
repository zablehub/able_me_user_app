import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class PaymentApi with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? _accessToken = _cacher.getUserToken();

  Future<bool> pay(
      {required int transactionID,
      required String paymentMethod,
      required double price,
      required String transactionReference,
      String? note,
      required double gross,
      required double net,
      required double bankFee}) async {
    try {
      return await http.post("${endpoint}payment/pay-order".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_accessToken"
      }, body: {
        "order_id": "$transactionID",
        "payment_method": paymentMethod,
        "amount": price.toStringAsFixed(2),
        "bank_transaction": transactionReference,
        'gross': gross.toString(),
        'fee': bankFee.toString(),
        'net': net.toString()
      }).then((res) => res.statusCode == 200);
    } catch (e, s) {
      print("PAYMENT ERROR: $e $s");
      return false;
    }
  }
}
