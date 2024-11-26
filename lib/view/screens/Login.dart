import 'package:adv_final_exam/view/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/auth.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  'SignIn',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              width: w * .9,
              child: TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Email cannot be empty." : null,
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7)),
                  label: Text("Email"),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: w * 0.9,
              child: TextFormField(
                validator: (value) => value!.length < 8
                    ? "Password should have at least 8 characters."
                    : null,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7)),
                  label: const Text("Password"),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 65,
            width: w * .9,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await AuthService()
                      .loginWithEmail(
                          emailController.text, passwordController.text)
                      .then(
                    (value) {
                      if (value == "Login Successful") {
                        Get.snackbar("Login", "Login Successful");
                        Get.offAllNamed('/home');
                      } else {
                        Get.snackbar(
                          "Login",
                          "$value",
                          backgroundColor: Colors.red,
                        );
                      }
                    },
                  );
                }
              },
              child: const Text(
                "Log In",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have and account?"),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
