import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/ui/widgets/card/leaf_card.dart';

class StemTimeline extends StatelessWidget {
  final List<PotModel> potModels;
  const StemTimeline({super.key, required this.potModels});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: potModels.length,
      itemBuilder: (context, index) {
        return TimelineItem(
          event: potModels[index].plant,
          position: index % 2 == 0
              ? TimelineItemPosition.left
              : TimelineItemPosition.right,
        );
      },
    );
  }
}

enum TimelineItemPosition {
  left,
  right,
}

class TimelineItem extends ConsumerWidget {
  final PlantModel event;
  final TimelineItemPosition position;

  const TimelineItem({super.key, required this.event, required this.position});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TimelineItemPosition.left == position
        ? Row(
            children: [
              Expanded(
                  flex: 32,
                  child: LeafCard(
                      imageUrl: event.image,
                      wateringTime: event.wateringTime,
                      title: event.name,
                      content: event.description,
                      isLeft: true)),
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 160,
                ),
              ),
              Expanded(
                flex: 32,
                child: Container(
                  color: Colors.transparent,
                  height: 100,
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                flex: 32,
                child: Container(
                  color: Colors.transparent,
                  height: 100,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 160,
                ),
              ),
              Expanded(
                flex: 32,
                child: LeafCard(
                    imageUrl: event.image,
                    wateringTime: event.wateringTime,
                    title: event.name,
                    content: event.description,
                    isLeft: false),
              ),
            ],
          );
  }
}
