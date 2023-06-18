import 'package:flutter/material.dart';
import 'package:greenify/ui/widgets/card/leaf_card.dart';

class StemTimeline extends StatelessWidget {
  const StemTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> timelineData = [
      "asdas",
      "dsad",
      "dsad",
      "dsad",
      "dsad",
      "dsad",
      "dsad",
      "dsad",
      "dsad",
      "dsad",
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: timelineData.length,
      itemBuilder: (context, index) {
        return TimelineItem(
          event: timelineData[index],
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

class TimelineItem extends StatelessWidget {
  final String event;
  final TimelineItemPosition position;

  const TimelineItem({super.key, required this.event, required this.position});

  @override
  Widget build(BuildContext context) {
    return TimelineItemPosition.left == position
        ? Row(
            children: [
              const Expanded(
                  flex: 32,
                  child: LeafCard(
                      title: "Sawi Hijau ",
                      content:
                          "asdkoaskd okasod kaosk doaks odkaos kdosaokdoasodkaso saokdoaskdoaks asdasd",
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
              const Expanded(
                flex: 32,
                child: LeafCard(
                    title: "Sawi Hijau ",
                    content:
                        "asdkoaskd okasod kaosk doaks odkaos kdosaokdoasodkaso saokdoaskdoaks asdasd",
                    isLeft: false),
              ),
            ],
          );
  }
}
