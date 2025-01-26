import 'package:go_router/go_router.dart';
import 'package:pix_wall/admin/add_wallpaper.dart';
import 'package:pix_wall/admin/admin_login.dart';
import 'package:pix_wall/bottom_nav.dart';
import 'package:pix_wall/pages/full_screen.dart';
import 'package:pix_wall/services/auth_service.dart';
import 'package:pix_wall/user/user_register.dart';
import 'admin/home_admin.dart';
import 'user/user_login.dart';

final AuthService authService = AuthService();

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        redirect: (context, state) async {
          final isLoggedIn = await authService.isLoggedIn();
          if (isLoggedIn) {
            final role = await authService.getRole();
            return role == 'admin' ? '/admin/home' : '/user/home';
          }
          return '/login';
        },
        ),
    GoRoute(
      path: '/login',
      name: 'Login',
      builder: (context, state) => const UserLogin(),
    ),
    GoRoute(
        path: '/register',
        name: 'Register',
        builder: (context, state) => const UserRegister()),
    GoRoute(
      path: '/admin/login',
      name: 'AdminLogin',
      builder: (context, state) => AdminLogin(),
    ),
    GoRoute(
      path: '/admin/home',
      name: 'HomeAdmin',
      builder: (context, state) => const HomeAdmin(),
    ),
    GoRoute(
        path: '/admin/addWallpaper',
        name: 'AddWallpaper',
        builder: (context, state) => const AddWallpaper()),
    GoRoute(
      path: '/user/home',
      name: 'HomeUser',
      builder: (context, state) => const BottomNav(),
    ),
    GoRoute(
      path: '/fullscreen',
      name: 'FullScreen',
      builder: (context, state) {
        // Recibe el parámetro `imagePath` desde el estado
        final imagePath = state.extra as String;
        return FullScreen(imagePath: imagePath);
      },
    ),
  ],
);
