import 'package:flutter/material.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({super.key});

  final List<Map<String, String>> dummyUsers = [
    {
      "name": "user1",
      "score": "232",
      "rank": "1",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user2",
      "score": "232",
      "rank": "2",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user3",
      "score": "232",
      "rank": "3",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user4",
      "score": "232",
      "rank": "4",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user5",
      "score": "232",
      "rank": "5",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user6",
      "score": "232",
      "rank": "6",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user7",
      "score": "232",
      "rank": "7",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    },
    {
      "name": "user8",
      "score": "232",
      "rank": "8",
      "image_url":
          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
    }
  ];
  @override
  Widget build(BuildContext context) {
    List<String> dumData = ["test", "test"];
    const int maxPlantCount = 16;
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        centerTitle: true,
        title: const Text(
          "Leaderboard",
        ),
      ),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: [
                    PlainCard(
                        child: Row(
                      children: [
                        Text(dummyUsers[index]["rank"]!),
                        const SizedBox(width: 16),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(dummyUsers[index]["image_url"]!),
                        ),
                        const SizedBox(width: 16),
                        Text(dummyUsers[index]["name"]!),
                        const Spacer(),
                        Text(dummyUsers[index]["score"]!),
                      ],
                    )),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                );
              },
              childCount: dummyUsers.length,
            )),
          ),
        ]),
      ),
    );
  }
}
