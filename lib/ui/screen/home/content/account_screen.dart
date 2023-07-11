import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenify/services/auth.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:ionicons/ionicons.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FireAuth.getCurrentUser();
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: user == null
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: <Widget>[
                const Header(text: 'Account Screen'),
                const SizedBox(height: 36),
                ClipOval(
                  child: user.photoURL != null
                      ? Image.network(
                          user.photoURL!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                ),
                const SizedBox(height: 36),
                PlainCard(
                    child: _textAccount(
                        context: context, text: user.displayName!)),
                const SizedBox(height: 12),
                PlainCard(
                    child: _textAccount(context: context, text: user.email!)),
                const SizedBox(height: 12),
                PlainCard(
                    child: _textAccount(
                        context: context,
                        text: user.phoneNumber != null &&
                                user.phoneNumber!.isNotEmpty
                            ? user.phoneNumber!
                            : 'No phone number')),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => FireAuth.signOut(context),
                  child: PlainCard(
                      color: Theme.of(context).colorScheme.error,
                      child: Row(
                        children: [
                          const Icon(
                            Ionicons.log_out_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          _textAccount(
                              context: context,
                              text: 'Logout',
                              color: Colors.white),
                        ],
                      )),
                )
                // const SizedBox(height: 12),
              ]),
            ),
    );
  }

  Widget _textAccount({required context, required String text, Color? color}) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .apply(fontWeightDelta: 2, color: color),
    );
  }
}
