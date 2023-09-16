import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class VerifBuyScreen extends ConsumerWidget {
  final PlantModel plantModel;
  final UserModel buyer;

  static const routePath = "/verif_buy";
  static const routeName = "verif_buy";
  const VerifBuyScreen(
      {super.key, required this.plantModel, required this.buyer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Pembelian"),
      ),
      body: PlainCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Apakah anda yakin ingin menjual ${plantModel.name} seharga ${plantModel.price}?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
