import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';
import 'package:saees_cards/models/transaction_model.dart';
import 'package:saees_cards/providers/invoices_provider.dart';
import 'package:saees_cards/widgets/statics/shimmer_widget.dart';

class InvoicesContent extends StatefulWidget {
  const InvoicesContent({super.key});
  @override
  State<InvoicesContent> createState() => _InvoicesContentState();
}

class _InvoicesContentState extends State<InvoicesContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(context, listen: false).getTransactions();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<InvoicesProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        provider.transactions.isNotEmpty &&
        provider.hasMore) {
      provider.getTransactions(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, provider, _) {
        return RefreshIndicator(
          onRefresh: () => provider.getTransactions(),
          child: provider.busy && provider.transactions.isEmpty
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: getSize(context).height * 0.12,
                      child: ShimmerWidget(),
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      provider.transactions.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= provider.transactions.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return TransactionCard(
                      transaction: provider.transactions[index],
                    );
                  },
                ),
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: const Offset(1, 2),
              blurRadius: 7,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.reference,
                    style: labelSmall.copyWith(color: Colors.grey),
                  ),
                  Text(transaction.userName, style: labelSmall),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${transaction.balanceBefore} → ${transaction.balanceAfter}",
                    style: labelSmall.copyWith(color: Colors.grey),
                  ),
                  Text(
                    transaction.displayAmount,
                    style: labelMedium.copyWith(color: transaction.typeColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
