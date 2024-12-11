import 'package:flutter/material.dart';
import 'package:flutter_auth/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_auth/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter_auth/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        // Use dependency injection to create the LoginBloc
        create: (_) => di.sl<AuthBloc>(),
        child: Scaffold(
            body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          // Handle state changes, like navigation or showing snackbars
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: state is! AuthLoading
                      ? () {
                          // Dispatch login event
                          context.read<AuthBloc>().add(LogoutEvent());
                        }
                      : null,
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : const Text('Logout'),
                ),
              ],
            ),
          );
        })));
  }
}
