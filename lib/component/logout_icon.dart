import 'package:flutter/material.dart';

import 'package:examKing/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutIcon extends StatelessWidget {
  final void Function()? onPressed;
  const LogoutIcon({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            authBloc.add(AuthEventLogOut());
          }
        },
        icon: const Icon(Icons.logout, color: Color.fromARGB(255, 240, 100, 100), size: 20),
      ),
    );
  }
}
