import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:greenify/model/soill_model.dart';

class SoilDetectionBottomSheet extends StatelessWidget {
  const SoilDetectionBottomSheet({
    super.key,
    required this.res,
  });

  final Soil res;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hasil Deteksi Greeny",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeightDelta: 2,
                        fontSizeDelta: 4)),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(res.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.apply(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeightDelta: 2,
                    fontSizeDelta: 8)),
            const SizedBox(
              height: 16,
            ),
            Text("Deskripsi",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeightDelta: 2,
                    fontSizeDelta: 4)),
            Text(res.description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeightDelta: 1,
                    fontSizeDelta: 2)),
            const SizedBox(
              height: 16,
            ),
            Text("Tanaman",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeightDelta: 2,
                    fontSizeDelta: 4)),
            Text(res.plants,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeightDelta: 1,
                    fontSizeDelta: 2)),
            const SizedBox(
              height: 16,
            ),
            Text("Gambar Tanah",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeightDelta: 2,
                    fontSizeDelta: 4)),
            Row(
              children: [
                for (final image in res.images)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
