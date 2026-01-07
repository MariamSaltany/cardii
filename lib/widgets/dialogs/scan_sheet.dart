import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/providers/invoices_provider.dart';
import 'package:saees_cards/screens/handling_screens/qr_scanner.dart';
import 'package:saees_cards/widgets/cickables/main_button.dart';
import 'package:saees_cards/widgets/dialogs/card_balance_sheet.dart';
import 'package:saees_cards/widgets/dialogs/flush_bar.dart';
import 'package:saees_cards/widgets/dialogs/place_invoice_sheet.dart';

class ScanSheet extends StatefulWidget {
  const ScanSheet({super.key});

  @override
  State<ScanSheet> createState() => _ScanSheetState();
}

class _ScanSheetState extends State<ScanSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: true,
      onClosing: () {},

      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [Text("Operations", style: labelMedium)]),
              MainButton(
                horizontalPadding: 0,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => QrScanner()),
                  ).then((scannedValue) {
                    if (scannedValue != null) {
                      if (kDebugMode) {
                        print("SCANNED VALUE : $scannedValue");
                      }
                      if (context.mounted) {
                        Provider.of<InvoicesProvider>(context, listen: false)
                            .validateCard({
                              "uuid": scannedValue,
                              "amount": 1000.toString(),
                            })
                            .then((valideateResponse) {
                              if (valideateResponse.first) {
                                if (context.mounted) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => CardBalanceSheet(
                                      uuid: scannedValue,
                                      balance: valideateResponse.last
                                          .toString(),
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  showCustomFlushBar(
                                    context,
                                    "Failed",
                                    valideateResponse.last,
                                    false,
                                  );
                                }
                              }
                            });
                      }
                    }
                  });
                },
                title: "Show Card",
              ),

              MainButton(
                horizontalPadding: 0,

                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => QrScanner()),
                  ).then((scannedValue) {
                    if (scannedValue != null) {
                      if (kDebugMode) {
                        print("SCANNED VALUE : $scannedValue");
                      }
                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              PlaceInvoiceSheet(cardUid: scannedValue),
                        );
                      }
                    }
                  });
                },
                title: "Place Invoice",
              ),
            ],
          ),
        );
      },
    );
  }
}
