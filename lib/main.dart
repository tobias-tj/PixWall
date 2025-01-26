import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pix_wall/admin/admin_login.dart';
import 'package:pix_wall/admin/home_admin.dart';
import 'package:pix_wall/bottom_nav.dart';
import 'package:pix_wall/go_router.dart';
import 'package:pix_wall/user/user_login.dart';
import 'package:pix_wall/user/user_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carga las variables del archivo .env
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PixWall',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 197, 197, 198)),
        useMaterial3: true,
      ),
    );
  }
}
