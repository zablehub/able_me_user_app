import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/transaction/transaction_order.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:http/http.dart' as http;
import 'package:able_me/services/app_src/network.dart';

class TransactionApi extends Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? _accessToken = _cacher.getUserToken();
  // Future<void> test() async {
  //   final response = await http.get(
  //       "${endpoint}booking/ongoing-transactions?sort_by=id/desc".toUri,
  //       headers: {
  //         "Accept": "application/json",
  //         HttpHeaders.authorizationHeader: "Bearer $_accessToken"
  //       });
  // }

  Future<List<TransactionOrder>> getTransactionHistory(
      {required int myID, List<int>? statuses}) async {
    try {
      return await http.get(
          "${endpoint}booking/transactions?customer_id=$myID&sort_by=id/desc&statuses=${statuses?.join(',') ?? "1,2,3,4,5,6,7"}"
              .toUri,
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer $_accessToken"
          }).then((response) async {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          final List res = data['data'];
          final filteredOrders = res.where((e) =>
              e['state'] != null &&
              e['country'] != null &&
              e['city'] != null &&
              e['address'] != null);
          final List<TransactionOrder> orders = await Future.wait(filteredOrders
              .map((e) async => await TransactionOrder.fromJson(e)));

          return orders;
          // return res
          //     .where((e) =>
          //         e['state'] != null &&
          //         e['country'] != null &&
          //         e['city'] != null &&
          //         e['address'] != null)
          //     .map((e) => TransactionOrder.fromJson(e))
          //     .toList();
        }
        return [];
      });
    } catch (e, s) {
      print("ERROR: $e $s");
      return [];
    }
  }

  Future<List<TransactionOrder>> getOngoingTransactions() async {
    try {
      return await http.get(
          "${endpoint}booking/customer/ongoing-transactions?sort_by=id/desc"
              .toUri,
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer $_accessToken"
          }).then((response) async {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          final List res = data['data'];
          print("TRANSACTION : $res");
          final filteredOrders = res.where((e) =>
              e['state'] != null &&
              e['country'] != null &&
              e['city'] != null &&
              e['address'] != null);
          final List<TransactionOrder> orders = await Future.wait(filteredOrders
              .map((e) async => await TransactionOrder.fromJson(e)));

          return orders;
          // return res
          //     .where((e) =>
          //         e['state'] != null &&
          //         e['country'] != null &&
          //         e['city'] != null &&
          //         e['address'] != null)
          //     .map((e)  => await TransactionOrder.fromJson(e))
          //     .toList();
        }
        return [];
      });
    } catch (e, s) {
      print("ERROR: $e $s");
      return [];
    }
  }
}
