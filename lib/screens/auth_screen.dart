import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form.dart';
import '../screens/happy_screen.dart';
import 'home_screen.dart';
import '../models/user_model.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formType = ref.watch(authFormTypeProvider);
    final authState = ref.watch(authProvider);

    // Track previous auth state for comparison
    ref.listen<AsyncValue<User?>>(authProvider, (previous, current) {
      // Check if we just completed loading and have authenticated successfully
      if (previous?.isLoading == true &&
          current.hasValue &&
          current.value != null) {
        // Different navigation based on form type
        if (formType == AuthFormType.signUp) {
          // Navigate to HappyScreen after sign up
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HappyScreen()),
          );
        } else if (formType == AuthFormType.signIn) {
          // Navigate to MainScreen after sign in
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D26),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      // Navigate back or close modal
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Tab buttons
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF262A35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Sign In Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(authFormTypeProvider.notifier)
                              .state = AuthFormType.signIn,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: formType == AuthFormType.signIn
                                  ? const Color(0xFF262A35)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Sign in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: formType == AuthFormType.signIn
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sign Up Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(authFormTypeProvider.notifier)
                              .state = AuthFormType.signUp,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: formType == AuthFormType.signUp
                                  ? const Color(0xFF262A35)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: formType == AuthFormType.signUp
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Auth form
                AuthForm(formType: formType),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
