import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../shared/widgets/fuse_glass_card.dart';
import '../../../core/theme/app_colors.dart';
import 'auth_controller.dart';
import '../domain/auth_state.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/feed'); // Direct them straight to the main experience
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'FUSE',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 48),
                FuseGlassCard(
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.textPrimary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.accent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.accent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColors.textPrimary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.accent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.accent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (authState.status == AuthStatus.loading)
                        const CircularProgressIndicator()
                      else
                        Column(
                          children: [
                            PremiumButton(
                              text: 'Sign In',
                              onPressed: () {
                                if (_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) {
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .signIn(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                context.go(
                                  '/signup',
                                ); // Replaces the screen entirely
                              },
                              child: const Text(
                                'Need an account? Sign Up',
                                style: TextStyle(color: AppColors.accent),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Forgot password – you can add a reset flow
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      if (authState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(color: AppColors.danger),
                          ),
                        ),
                    ],
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
