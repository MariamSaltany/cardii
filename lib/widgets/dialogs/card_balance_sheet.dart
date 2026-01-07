import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';

class CardBalanceSheet extends StatelessWidget {
  const CardBalanceSheet({
    super.key,
    required this.uuid,
    required this.balance,
  });
  final String uuid;
  final String balance;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: true,
      onClosing: () {},

      builder: (context) {
        return Column(
          children: [
            QrImageView(
              data: uuid,
              version: QrVersions.auto,
              size: getSize(context).width * 0.66,
            ),

            Text(uuid, style: labelMedium),

            Text(
              "Balance : $balance LYD",
              style: displayMedium.copyWith(color: greenColor),
            ),
          ],
        );
      },
    );
  }
}
