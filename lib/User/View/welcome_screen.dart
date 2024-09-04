import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';

import '../../Admin/View/admin_login_screen.dart';
import '../../Res/AppColors/appColors.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText(
                text: 'WELCOME',
                fontWeight: FontWeight.w600,
                fontSize: 30,
                textColor: AppColors.blue2,
              ),
              const SizedBox(
                height: 30,
              ),
              Image.asset('assets/welcome.png'),
              const SizedBox(
                height: 30,
              ),
              const AppText(
                text: 'Login as a',
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomBotton(
                onTap: () {
                  Get.to(
                    () => const AdminLoginScreen(),
                  );
                },
                label: 'Admin Login',
                backgroundColor: AppColors.blue3,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomBotton(
                onTap: () {
                  Get.to(
                    () => const LoginScreen(),
                  );
                },
                label: 'User Login',
                backgroundColor: AppColors.blue3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
