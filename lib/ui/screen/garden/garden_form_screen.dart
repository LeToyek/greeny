import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/garden.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:ionicons/ionicons.dart';

class GardenFormScreen extends ConsumerStatefulWidget {
  const GardenFormScreen({super.key});

  @override
  ConsumerState<GardenFormScreen> createState() => _GardenFormScreenState();
}

class _GardenFormScreenState extends ConsumerState<GardenFormScreen> {
  late final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  final List<Map<String, dynamic>> _characterImages = [
    {
      "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
      "name": "Sayuran"
    },
    {
      "image":
          'https://friendlystock.com/wp-content/uploads/2020/12/3-kawaii-indoor-plant-cartoon-clipart.jpg',
      "name": "Bunga"
    },
    {
      "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
      "name": "Sayuran"
    },
    {
      "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
      "name": "Sayuran"
    },
    {
      "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
      "name": "Sayuran"
    },
    {
      "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
      "name": "Sayuran"
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text("Tambah Tanaman"),
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
            )
          ];
        },
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Material(
            color: Theme.of(context).colorScheme.background,
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              shadowColor: Theme.of(context).colorScheme.shadow,
              color: Theme.of(context).colorScheme.surface,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kategori",
                            style: textTheme.titleMedium!
                                .apply(fontWeightDelta: 2),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Pilihlah kategori yang sesuai untuk tanaman anda",
                            style:
                                textTheme.bodyMedium!.apply(color: Colors.grey),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          _plantChoose(),
                          _platFormField(
                              "Nama", "Masukkan nama tanaman", context),
                          const SizedBox(height: 16),
                          Text(
                            "Jadwal Penyiraman",
                            style: textTheme.titleMedium!
                                .apply(fontWeightDelta: 2),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          _wateringSchedule(context),
                          const SizedBox(height: 16),
                          Text(
                            "Gambar Tanaman",
                            style: textTheme.titleMedium!
                                .apply(fontWeightDelta: 2),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [8, 8],
                              color: Colors.grey,
                              strokeWidth: 2,
                              child: SizedBox(
                                height: 180,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        "Tambahkan Gambar",
                                        style: textTheme.bodySmall!.apply(
                                            fontWeightDelta: 2,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final gardens =
                                  await GardensServices.getGardens();
                              print(gardens[0].name);
                            },
                            child: PlainCard(
                                child: Center(
                              child: Text(
                                "Masukkan",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(fontWeightDelta: 2),
                              ),
                            )),
                          )
                        ])),
              ),
            ),
          ),
        ));
  }

  Widget _wateringSchedule(context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Icon(
              Ionicons.alarm_outline,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Icon(
              Ionicons.alarm_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _platFormField(String label, String hint, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.titleMedium!.apply(
                  fontWeightDelta: 2,
                )),
        const SizedBox(height: 8.0),
        TextFormField(
          validator: (value) =>
              value!.trim().isEmpty ? "Masukkan $label" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: Colors.grey,
                ),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _plantChoose() {
    final theme = ref.watch(themeProvider);
    return Row(
      children: [
        InkWell(
            onTap: () {
              if (_pageController.page! > 0) {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              } else {
                _pageController.animateToPage(_characterImages.length - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              }
            },
            child: Icon(
              Ionicons.chevron_back_outline,
              color: theme != ThemeMode.light
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            )),
        Expanded(
          child: SizedBox(
            height: 210,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: _characterImages.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeOut.transform(value) * 210,
                        width: Curves.easeOut.transform(value) * 210,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                        child: Image.network(
                          _characterImages[index]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        _characterImages[index]["name"],
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(fontWeightDelta: 2),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        InkWell(
            onTap: () {
              if (_pageController.page! < _characterImages.length - 1) {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              } else {
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              }
            },
            child: Icon(
              Ionicons.chevron_forward_outline,
              color: theme != ThemeMode.light
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            )),
      ],
    );
  }
}
