import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/widgets/card/plant_card.dart';

class GardenSpaceScreen extends StatelessWidget {
  const GardenSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dumData = ["test", "test"];
    const int maxPlantCount = 16;
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        centerTitle: true,
        title: const Text(
          "Garden Space",
        ),
      ),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            physics: const BouncingScrollPhysics(),
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: maxPlantCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 7 / 13,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 12),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  if (index == dumData.length) {
                    return InkWell(
                      onTap: () => context.push("/garden/form"),
                      child: PlantCard(
                        status: PlantBoxStatus.empty,
                        title: 'Add Plant',
                        imageURI: "lib/assets/images/dumPlant.png",
                      ),
                    );
                  }
                  if (index > dumData.length) {
                    return PlantCard(
                      title: 'Empty',
                      imageURI: "lib/assets/images/dumPlant.png",
                    );
                  }
                  return PlantCard(
                    status: PlantBoxStatus.filled,
                    title: 'Media ',
                    imageURI: "lib/assets/images/dumPlant.png",
                  );
                },
              ),
            ]),
      ),
    );
  }
}
