import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:greenify/ui/widgets/pill.dart';
import 'package:ionicons/ionicons.dart';

class LeafCard extends StatelessWidget {
  const LeafCard(
      {super.key,
      required this.title,
      required this.content,
      required this.wateringTime,
      required this.imageUrl,
      required this.isLeft});

  final String title;
  final String content;
  final String imageUrl;
  final String wateringTime;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: isLeft
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))
              : const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: isLeft
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(12),
                        ),
                  child: SizedBox(
                    height: 80,
                    child: Wrap(
                      children: [
                        Image(
                            width: double.infinity,
                            image: CachedNetworkImageProvider(imageUrl))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.titleMedium!.apply(fontWeightDelta: 2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, bottom: 12, right: 12),
                  child: Pill(icon: Ionicons.water, title: wateringTime),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
