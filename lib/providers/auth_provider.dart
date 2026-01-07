import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saees_cards/models/wallet_model.dart';
import 'package:saees_cards/providers/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  uninitialized,
  unauthenticated,
  authenticated,
  authenticating,
}

class AuthProvider extends BaseProvider {
  AuthStatus status = AuthStatus.uninitialized;
  String? token;
  WalletModel? walletModel;

  Future<void> initAuthProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tempToken = prefs.getString("token");

    if (tempToken != null) {
      status = AuthStatus.authenticated;
      token = tempToken;
      if (kDebugMode) {
        print("TOKEN : $tempToken");
      }

      setBusy(false);
    } else {
      status = AuthStatus.unauthenticated;
      token = null;

      setBusy(false);
    }
  }

  Future<List> login(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/login", body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("token", json.decode(response.body)['token']);

      setFailed(false);
      setBusy(false);
      return [true, "User Loged Successfully"];
    } else {
      setFailed(true);
      setBusy(false);
      return [false, json.decode(response.body)['message']];
    }
  }

  Future<void> getWallet() async {
    setBusy(true);

    final response = await api.get("/vendor/info");
    if (response.statusCode == 200) {
      walletModel = WalletModel.fromJson(json.decode(response.body)['data']);

      setFailed(false);
      setBusy(false);
    } else {
      walletModel = null;
      setFailed(true);
      setBusy(false);
    }
  }

  Future<List> logout() async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await api.post("/vendor/logout", {});

    if (response.statusCode == 200) {
      prefs.remove("token");

      status = AuthStatus.unauthenticated;
      setFailed(false);

      setBusy(false);

      return [true, json.decode(response.body)["message"]];
    } else {
      setFailed(true);
      setBusy(false);
      return [false, json.decode(response.body)["message"]];
    }
  }


}
