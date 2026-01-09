import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';
import 'package:saees_cards/providers/auth_provider.dart';
import 'package:saees_cards/screens/main_screens/tabs_content/invoices_content.dart';
import 'package:saees_cards/screens/main_screens/tabs_content/transactions_content.dart';
import 'package:saees_cards/screens/main_screens/tabs_content/wallet_content.dart';
import 'package:saees_cards/widgets/dialogs/custom_drawer.dart';
import 'package:saees_cards/widgets/dialogs/scan_sheet.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int currentIndex = 0;
  List<String> uploadedImages = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authConsumer, _) {
        return Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              "assets/logoOnly.png",
              width: getSize(context).width * 0.2,
            ),
          ),
          body: IndexedStack(
            index: currentIndex,
            children: const [
              WalletContent(),
              TransactionsContent(),
              InvoicesContent(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: labelSmall.copyWith(color: primaryColor),
            unselectedLabelStyle: labelSmall.copyWith(color: Colors.grey),
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: "Wallet",
                icon: Icon(Icons.wallet),
              ),
              BottomNavigationBarItem(
                label: "Transactions",
                icon: Icon(Icons.history),
              ),
              BottomNavigationBarItem(
                label: "Invoices",
                icon: Icon(Icons.receipt),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(Icons.qr_code, color: whiteColor),
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                builder: (context) => ScanSheet(),
              );
            },
          ),
        );
      },
    );
  }
}
