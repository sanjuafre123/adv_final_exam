import 'package:adv_final_exam/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TrackerProvider trackerProviderTrue =
        Provider.of<TrackerProvider>(context, listen: true);
    TrackerProvider trackerProviderFalse =
        Provider.of<TrackerProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text('GoogleLogin'),
      ),
      body: GestureDetector(
        onTap: () {
          trackerProviderTrue.signInWithGoogle();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
              width: double.infinity,
              child: Image.asset(
                'assets/Google.webp',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
