import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/validator.dart';
import 'package:ionicons/ionicons.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    final userAction = ref.watch(singleUserProvider);
    final funcUserAction = ref.read(singleUserProvider.notifier);

    final refPots = ref.watch(homeProvider.notifier);

    final colorTheme = Theme.of(context).colorScheme;
    void submitForm() async {
      try {
        if (formKey.currentState!.validate()) {
          // Process data.
          String name = nameController.text;
          String email = emailController.text;
          String password = passwordController.text;

          await funcUserAction.registerUser(
              email: email, password: password, name: name);
          refPots.getPots();
          if (context.mounted) {
            context.pushReplacement("/");
          }
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("OK"))
                  ],
                ));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      backgroundColor: colorTheme.background,
      body: Stack(
        children: [
          userAction.when(
              data: (data) => Container(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Container()),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Nama',
                          labelStyle:
                              TextStyle(color: colorTheme.onBackground)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan nama anda';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: colorTheme.onBackground)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email anda';
                        } else if (!isValidEmail(value)) {
                          return 'Masukkan email yang valid';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: colorTheme.onBackground)),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan password anda';
                        } else if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () => submitForm(),
                      child: PlainCard(
                          color: colorTheme.primary,
                          child: Row(
                            children: [
                              const Icon(Ionicons.person_add,
                                  color: Colors.white),
                              const SizedBox(width: 12),
                              Text(
                                'Daftar',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                        fontWeightDelta: 2,
                                        color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
