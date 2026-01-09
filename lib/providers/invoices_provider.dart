import 'dart:convert';
import 'package:saees_cards/models/transaction_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

class InvoicesProvider extends BaseProvider {
  List<TransactionModel> get transactions => items.cast<TransactionModel>();

  Future<List<dynamic>> validateCard(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/wallets/validate", body);
    setBusy(false);
    if (response.statusCode == 200) {
      return [true, json.decode(response.body)['data']['balance']];
    }
    return [false, "This card is invalid"];
  }

  Future<void> getTransactions({bool loadMore = false}) async {
    await fetchPaginated(
      endpoint: "/vendor/transactions",
      loadMore: loadMore,
      parseData: (data) =>
          data.map((e) => TransactionModel.fromJson(e)).toList(),
    );
  }

  Future<List> placeInvoice(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/invoices", body);
    setBusy(false);
    if (response.statusCode == 201) {
      await refresh(
        endpoint: "/vendor/transactions",
        parseData: (data) =>
            data.map((e) => TransactionModel.fromJson(e)).toList(),
      );
      return [true, "Invoice Added Successfully"];
    }
    return [false, json.decode(response.body)["message"] ?? "Failed"];
  }
}
