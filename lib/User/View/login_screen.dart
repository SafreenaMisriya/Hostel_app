import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/User/Controller/login_controller.dart';
import 'package:hostel_app/User/View/register_screen.dart';
import 'package:hostel_app/User/View/welcome_screen.dart';

import '../../Res/Widgets/CustomTextformField.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());
  void resendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
          'Verification Email Sent',
          'A verification email has been sent to ${user.email}.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification email.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.to(() => WelcomeScreen());
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/logo.jpg', width: 200, height: 200),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: AppText(
                        text: 'Login your account',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    AppText(text: 'Email', fontSize: 16),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Email',
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    AppText(text: 'Password', fontSize: 16),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Password',
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ForgetPassword()));
                            },
                            child: const Text(
                              "Forget Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54),
                            ),
                          ),
                        )),
                    SizedBox(height: 40),
                    Obx(() {
                      return CustomBotton(
                        onTap: controller.isLoading.value ? null : controller.login,
                        label: controller.isLoading.value ? 'Loading...' : 'Login',
                        backgroundColor: controller.isLoading.value ? Colors.grey : Colors.green,
                      );
                    }),
                    SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Didn't have an account?",
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => RegisterScreen());
                                },
                              text: ' Register',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: resendVerificationEmail,
                        child: Text(
                          'Resend Verification Email',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
