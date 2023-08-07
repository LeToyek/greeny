import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/file_notifier_state.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/upload_image_container.dart';

class CreateGardenScree extends ConsumerStatefulWidget {
  const CreateGardenScree({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGardenScreeState();
}

class _CreateGardenScreeState extends ConsumerState<CreateGardenScree> {
  final key = GlobalKey<FormState>();
  bool isLoading = false;

  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final fileController = ref.read(fileProvider.notifier);
    final funcUserRef = ref.read(singleUserProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Tambahkan Garden"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: key,
                child: Column(
                  children: [
                    PlainCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Garden",
                            style:
                                Theme.of(context).textTheme.titleMedium!.apply(
                                      fontWeightDelta: 2,
                                    )),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Masukkan nama garden",
                            hintStyle:
                                Theme.of(context).textTheme.bodyMedium!.apply(
                                      color: Colors.grey,
                                    ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        UploadImageContainer(fileNotifier: fileController),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                if (fileController.file == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Error"),
                                            content: const Text(
                                                "Please upload an image"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      context.pop(),
                                                  child: const Text("OK"))
                                            ],
                                          ));
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                  print('isloading $isLoading');
                                });
                                String name = nameController.text;
                                String image =
                                    await fileController.uploadFile();
                                // Process data.
                                try {
                                  ref
                                      .read(gardenProvider.notifier)
                                      .createGarden(name, image)
                                      .then((value) => funcUserRef.getUser());
                                  setState(() {
                                    isLoading = false;
                                    print('isloading $isLoading');
                                  });
                                  if (context.mounted) {
                                    context.pop();
                                  }
                                } catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Error"),
                                            content: Text(e.toString()),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      context.pop(),
                                                  child: const Text("OK"))
                                            ],
                                          ));
                                }
                              }
                            },
                            child: const Text("Tambahkan"),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Processing")
                        ],
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
