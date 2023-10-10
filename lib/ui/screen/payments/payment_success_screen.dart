import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/states/theme_mode_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/formatter.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  static const routePath = '/payments/success';
  static const routeName = 'payments-success';

  final TransactionModel transactionModel;
  const PaymentSuccessScreen({super.key, required this.transactionModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);

    final boldTextColor = themeMode == ThemeMode.light
        ? Colors.black
        : colorScheme.onSurface.withOpacity(.6);

    return WillPopScope(
      onWillPop: () async {
        context.go("/");
        return true;
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PlainCard(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Payment Success',
                      style: textTheme.headlineMedium!.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                PlainCard(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  image: CachedNetworkImageProvider(
                                      transactionModel.plant!.image),
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
                                transactionModel.plant!.name,
                                style: textTheme.labelLarge!.apply(
                                    fontWeightDelta: 1,
                                    fontSizeDelta: 3,
                                    color: boldTextColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transactionModel.plant!.category,
                                style: textTheme.labelLarge!.apply(
                                    fontSizeDelta: 1,
                                    color: boldTextColor.withOpacity(.6)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${formatMoney(transactionModel.plant!.price ?? 100000)}",
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
                            "Rp ${formatMoney(transactionModel.value)}",
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
                              future: transactionModel.toUserModel()),
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
                            transactionModel.createdAt,
                            style: textTheme.labelLarge!.copyWith(
                                color: boldTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ])),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Terima kasih telah berbelanja di Greenify',
                  textAlign: TextAlign.center,
                  style: textTheme.labelLarge!.copyWith(
                      color: boldTextColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: PlainCard(
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        context.go("/");
                      },
                      child: Center(
                          child: Text(
                        "Kembali ke Beranda",
                        style: textTheme.labelLarge!
                            .apply(fontWeightDelta: 2, color: Colors.white),
                      ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
