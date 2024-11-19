import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 25),
                  )
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
                        borderRadius: BorderRadius.circular(15)),
                    label: const Text("Email"),
                  ),
                )),
            const SizedBox(
              height: 10,
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
                            .createAccountWithEmail(
                                emailController.text, passwordController.text)
                            .then((value) {
                          if (value == "Account Created") {
                            Get.snackbar(
                                "Account info", "Account created successfully");
                            Get.offAllNamed('/home');
                          } else {
                            Get.snackbar("Account info", value,
                                backgroundColor: Colors.red);
                          }
                        });
                      }
                    },
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/home');
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ),
                    ))),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have Account!",
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: Text(
                    "Login",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
