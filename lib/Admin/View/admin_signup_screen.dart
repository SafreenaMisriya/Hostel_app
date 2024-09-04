import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Admin/View/admin_login_screen.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';

import '../../Res/AppColors/appColors.dart';
import '../Auth/admin_firestore.dart';



class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({super.key});

  @override
  State<AdminSignUpScreen> createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  final GlobalKey<FormState> _adminRegisterFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  Future<void> registerAdmin(String email, String password) async {
    try {
      if (_adminRegisterFormKey.currentState!.validate()) {
        await AdminFirestoreService().addAdminToFirestore(
          emailController.text,
          passwordController.text,

        );
        Get.snackbar(
          'Success',
          'Admin registered successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => const AdminLoginScreen());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to register admin: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _adminRegisterFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Your existing UI widgets here...

                    // Email field with validation
                    const AppText(text: 'Email', fontSize: 16),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // You can add more complex email validation if needed
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password field with validation
                    const AppText(text: 'Password', fontSize: 16),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // You can add more complex password validation if needed
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    CustomBotton(
                      onTap: () {
                        if (_adminRegisterFormKey.currentState!.validate()) {
                          registerAdmin(emailController.text, passwordController.text);
                        }
                      },
                      label: 'Register',
                      backgroundColor: AppColors.blue3,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Already have an account?",
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const AdminLoginScreen());
                                },
                              text: ' Login',
                              style: const TextStyle(color: AppColors.blue3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
