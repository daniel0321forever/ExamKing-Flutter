import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:examKing/blocs/auth/auth_bloc.dart';

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();

    return InkWell(
      onTap: () {
        authBloc.add(AuthEventGoogleSignUp());
      },
      child: Container(
        height: 46,
        width: 250,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://w7.pngwing.com/pngs/425/124/png-transparent-google-chrome-icon-google-chrome-web-browser-logo-computer-icons-chrome-orange-chrome-os-internet-explorer-thumbnail.png',
                  height: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "使用Google帳號登入",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
