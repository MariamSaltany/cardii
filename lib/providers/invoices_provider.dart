import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:saees_cards/models/transaction_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

class InvoicesProvider extends BaseProvider {
  List<TransactionModel> transactions = [];
  String? nextUrl;
  bool isLoadingMore = false;

  List<TransactionModel> get transactionsList => transactions;
  bool get hasMore => nextUrl != null && !isLoadingMore;

  Future<List<dynamic>> validateCard(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/wallets/validate", body);

    if (response.statusCode == 200) {
      setBusy(false);
      return [true, json.decode(response.body)['data']['balance']];
    } else {
      setBusy(false);
      return [false, "This card is invalid"];
    }
  }

  Future<void> getTransactions({bool loadMore = false}) async {
    if (loadMore && (isLoadingMore || nextUrl == null)) return;

    if (!loadMore) {
      setBusy(true);
      transactions.clear();
      nextUrl = null;
    } else {
      isLoadingMore = true;
    }

    try {
      final String url = loadMore && nextUrl != null
          ? nextUrl!
          : "/vendor/transactions";
      final response = await api.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        final newTransactions = data
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();

        if (loadMore) {
          transactions.addAll(newTransactions);
        } else {
          transactions = newTransactions;
        }

        nextUrl = json.decode(response.body)['links']?['next'];

        if (kDebugMode) {
          print(
            "Loaded ${newTransactions.length} transactions. Next: $nextUrl",
          );
        }
      } else {
        nextUrl = null;
        if (kDebugMode) print("Failed to load transactions");
      }
    } catch (e) {
      if (kDebugMode) print('Transactions error: $e');
      nextUrl = null;
    } finally {
      isLoadingMore = false;
      if (!loadMore) setBusy(false);
      notifyListeners();
    }
  }

  Future<List> placeInvoice(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/invoices", body);
    if (response.statusCode == 201) {
      await getTransactions(loadMore: false);
      return [true, "Invoice Added Successfully"];
    } else {
      setBusy(false);
      return [
        false,
        json.decode(response.body)["message"] ?? "Failed to add invoice",
      ];
    }
  }
}
