import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/auth/login.dart';
import 'package:able_me/services/auth/user_data.dart';
import 'package:able_me/services/firebase/email_and_password_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
export 'package:firebase_auth/firebase_auth.dart';

mixin class AuthHelper {
  final DataCacher cacher = DataCacher.instance;
  final UserDataApi _userDataApi = UserDataApi();
  final FirebaseEmailPasswordAuth emailPasswordAuth =
      FirebaseEmailPasswordAuth();
  final UserAuth auth = UserAuth();
  // final UserAuth _authApi = UserAuth();

  Future<String?> getAccessToken(String firebaseUID) async =>
      await auth.signIn(firebaseUID);
  Future<User?> getfirebaseUser(String email, String password) async =>
      await emailPasswordAuth.signIn(email: email, password: password);

  // Future<String?> loginCredentials()
  Future<String?> firebaseLogin(String email, String password) async {
    final User? user =
        await emailPasswordAuth.signIn(email: email, password: password);
    if (user == null) {
      Fluttertoast.showToast(msg: "User not found");
      return null;
    }

    final String? aToken = await user.getIdToken();

    if (aToken == null) {
      return null;
    }
    return await getAccessToken(aToken);
  }

  Future<UserModel?> getUserData() async => _userDataApi.getUserDetails();
}
