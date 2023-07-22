import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/users_state.dart';

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
    void _submitForm() async {
      try {
        if (formKey.currentState!.validate()) {
          // Process data.
          String name = nameController.text;
          String email = emailController.text;
          String password = passwordController.text;

          await funcUserAction.registerUser(
              email: email, password: password, name: name);
          refPots.getPots();
          context.pushReplacement("/");
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

    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      backgroundColor: Theme.of(context).colorScheme.background,
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
                          labelText: 'Name',
                          labelStyle:
                              TextStyle(color: colorTheme.onBackground)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
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
                          return 'Please enter your email';
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
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
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
