import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

// import 'package:able_me/services/data_cacher.dart';
class NotificationApi with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();
  final String? firebaseAccessToken = _cacher.firebaseAccessToken;
  Future<void> send(
      {required int receiverID,
      required String title,
      required String body,
      required String type,
      required bool isUrgent}) async {
    try {
      if (firebaseAccessToken == null) return;
      return await http
          .post("${endpoint}notification/user/send".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }, body: {
        "receiver_id": "$receiverID",
        "title": title,
        "content": body,
        "type": type,
        "is_urgent": isUrgent,
        "token": firebaseAccessToken,
      }).then((response) {
        if (response.statusCode == 200) {
          // var data = json.decode(response.body);
          //
          print("MESSAGE SENT!");
          // return BookRiderDetails.fromJson(data);
        }
        return null;
      });
    } catch (e, s) {
      print("MESSAGE SENDING FAILED");
      return;
    }
  }
}
