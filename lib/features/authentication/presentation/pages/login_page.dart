import 'package:flutter/material.dart';
import 'package:flutter_auth/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_auth/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter_auth/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
          } else if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (username) {
                    _emailController.text = username;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (password) {
                    _passwordController.text = password;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                ElevatedButton(
                  onPressed: state is! AuthLoading
                      ? () {
                          // Dispatch login event
                          context.read<AuthBloc>().add(
                                LoginEvent(_emailController.text,
                                    _passwordController.text),
                              );
                        }
                      : null,
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          );
        })));
  }
}
