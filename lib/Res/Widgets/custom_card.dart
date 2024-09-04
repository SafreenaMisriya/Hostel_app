import 'package:flutter/material.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';

import 'app_text.dart';

class CustomCard extends StatelessWidget {
  final dynamic text, imgPath;
  final Function()? onTap;
  const CustomCard(
      {super.key, required this.text, required this.imgPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 150,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.bgcolor,
              ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  imgPath,
                  height: 90,
                ),
                const Spacer(),
                AppText(
                  text: text,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
