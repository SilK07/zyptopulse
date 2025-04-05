import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth state enum
enum AuthState { initial, authenticated, unauthenticated, loading, error }

// Auth state notifier
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final user = await _authService.getCurrentUser();
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signIn(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signUp(String email, String password,
      {String? firstName, String? lastName}) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}

// Auth notifier provider
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Auth form state provider
enum AuthFormType { signIn, signUp }

final authFormTypeProvider =
    StateProvider<AuthFormType>((ref) => AuthFormType.signIn);
