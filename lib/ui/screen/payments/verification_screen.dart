import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/services/wallet_service.dart';
import 'package:greenify/states/payments/transaction_history_state.dart';
import 'package:greenify/states/theme_mode_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/screen/payments/payment_success_screen.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/formatter.dart';
import 'package:ionicons/ionicons.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  static const routePath = '/payments/verification';
  static const routeName = 'payments-verification';

  final PlantModel plant;
  final String plantRef;

  const VerificationScreen(
      {super.key, required this.plant, required this.plantRef});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _isAgree = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);

    final boldTextColor = themeMode == ThemeMode.light
        ? Colors.black
        : colorScheme.onSurface.withOpacity(.6);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Verifikasi Pembayaran'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailPlantInfo(context, ref, boldTextColor),
              const SizedBox(height: 8),
              _buildProTip(context, ref, boldTextColor),
              const SizedBox(height: 8),
              _buildPaymentDetail(context, ref, boldTextColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailPlantInfo(
      BuildContext context, WidgetRef ref, Color boldTextColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return PlainCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.start,
            "Tanaman yang dibeli",
            style: textTheme.labelLarge!.apply(
                fontWeightDelta: 2, fontSizeDelta: 4, color: boldTextColor),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primary,
                  image: DecorationImage(
                      image: NetworkImage(widget.plant.image),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plant.name,
                    style: textTheme.labelLarge!.apply(
                        fontWeightDelta: 1,
                        fontSizeDelta: 3,
                        color: boldTextColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.plant.category,
                    style: textTheme.labelLarge!.apply(
                        fontSizeDelta: 1, color: boldTextColor.withOpacity(.6)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp. ${formatMoney(widget.plant.price ?? 100000)}",
                    style: textTheme.labelLarge!.apply(
                        fontSizeDelta: 6,
                        fontWeightDelta: 6,
                        color: boldTextColor),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(
      BuildContext context, WidgetRef ref, Color boldTextColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final userClientController = ref.watch(userClientProvider.notifier);
    final wallet = ref.watch(singleUserProvider);

    return PlainCard(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.start,
          "Pembayaran",
          style: textTheme.labelLarge!.apply(
              fontWeightDelta: 2, fontSizeDelta: 4, color: boldTextColor),
        ),
        const SizedBox(height: 10),
        PlainCard(
            child: Row(
          children: [
            Icon(Ionicons.wallet, size: 16, color: colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              "Greeny Wallet",
              style: textTheme.labelLarge!.apply(
                  fontWeightDelta: 2,
                  fontSizeDelta: 1,
                  color: boldTextColor.withOpacity(.6)),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: boldTextColor.withOpacity(.6),
            ),
            const SizedBox(width: 10),
          ],
        )),
        const SizedBox(
          height: 12,
        ),
        const Divider(),
        Row(
          children: [
            Checkbox(
                value: _isAgree,
                onChanged: (value) {
                  setState(() {
                    _isAgree = value ?? false;
                  });
                }),
            Expanded(
              child: Text(
                "Saya setuju dengan syarat dan ketentuan yang berlaku",
                style: textTheme.labelLarge!.apply(
                    fontSizeDelta: .1, color: boldTextColor.withOpacity(.6)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Text("Rp ${formatMoney(widget.plant.price ?? 100000)}",
                    style: textTheme.labelLarge!.apply(
                        fontWeightDelta: 2,
                        fontSizeDelta: 8,
                        color: boldTextColor))),
            const SizedBox(width: 10),
            Expanded(
                flex: 2,
                child: PlainCard(
                    onTap: () async {
                      if (_isAgree) {
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
                        String timeNow = DateTime.now().toString();
                        final owner = userClientController.visitedUserModel!;
                        final logMessage =
                            'Pembelian tanaman ${widget.plant.name} milik ${owner.name} berhasil ';
                        final walletVal = wallet.value!.first.wallet!.value;
                        if (walletVal > widget.plant.price!) {
                          final transaction = TransactionModel(
                              value: widget.plant.price!,
                              createdAt: timeNow,
                              updatedAt: timeNow,
                              logType: '[MIN]',
                              logMessage: logMessage);
                          transaction.refModel =
                              "users/${owner.userId}/${widget.plantRef}";
                          ref.watch(singleUserProvider.notifier).getUser();

                          transaction.setPlant(widget.plant);
                          transaction.ownerID = owner.userId;
                          await WalletService().buyPlant(
                              transactionModel: transaction,
                              reference:
                                  "users/${owner.userId}/${widget.plantRef}");
                          ref
                              .watch(transactionHistory.notifier)
                              .getTransactionHistory();
                          if (context.mounted) {
                            context.pushReplacement(
                                PaymentSuccessScreen.routePath,
                                extra: transaction);
                          }
                        } else {
                          context.pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Gagal"),
                                  content: const Text("Saldo tidak cukup"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text("OK"))
                                  ],
                                );
                              });
                        }
                      }
                    },
                    boxShadow: const BoxShadow(
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                    border: Border.all(
                        color: _isAgree
                            ? Colors.transparent
                            : colorScheme.primary),
                    color: _isAgree ? colorScheme.primary : colorScheme.surface,
                    child: Text("Bayar",
                        textAlign: TextAlign.center,
                        style: textTheme.labelLarge!.apply(
                            fontWeightDelta: 2,
                            fontSizeDelta: 1,
                            color: _isAgree
                                ? Colors.white
                                : colorScheme.primary))))
          ],
        )
      ],
    ));
  }

  Widget _buildProTip(
      BuildContext context, WidgetRef ref, Color boldTextColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const proTips = [
      "Periksa kembail detail tanaman yang ingin anda beli serta detail pembayaran sebelum melakukan pembayaran",
      "Pastikan saldo Greeny Wallet anda mencukupi",
      "Pastikan anda memiliki koneksi internet yang stabil",
      "Jangan lupa untuk membaca syarat dan ketentuan yang berlaku",
      "Hubungi customer service kami jika ada masalah"
    ];

    return PlainCard(
      color: Colors.yellow.shade800,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, size: 24, color: colorScheme.onPrimary),
              const SizedBox(
                width: 8,
              ),
              Text("Pro Tip",
                  style: textTheme.labelLarge!.apply(
                      fontWeightDelta: 2,
                      fontSizeDelta: 4,
                      color: colorScheme.onPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
              itemCount: proTips.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: textTheme.labelSmall!.apply(
                              fontWeightDelta: 2,
                              color: Colors.yellow.shade800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        proTips[index],
                        style: textTheme.labelLarge!.apply(
                            fontSizeDelta: 1, color: colorScheme.onPrimary),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
