import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';
import 'package:saees_cards/models/invoice_model.dart';
import 'package:saees_cards/providers/invoices_provider.dart';
import 'package:saees_cards/widgets/statics/shimmer_widget.dart';

class InvoicesContent extends StatefulWidget {
  const InvoicesContent({super.key});

  @override
  State<InvoicesContent> createState() => _InvoicesContentState();
}

class _InvoicesContentState extends State<InvoicesContent> {
  @override
  void initState() {
    Provider.of<InvoicesProvider>(context, listen: false).getInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesConsumer, _) {
        return ListView.builder(
          itemCount: invoicesConsumer.busy
              ? 10
              : invoicesConsumer.invoices.length,
          itemBuilder: (context, index) {
            return AnimatedSwitcher(
              duration: 300.milliseconds,

              child: invoicesConsumer.busy
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: getSize(context).height * 0.1,
                        child: ShimmerWidget(),
                      ),
                    )
                  : InvoiceCard(invoiceModel: invoicesConsumer.invoices[index]),
            );
          },
        );
      },
    );
  }
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.invoiceModel});
  final InvoiceModel invoiceModel;
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
              color: Colors.black12,
              offset: Offset(1, 2),
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
                    invoiceModel.createdAt
                        .toIso8601String()
                        .substring(0, 10)
                        .replaceAll("-", "/"),
                    style: labelSmall.copyWith(color: Colors.grey),
                  ),
                  Text(invoiceModel.family.name, style: labelSmall),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoiceModel.invoiceNumber,
                    style: labelSmall.copyWith(color: Colors.grey),
                  ),

                  Text(
                    "${invoiceModel.amount} LYD",
                    style: labelMedium.copyWith(color: greenColor),
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
