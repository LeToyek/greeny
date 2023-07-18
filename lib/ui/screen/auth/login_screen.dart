import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final userAct = ref.watch(singleUserProvider);
    final funcUserAct = ref.read(singleUserProvider.notifier);

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void _submitForm() async {
      if (formKey.currentState!.validate()) {
        // Process data.
        try {
          String email = emailController.text;
          String password = passwordController.text;

          await funcUserAct.basicLogin(email: email, password: password);
          if (context.mounted) context.pushReplacement("/");
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(e.toString()),
                    actions: [
                      TextButton(
                          onPressed: () => context.pop(),
                          child: const Text("OK"))
                    ],
                  ));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            userAct.when(
                data: (data) => Container(),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Container()),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => _submitForm(),
                        child: PlainCard(
                            color: Theme.of(context).colorScheme.primary,
                            child: Row(
                              children: [
                                const Icon(Ionicons.log_in,
                                    color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  'Login',
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
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await funcUserAct.loginWithGoogle();
                            if (context.mounted) context.pushReplacement("/");
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () => context.pop(),
                                            child: const Text("OK"))
                                      ],
                                    ));
                          }
                        },
                        child: PlainCard(
                            color: Theme.of(context).colorScheme.error,
                            child: Row(
                              children: [
                                const Icon(Ionicons.logo_google,
                                    color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  'Login with Google',
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
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          context.push('/register');
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
