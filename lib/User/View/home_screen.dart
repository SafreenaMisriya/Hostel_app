import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/Widgets/custom_card.dart';
import 'package:hostel_app/User/View/all_issues_screen.dart';
import 'package:hostel_app/User/View/profile_screen.dart';
import 'package:hostel_app/User/View/room_availability.dart';
import 'package:hostel_app/User/View/room_change_request.dart';
import '../../Res/AppColors/appColors.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/routes/routes_name.dart';
import 'hostel_fee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the screen initializes
  }

  void fetchUserData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((DocumentSnapshot userDoc) {
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    });
  }

// V
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppText(
          text: 'Home Screen',
          textColor: AppColors.blue3,
          fontSize: 23,
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const ProfileScreen());
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(width: 2, color: AppColors.blue1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: (userData != null &&
                          userData?["imageUrl"] != null &&
                          userData?["imageUrl"].isNotEmpty)
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.blue3,
                                  value: progress.progress,
                                ),
                              ),
                          imageUrl: userData!["imageUrl"])
                      : SvgPicture.asset(
                          'assets/profile.svg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: userData != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 600,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                                height: 210,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: AppColors.blue3,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: userdata()))),
                        Positioned(
                          top: 190,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: AppText(
                                    text: 'Categories',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    padding: const EdgeInsets.all(10),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: 1.1,
                                    ),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      final cardData = [
                                        {
                                          'text': 'Room Availability',
                                          'imgPath':
                                              'assets/room_availability.png',
                                          'onTap': () =>
                                              Get.to(() => const RoomAvailability())
                                        },
                                        {
                                          'text': 'All Issues',
                                          'imgPath': 'assets/all_issues.png',
                                          'onTap': () =>
                                              Get.to(() => const AllIssuesScreen())
                                        },
                                        {
                                          'text': 'Hostel Fee',
                                          'imgPath': 'assets/hostel_fees.png',
                                          'onTap': () =>
                                              Get.to(() => const HostelFee())
                                        },
                                        {
                                          'text': 'Change Request',
                                          'imgPath':
                                              'assets/change_requests.png',
                                          'onTap': () =>
                                              Get.to(() => const RoomChangeRequest())
                                        },
                                      ];
                                      return CustomCard(
                                        text: cardData[index]['text'],
                                        imgPath: cardData[index]['imgPath'],
                                        onTap: cardData[index]['onTap']
                                            as Function()?,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(
              height: 40,
              width: 30,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ],
                ),
              )),
    );
  }

  userdata() {
    return Container(
      height: 120,
      width: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blue1, AppColors.blue2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                AppText(
                  text: userData != null && userData!['firstName'] != null
                      ? userData!['firstName'].toUpperCase().substring(
                          0,
                          userData!['firstName'].length > 16
                              ? 16
                              : userData!['firstName'].length)
                      : '',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 10,),
                AppText(
                  text: 'Room No: ${userData?["room"]}',
                  fontSize: 16,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 10,),
                AppText(
                  text: 'Block: ${userData?["block"]}',
                  fontSize: 16,
                  textColor: Colors.white,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.createIssueScreen);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue1,
                    ),
                    child: const Icon(
                      Icons.note_add_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const AppText(
                  text: 'Create Issues',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
