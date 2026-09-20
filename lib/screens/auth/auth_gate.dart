import 'package:dishly/screens/auth/login_screen.dart';
import 'package:dishly/screens/meals/meals_screen.dart';
import 'package:dishly/viewmodels/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.isCheckingSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return authViewModel.isLoggedIn ? const MealsScreen() : const LoginScreen();
  }
}
