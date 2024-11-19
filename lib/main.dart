
import 'package:adv_final_exam/provider/shopping_provider.dart';
import 'package:adv_final_exam/service/auth.dart';
import 'package:adv_final_exam/view/screens/SignUp.dart';
import 'package:adv_final_exam/view/screens/home_screen.dart';
import 'package:adv_final_exam/view/screens/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ShoppingProvider(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade800),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/', page: () => const LoginPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

void initState() {
  AuthService().isLoggedIn().then(
    (value) {
      if (value) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    },
  );
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
