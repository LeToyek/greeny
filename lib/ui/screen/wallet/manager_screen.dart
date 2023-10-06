import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/services/wallet_service.dart';
import 'package:greenify/states/payments/transaction_history_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/screen/wallet/success_screen.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/formatter.dart';
import 'package:lottie/lottie.dart';

class WalletManagerScreen extends ConsumerStatefulWidget {
  static const routePath = "/wallet-manager";
  static const routeName = "wallet-manager";
  final List<Map<String, dynamic>> nominalValue = [
    {"value": 20000, "icon": "assets/images/money/money-1.png"},
    {"value": 40000, "icon": "assets/images/money/money-2.png"},
    {"value": 80000, "icon": "assets/images/money/money-3.png"},
    {"value": 100000, "icon": "assets/images/money/money-4.png"},
    {"value": 120000, "icon": "assets/images/money/money-5.png"},
    {"value": 160000, "icon": "assets/images/money/money-6.png"},
  ];
  WalletManagerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletManagerScreenState();
}

class _WalletManagerScreenState extends ConsumerState<WalletManagerScreen> {
  int selectedTopUpValue = 0;
  int? selectedCardIndex;
  final bool _isProcessing = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final userNotifier = ref.watch(singleUserProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Top up"),
          centerTitle: true,
          bottom: const TabBar(indicatorColor: Colors.white, tabs: [
            Tab(
              text: "Cepat",
            ),
            Tab(text: "Metode Lain")
          ]),
          elevation: .3,
        ),
        backgroundColor: colorScheme.surface,
        body: TabBarView(
          children: [
            _buildQuickPage(textTheme, colorScheme),
            _buildOtherPage(textTheme, colorScheme)
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(12),
          child: GestureDetector(
            onTap: () {
              _onPayTopUp(context: context, value: selectedTopUpValue);
              ref.watch(transactionHistory.notifier).getTransactionHistory();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.primary),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top up",
                    style: textTheme.bodyLarge!.apply(
                        fontSizeDelta: 4,
                        fontWeightDelta: 3,
                        color: Colors.white),
                  ),
                  Text(
                    "Rp ${formatMoney(selectedTopUpValue)}",
                    style: textTheme.bodyLarge!.apply(
                        fontSizeDelta: 4,
                        fontWeightDelta: 3,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPage(TextTheme textTheme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlainCard(
          boxShadow: const BoxShadow(
              color: Colors.transparent, offset: Offset.zero, blurRadius: 0),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Isi Manual",
                style: textTheme.labelLarge!
                    .apply(fontWeightDelta: 2, fontSizeDelta: 4),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: "Masukkan nominal top up",
                    hintStyle: TextStyle(color: colorScheme.onSurface),
                    fillColor: colorScheme.onSurface),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() {
                  selectedTopUpValue = int.parse(value);
                }),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Pilih nominal uang",
                style: textTheme.labelLarge!
                    .apply(fontWeightDelta: 2, fontSizeDelta: 4),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 12,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 3,
                children: [
                  ...List.generate(6, (index) {
                    final iconCard = widget.nominalValue[index]['icon'];
                    final topUpValue = widget.nominalValue[index]['value'];
                    return _buildMoneyCard(
                        textTheme: textTheme,
                        isSelected: index == selectedCardIndex ? true : false,
                        iconCard: iconCard,
                        topUpValue: topUpValue);
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoneyCard(
      {required TextTheme textTheme,
      bool isSelected = false,
      required String iconCard,
      required int topUpValue}) {
    final value = formatMoney(topUpValue);
    return PlainCard(
        boxShadow: const BoxShadow(
            color: Colors.transparent, offset: Offset.zero, blurRadius: 0),
        onTap: () => setState(() {
              selectedTopUpValue = topUpValue;
              selectedCardIndex = widget.nominalValue.indexOf(
                  widget.nominalValue.firstWhere(
                      (element) => element['value'] == selectedTopUpValue));
            }),
        border: Border.all(
            style: BorderStyle.solid,
            width: 4,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconCard,
              height: 48,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Rp $value",
              style: textTheme.bodyMedium!.apply(fontWeightDelta: 2),
            ),
          ],
        ));
  }

  Widget _buildOtherPage(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie/ud_dev_gif.json",
            height: 300,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Fitur masih dalam pengembangan",
            style: textTheme.bodyLarge!
                .apply(fontWeightDelta: 2, fontSizeDelta: 4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Mohon maaf atas ketidaknyamanannya",
            style: textTheme.bodyMedium!
                .apply(fontWeightDelta: 2, fontSizeDelta: 2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _onPayTopUp(
      {required BuildContext context, required int value}) async {
    final userRef = ref.read(singleUserProvider.notifier);
    if (value != 0) {
      WalletService walletService = WalletService();

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            // title: const Text("Parkir"),
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
      await walletService.increaseWalletValue(value);
      await userRef.getUser();

      if (context.mounted) {
        Future.delayed(const Duration(seconds: 1))
            .then((value) => context.go(SuccessScreen.routePath));
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded),
          iconColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Masukkan nominal top up anda terlebih dahulu!",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () => context.pop(), child: const Text("Tutup"))
          ],
        ),
      );
    }
  }
}
