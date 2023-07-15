import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/book.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class BookCreateScreen extends ConsumerWidget {
  const BookCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: const [],
          title: const Text("Create Book"),
          centerTitle: true,
        ),
        body: Material(
            color: Theme.of(context).colorScheme.background,
            child: const TextEditor()));
  }
}

class TextEditor extends StatefulWidget {
  const TextEditor({super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();
  TextEditingController titleController = TextEditingController();
  final categoryList = BookServices.bookCategoryList;
  List<String> selectedChips = [];

  void _toggleChip(String chip) {
    setState(() {
      if (selectedChips.contains(chip)) {
        selectedChips.remove(chip);
      } else {
        selectedChips.add(chip);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    List<Widget> chipWidgets = categoryList.map((chip) {
      bool isSelected = selectedChips.contains(chip);
      return GestureDetector(
        onTap: () => _toggleChip(chip),
        child: Chip(
          label: Text(chip,
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
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    print('html before change is $currentHtml');
                  }, onChangeContent: (String? changed) {
                    print('content changed to $changed');
                  }, onChangeCodeview: (String? changed) {
                    print('code changed to $changed');
                  }, onChangeSelection: (EditorSettings settings) {
                    print('parent element is ${settings.parentElement}');
                    print('font name is ${settings.fontName}');
                  }, onDialogShown: () {
                    print('dialog shown');
                  }, onEnter: () {
                    print('enter/return pressed');
                  }, onFocus: () {
                    print('editor focused');
                  }, onBlur: () {
                    print('editor unfocused');
                  }, onBlurCodeview: () {
                    print('codeview either focused or unfocused');
                  }, onInit: () {
                    print('init');
                  },
                      //this is commented because it overrides the default Summernote handlers
                      /*onImageLinkInsert: (String? url) {
                          print(url ?? "unknown url");
                        },
                        onImageUpload: (FileUpload file) async {
                          print(file.name);
                          print(file.size);
                          print(file.type);
                          print(file.base64);
                        },*/
                      onImageUploadError: (FileUpload? file, String? base64Str,
                          UploadError error) {
                    print(base64Str ?? '');
                    if (file != null) {
                      print(file.name);
                      print(file.size);
                      print(file.type);
                    }
                  }, onKeyDown: (int? keyCode) {
                    print('$keyCode key downed');
                    print(
                        'current character count: ${controller.characterCount}');
                  }, onKeyUp: (int? keyCode) {
                    print('$keyCode key released');
                  }, onMouseDown: () {
                    print('mouse downed');
                  }, onMouseUp: () {
                    print('mouse released');
                  }, onNavigationRequestMobile: (String url) {
                    print(url);
                    return NavigationActionPolicy.ALLOW;
                  }, onPaste: () {
                    print('pasted into editor');
                  }, onScroll: () {
                    print('editor scrolled');
                  }),
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
                  print(result);
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
              result.isNotEmpty || result != ""
                  ? Html(data: result)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
