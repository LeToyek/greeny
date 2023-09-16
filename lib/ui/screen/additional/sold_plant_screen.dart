import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/services/pot_service.dart';
import 'package:greenify/services/users_service.dart';
import 'package:greenify/states/payments/trx_notification_state.dart';
import 'package:greenify/ui/screen/additional/verif_buy_screen.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class SoldPlantScreen extends ConsumerWidget {
  static const routePath = "/sold_plant";
  static const routeName = "sold_plant";

  const SoldPlantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trxNotification = ref.watch(trxNotificationProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tanaman Terjual'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: trxNotification.when(
              data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final trxNotif = data[index];
                      return Card(
                        child: ListTile(
                          title: Text(trxNotif.title),
                          subtitle: Text(trxNotif.description),
                          trailing: PlainCard(
                              onTap: () async {
                                final userModel = await UsersServices()
                                    .getMainInfoUser(id: trxNotif.fromID!);
                                final plant = await PotServices.getPlantFromRef(
                                    trxNotif.refModel!);
                                if (context.mounted) {
                                  context.push(VerifBuyScreen.routePath,
                                      extra: {
                                        "plant": plant,
                                        "buyer": userModel
                                      });
                                }
                              },
                              child: const Text("Proses")),
                        ),
                      );
                    },
                  ),
              error: (error, st) => Center(
                    child: Text("error $error\n$st"),
                  ),
              loading: () => const Center(child: CircularProgressIndicator())),
        ));
  }
}
