import 'dart:convert';

import 'package:saees_cards/models/invoice_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

class InvoicesProvider extends BaseProvider {
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

  List<InvoiceModel> invoices = [];

  void getInvoices() async {
    setBusy(true);

    final response = await api.get("/vendor/invoices");

    if (response.statusCode == 200) {
      invoices = List<InvoiceModel>.from(
        json
            .decode(response.body)['data']
            .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      setBusy(false);
    } else {
      invoices = [];
      setBusy(false);
    }
  }

  Future<List> placeInvoice(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/invoices", body);
    if (response.statusCode == 201) {
      getInvoices();
      return [true, "Invoice Added Successfully"];
    } else {
      setBusy(false);

      return [false, json.decode(response.body)["message"]];
    }
  }
}
