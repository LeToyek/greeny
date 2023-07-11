import 'package:flutter/material.dart';
import 'package:greenify/ui/widgets/pill.dart';
import 'package:ionicons/ionicons.dart';

class LeafCard extends StatelessWidget {
  const LeafCard(
      {super.key,
      required this.title,
      required this.content,
      required this.isLeft});

  final String title;
  final String content;
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
                            image: NetworkImage(
                                "https://cdn.britannica.com/26/152026-050-41D137DE/Sunshine-leaves-beech-tree.jpg"))
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
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 12, right: 12),
                  child: Pill(icon: Ionicons.water, title: "12:00 PM"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
