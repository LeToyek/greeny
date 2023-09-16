import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/payments/transaction_history_state.dart';
import 'package:greenify/ui/screen/additional/trx_status_screen.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/formatter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class HistoryScreen extends ConsumerWidget {
  static const routePath = '/payments/history';
  static const routeName = 'payments-history';
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final transactions = ref.watch(transactionHistory);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Riwayat Transaksi"),
        ),
        backgroundColor: colorScheme.background,
        body: transactions.when(
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final isAdd = data[index].logType == '[ADD]';
                      return Column(
                        children: [
                          InkWell(
                            onTap: isAdd
                                ? () {
                                    print("object");
                                  }
                                : () {
                                    
                                    context.push(TrxStatusScreen.routePath,
                                        extra: {"index": index});
                                  },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              tileColor: colorScheme.surface,
                              leading: PlainCard(
                                padding: const EdgeInsets.all(8),
                                boxShadow: const BoxShadow(
                                  blurRadius: 0,
                                  offset: Offset(0, 0),
                                ),
                                color: isAdd
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                child: isAdd
                                    ? const Icon(
                                        Ionicons.arrow_up,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Ionicons.arrow_down,
                                        color: Colors.red,
                                      ),
                              ),
                              title: Text(data[index].logMessage),
                              subtitle: Text(DateFormat('yyyy-MM-dd').format(
                                  DateTime.parse(data[index].createdAt))),
                              trailing:
                                  Text("Rp ${formatMoney(data[index].value)}"),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      );
                    }),
              );
            },
            error: (error, stackTrace) => Center(
                  child: Column(
                    children: [
                      Text(
                        error.toString(),
                        style: TextStyle(color: colorScheme.error),
                      ),
                      Text(stackTrace.toString(),
                          style: TextStyle(color: colorScheme.error))
                    ],
                  ),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
