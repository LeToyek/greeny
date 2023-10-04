import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/validator.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(singleUserProvider);

    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorTheme.background,
      appBar: AppBar(title: const Text('Masuk')),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: colorTheme.onBackground)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!isValidEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: colorTheme.onBackground)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PlainCard(
                        onTap: () async => submitForm(),
                        color: colorTheme.primary,
                        child: Row(
                          children: [
                            const Icon(Ionicons.log_in, color: Colors.white),
                            const SizedBox(width: 12),
                            Text(
                              'Masuk',
                              style: textTheme.bodyMedium!.apply(
                                  fontWeightDelta: 2, color: Colors.white),
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    PlainCard(
                        onTap: () async => loginWithGoogle(),
                        color: colorTheme.error,
                        child: Row(
                          children: [
                            const Icon(Ionicons.logo_google,
                                color: Colors.white),
                            const SizedBox(width: 12),
                            Text(
                              'Masuk Dengan Google',
                              style: textTheme.bodyMedium!.apply(
                                  fontWeightDelta: 2, color: Colors.white),
                            ),
                          ],
                        )),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: const Text('Belum punya akun? Daftar disini'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          user.when(
            data: (data) => Container(),
            loading: () => Center(
              child: CircularProgressIndicator(
                backgroundColor: colorTheme.background,
              ),
            ),
            error: (error, stack) => Container(),
          ),
        ],
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      final postNotifier = ref.read(homeProvider.notifier);
      final userNotifier = ref.read(singleUserProvider.notifier);

      await userNotifier.loginWithGoogle();
      // print("test");
      // await userNotifier.getUser();

      final error = userNotifier.state.maybeWhen(
        orElse: () => null,
        error: (e, _) => e,
      );

      if (error != null) {
        throw error;
      }

      if (context.mounted) context.pushReplacement("/");

      postNotifier.getPots();
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () => context.pop(), child: const Text("OK"))
            ],
          ),
        );
      }
    }
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      // Process data.
      try {
        final postNotifier = ref.read(homeProvider.notifier);
        final userNotifier = ref.read(singleUserProvider.notifier);

        String email = emailController.text;
        String password = passwordController.text;

        await userNotifier.basicLogin(email: email, password: password);
        await userNotifier.getUser();

        if (context.mounted) context.pushReplacement("/");

        postNotifier.getPots();
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                    onPressed: () => context.pop(), child: const Text("OK"))
              ],
            ),
          );
        }
      }
    }
  }
}
