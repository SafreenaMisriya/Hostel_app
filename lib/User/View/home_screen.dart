import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/Widgets/custom_card.dart';
import 'package:hostel_app/User/View/all_issues_screen.dart';
import 'package:hostel_app/User/View/profile_screen.dart';
import 'package:hostel_app/User/View/room_availability.dart';
import 'package:hostel_app/User/View/room_change_request.dart';
import 'package:hostel_app/User/View/staff_members_screen.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/routes/routes_name.dart';
import 'create_staff_screen.dart';
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
    FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((DocumentSnapshot userDoc) {
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    });
  }
// V
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppText(
          text: 'Home Screen',
          textColor: Colors.white,
          fontSize: 23,
        ),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,bottom: 5),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => ProfileScreen());
                },
                child:Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    border: Border.all(
                        width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:(userData != null && userData?["imageUrl"] != null && userData?["imageUrl"].isNotEmpty)
                    ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        value: progress.progress,
                      ),
                    ),
                    imageUrl: userData!["imageUrl"])
                    : SvgPicture.asset('assets/profile.svg',fit: BoxFit.cover,),),),),
          ),
        ],
      ),
      body: userData != null
          ?
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: userData != null && userData!['firstName'] != null
                                ? userData!['firstName'].toUpperCase().substring(0, userData!['firstName'].length > 15 ? 15 : userData!['firstName'].length)
                                : '',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(),
                          AppText(
                            text: 'Room No: ${userData?["room"]}',
                            fontSize: 16,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          AppText(
                            text: 'Block: ${userData?["block"]}',
                            fontSize: 16,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteName.createIssueScreen);
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.note_add_outlined,
                                size: 33,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const AppText(
                            text: 'Create Issues',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const AppText(
                text: 'Categories',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                children: [
                  CustomCard(
                      onTap: () {
                        Get.to(() => RoomAvailability());
                      },
                      text: 'Room Availability',
                      imgPath: 'assets/room_availability.png'),
                  CustomCard(
                      onTap: () {
                        Get.to(() => AllIssuesScreen());
                      },
                      text: 'All\n Issues', imgPath: 'assets/all_issues.png'),
                  CustomCard(
                      onTap: () {
                        Get.to(() => StaffMembersScreen());
                      },
                      text: 'Staff Members',
                      imgPath: 'assets/all_staff.png'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCard(
                      onTap: () {
                        Get.to(() => CreateStaffScreen());
                      },
                      text: 'Create\nStaff', imgPath: 'assets/create_staff.png'),
                  CustomCard(
                      onTap: () {
                        Get.to(() => HostelFee());
                      },
                      text: 'Hostel\nFee',
                      imgPath: 'assets/hostel_fees.png'),
                  CustomCard(
                      onTap: () {
                        Get.to(() => RoomChangeRequest());
                      },
                      text: 'Change Request',
                      imgPath: 'assets/change_requests.png'),
                ],
              ),
            ],
          ),
        ),
      ) : SizedBox(
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
}
