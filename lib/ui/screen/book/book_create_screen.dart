import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/book.dart';
import 'package:greenify/states/book_state.dart';
import 'package:greenify/states/file_notifier.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/upload_image_container.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class BookCreateScreen extends ConsumerWidget {
  const BookCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(bookProvider);
    final funcBookRef = ref.read(bookProvider.notifier);

    final funcFileRef = ref.read(fileProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          actions: const [],
          title: const Text("Create Book"),
          centerTitle: true,
        ),
        body: Material(
            color: Theme.of(context).colorScheme.background,
            child: bookRef.when(
                data: (_) => TextEditor(
                    bookNotifier: funcBookRef, fileNotifier: funcFileRef),
                error: (e, s) => Center(
                      child: Text(e.toString()),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))));
  }
}

class TextEditor extends StatefulWidget {
  final BookNotifier bookNotifier;
  final FileNotifier fileNotifier;

  const TextEditor(
      {super.key, required this.bookNotifier, required this.fileNotifier});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();
  TextEditingController titleController = TextEditingController();
  final categoryList = BookServices.bookCategoryList;
  String? selectedChips = BookServices.bookCategoryList.first.name;

  void _toggleChip(String chip) {
    setState(() {
      if (selectedChips == chip) {
        selectedChips = null;
      } else {
        selectedChips = chip;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  Future<void> _submitForm() async {
    final fullPath = await widget.fileNotifier.uploadFile();
    if (result.length < 10 ||
        titleController.value.text.isEmpty ||
        selectedChips == null) {
      return;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: const Text("Konfirmasi"),
              content:
                  const Text("Apakah anda yakin ingin membuat artikel ini?"),
              actions: [
                TextButton(
                    onPressed: () => context.pop(), child: const Text("Batal")),
                TextButton(
                    onPressed: () {
                      widget.bookNotifier.createBook(BookModel(
                        imageUrl: fullPath,
                        title: titleController.value.text,
                        category: selectedChips!,
                        content: result,
                      ));
                      context.push("/");
                    },
                    child: const Text("Ya")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    List<Widget> chipWidgets = categoryList.map((chip) {
      bool isSelected = selectedChips == chip.name;
      return GestureDetector(
        onTap: () => _toggleChip(chip.name),
        child: Chip(
          label: Text(chip.name,
              style: textTheme.bodyMedium!.apply(
                fontWeightDelta: 1,
                color: Colors.white,
              )),
          backgroundColor:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
      );
    }).toList();
    return SingleChildScrollView(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              PlainCard(
                child: TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                  style: textTheme.headlineSmall!.apply(fontWeightDelta: 2),
                  decoration: InputDecoration(
                      hintText: 'Judul Artikel',
                      hintStyle:
                          textTheme.headlineSmall!.apply(fontWeightDelta: 2)),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              PlainCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gambar Sampul",
                      style: textTheme.bodyLarge!.apply(fontWeightDelta: 2)),
                  const SizedBox(height: 8),
                  UploadImageContainer(
                    fileNotifier: widget.fileNotifier,
                  ),
                ],
              )),
              const SizedBox(
                height: 16,
              ),
              PlainCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pilih Kategori",
                      style: textTheme.bodyLarge!.apply(fontWeightDelta: 2)),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: chipWidgets,
                    ),
                  ),
                  selectedChips != null
                      ? const SizedBox(
                          height: 8,
                        )
                      : Text(
                          "Kategori tidak boleh kosong",
                          style: textTheme.bodyMedium!
                              .apply(fontWeightDelta: 1, color: Colors.red),
                        ),
                ],
              )),
              const SizedBox(
                height: 16,
              ),
              PlainCard(
                child: HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: 'Your text here...',
                    shouldEnsureVisible: true,
                    adjustHeightForKeyboard: true,
                    autoAdjustHeight: true,

                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.belowEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed: (ButtonType type, bool? status,
                        Function? updateStatus) {
                      print(
                          "button pressed, the current selected status is $status");
                      return true;
                    },

                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      print("dropdown  changed to $changed");
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      print(url);
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      print(file.name); //filename
                      print(file.size); //size in bytes
                      print(file.extension); //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: const OtherOptions(height: 550),
                  callbacks: Callbacks(
                    onBeforeCommand: (String? currentHtml) {
                      print('html before change is $currentHtml');
                    },
                    onImageUploadError: (FileUpload? file, String? base64Str,
                        UploadError error) {
                      print(base64Str ?? '');
                      if (file != null) {
                        print(file.name);
                        print(file.size);
                        print(file.type);
                      }
                    },
                  ),
                  plugins: [
                    SummernoteAtMention(
                        getSuggestionsMobile: (String value) {
                          var mentions = <String>['test1', 'test2', 'test3'];
                          return mentions
                              .where((element) => element.contains(value))
                              .toList();
                        },
                        mentionsWeb: ['test1', 'test2', 'test3'],
                        onSelect: (String value) {
                          print(value);
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.undo();
                      },
                      child: const Text('Undo',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.clear();
                      },
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.redo();
                      },
                      child: const Text(
                        'Redo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                onPressed: () async {
                  var txt = await controller.getText();
                  if (txt.contains('src="data:')) {
                    txt =
                        '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                  }
                  setState(() {
                    result = txt;
                  });
                  await _submitForm();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Tambahkan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
