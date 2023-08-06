import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/states/file_notifier.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/upload_image_container.dart';

class EditGardenScreen extends ConsumerStatefulWidget {
  final GardenModel garden;
  const EditGardenScreen({super.key, required this.garden});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditGardenScreenState();
}

class _EditGardenScreenState extends ConsumerState<EditGardenScreen> {
  final key = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.garden.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileController = ref.read(fileEditGardenProvider.notifier);
    final funcUserRef = ref.read(singleUserProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Ubah Garden"),
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
                                setState(() {
                                  isLoading = true;
                                  print('isloading $isLoading');
                                });
                                String name = nameController.text;
                                String? image =
                                    await fileController.uploadFileForEdit();
                                // Process data.
                                try {
                                  ref
                                      .read(gardenProvider.notifier)
                                      .updateGarden(widget.garden.id, name,
                                          image ?? widget.garden.backgroundUrl)
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
                            child: const Text("Ubah"),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Center(
              child: isLoading
                  ? Container(
                      color: Colors.grey.withOpacity(.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Memproses...")
                        ],
                      ))
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
