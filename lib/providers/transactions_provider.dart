import 'package:saees_cards/models/transaction_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

class TransactionsProvider extends BaseProvider {
  List<TransactionModel> get transactions => items.cast<TransactionModel>();

  Future<void> getTransactions({bool loadMore = false}) async {
    await fetchPaginated(
      endpoint: "/vendor/transactions",
      loadMore: loadMore,
      parseData: (data) =>
          data.map((e) => TransactionModel.fromJson(e)).toList(),
    );
  }
}
