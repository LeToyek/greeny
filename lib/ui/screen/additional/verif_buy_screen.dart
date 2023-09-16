import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/services/wallet_service.dart';
import 'package:greenify/states/payments/trx_notification_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/date_helper.dart';
import 'package:greenify/utils/formatter.dart';
import 'package:ionicons/ionicons.dart';

class VerifBuyScreen extends ConsumerWidget {
  final int indexTrx;
  static const routePath = "/verif_buy";
  static const routeName = "verif_buy";
  const VerifBuyScreen({super.key, required this.indexTrx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trxNotification = ref.watch(trxNotificationProvider);
    final trxNotifier = ref.read(trxNotificationProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final boldTextColor = colorScheme.onSurface.withOpacity(.6);
    final walletService = WalletService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Pembelian"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: trxNotification.when(
            data: (data) {
              final trxNotif = data[indexTrx];
              print(trxNotif);
              return PlainCard(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                image: NetworkImage(
                                    trxNotif.trxModel!.plant!.image),
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
                              trxNotif.trxModel!.plant!.name,
                              style: textTheme.labelLarge!.apply(
                                  fontWeightDelta: 1,
                                  fontSizeDelta: 3,
                                  color: boldTextColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trxNotif.trxModel!.plant!.category,
                              style: textTheme.labelLarge!.apply(
                                  fontSizeDelta: 1,
                                  color: boldTextColor.withOpacity(.6)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${formatMoney(trxNotif.trxModel!.plant!.price ?? 100000)}",
                              style: textTheme.labelLarge!.apply(
                                  fontSizeDelta: 6,
                                  fontWeightDelta: 6,
                                  color: boldTextColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Detail Pembayaran',
                      style: textTheme.labelLarge!.copyWith(
                          color: boldTextColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Harga',
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rp ${formatMoney(trxNotif.trxModel!.value)}",
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pemilik',
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder(
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.name!,
                                  style: textTheme.labelLarge!.copyWith(
                                      color: boldTextColor,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(
                                  "Loading...",
                                  style: textTheme.labelLarge!.copyWith(
                                      color: boldTextColor,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                            future: trxNotif.trxModel!.toUserModel()),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tanggal',
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateHelper.extractDate(trxNotif.trxModel!.createdAt),
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Waktu',
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateHelper.extractTime(trxNotif.trxModel!.createdAt),
                          style: textTheme.labelLarge!.copyWith(
                              color: boldTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    trxNotif.trxModel!.status == 'req'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PlainCard(
                                  onTap: () async {
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
                                    walletService.processTransaction(
                                        userId: trxNotif.fromID!,
                                        notifID: trxNotif.id!,
                                        transactionId: trxNotif.trxModel!.id!);
                                    await trxNotifier.getTrxNotif();
                                    if (context.mounted) {
                                      context.pop();
                                      context.pop();
                                    }
                                  },
                                  color: colorScheme.primary,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.checkmark_done_outline,
                                        color: colorScheme.onPrimary,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Proses",
                                        style: textTheme.labelLarge!.copyWith(
                                            color: colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                              PlainCard(
                                  onTap: () async {
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
                                    walletService.denyTransaction(
                                        userId: trxNotif.fromID!,
                                        notifID: trxNotif.id!,
                                        transactionId: trxNotif.trxModel!.id!,
                                        price: trxNotif.trxModel!.value);
                                    await trxNotifier.getTrxNotif();
                                    if (context.mounted) {
                                      context.pop();
                                      context.pop();
                                    }
                                  },
                                  color: colorScheme.error,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.close,
                                        color: colorScheme.onPrimary,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Tolak",
                                        style: textTheme.labelLarge!.copyWith(
                                            color: colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ))
                            ],
                          )
                        : trxNotif.trxModel!.status == 'process'
                            ? Center(
                                child: PlainCard(
                                    color: colorScheme.primary,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Ionicons.checkmark_done_outline,
                                          color: colorScheme.onPrimary,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Sedang diproses",
                                          style: textTheme.labelLarge!.copyWith(
                                              color: colorScheme.onPrimary,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              )
                            : PlainCard(
                                color: colorScheme.error,
                                child: Row(
                                  children: [
                                    Icon(
                                      Ionicons.close,
                                      color: colorScheme.onPrimary,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "ditolak",
                                      style: textTheme.labelLarge!.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                    const SizedBox(
                      height: 8,
                    ),
                  ]));
            },
            error: (err, s) {
              return Text(err.toString());
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }
}
