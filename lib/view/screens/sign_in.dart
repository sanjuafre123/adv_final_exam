import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  'SignIn',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
          SizedBox(
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
                      borderRadius: BorderRadius.circular(15)),
                  label: Text("Email"),
                ),
              )),
          SizedBox(
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
                      borderRadius: BorderRadius.circular(15)),
                  label: Text("Password"),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 65,
            width: w * .9,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  AuthService()
                      .loginWithEmail(
                          emailController.text, passwordController.text)
                      .then(
                    (value) {
                      if (value == "Login Successful") {
                        Get.snackbar("Login", "Login Successful");
                        Get.offAllNamed('/home');
                      } else {
                        Get.snackbar("Login", "$value",
                            backgroundColor: Colors.red);
                      }
                    },
                  );
                }

              },
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have and account?"),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                },
                child: Text("Sign Up"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
