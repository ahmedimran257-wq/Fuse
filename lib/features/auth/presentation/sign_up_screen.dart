import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../shared/widgets/fuse_glass_card.dart';
import '../../../core/theme/app_colors.dart';
import 'auth_controller.dart';
import '../domain/auth_state.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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

    // Using ref.listen for side effects as requested
    ref.listen(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.emailVerification) {
        // Show verification message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent. Please check your inbox.'),
            backgroundColor: AppColors.accent,
          ),
        );
      } else if (next.status == AuthStatus.authenticated) {
        context.go('/'); // Mapping '/feed' to '/' for now
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
                              text: 'Sign Up',
                              onPressed: () {
                                if (_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) {
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .signUp(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                context.go('/login');
                              },
                              child: const Text(
                                'Already have an account? Sign In',
                                style: TextStyle(color: AppColors.accent),
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
