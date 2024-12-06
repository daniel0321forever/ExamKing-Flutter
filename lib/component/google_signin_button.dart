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
        authBloc.add(AuthEventSignUp());
      },
      child: Container(
        height: 50,
        width: 220,
        decoration: BoxDecoration(
          color: const Color.fromARGB(202, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              authBloc.add(AuthEventSignUp());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS70VFOE_89OCH_ztJMmAt-3NPx-nwKCVGvkg&s',
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Sign in with Google",
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
      ),
    );
  }
}
