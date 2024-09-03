import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Admin/View/admin_all_staff_screen.dart';
import 'package:hostel_app/Admin/View/admin_hostel_fee_screen.dart';
import 'package:hostel_app/Admin/View/admin_profile_screen.dart';
import 'package:hostel_app/Res/Widgets/custom_card.dart';
import 'package:hostel_app/User/View/profile_screen.dart';
import 'package:hostel_app/User/View/room_availability.dart';
import 'package:hostel_app/User/View/room_change_request.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/routes/routes_name.dart';
import '../../User/View/hostel_fee.dart';
import 'admin_all_issues_screen.dart';
import 'admin_all_users.dart';
import 'admin_change_request.dart';
import 'admin_create_staff.dart';
import 'admin_room_availablty.dart';
import 'admin_update_room_availability_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppText(
          text: 'Dashboard',
          textColor: Colors.white,
          fontSize: 23,
        ),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => AdminProfileScreen());
                },
                child: SvgPicture.asset('assets/profile.svg')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('staff').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> staffSnapshot) {
                  if (staffSnapshot.hasError) {
                    return Center(
                      child: AppText(
                        text: 'Error: ${staffSnapshot.error}',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    );
                  }

                  if (staffSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final staffList = staffSnapshot.data!.docs;
                  int totalStaff = staffList.length;

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                      if (userSnapshot.hasError) {
                        return Center(
                          child: AppText(
                            text: 'Error: ${userSnapshot.error}',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        );
                      }

                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final userList = userSnapshot.data!.docs;
                      int bookedSeats = userList.length;
                      int availableSeats = 48 - bookedSeats;

                      return Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Admin Panel',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              const AppText(
                                text: 'Total Rooms: 12',
                                fontSize: 14,
                              ),
                              AppText(
                                text: 'Total Available Seats: $availableSeats',
                                fontSize: 14,
                              ),
                              AppText(
                                text: 'Total Booked Seats: $bookedSeats',
                                fontSize: 14,
                              ),
                              AppText(
                                text: 'Total Staff: $totalStaff',
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const AppText(
                text: 'Categories',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCard(
                    onTap: () {
                      Get.to(() => AdminRoomAvailability());
                    },
                    text: 'Room Availability',
                    imgPath: 'assets/room_availability.png',
                  ),
                  CustomCard(
                    onTap: () {
                      Get.to(() => AdminAllIssuesScreen());
                    },
                    text: 'All\n Issues',
                    imgPath: 'assets/all_issues.png',
                  ),
                  CustomCard(
                    onTap: () {
                      Get.to(() => AdminAllStaff());
                    },
                    text: 'Staff Members',
                    imgPath: 'assets/all_staff.png',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCard(
                    onTap: () {
                      Get.to(() => AdminAllUsers());
                    },
                    text: 'All \n Users',
                    imgPath: 'assets/student.png',
                  ),
                  CustomCard(
                    onTap: () {
                      Get.to(() => AdminHostelFeeScreen());
                    },
                    text: 'Hostel\nFee',
                    imgPath: 'assets/hostel_fees.png',
                  ),
                  CustomCard(
                    onTap: () {
                      Get.to(() => AdminChangeRequest());
                    },
                    text: 'Change Request',
                    imgPath: 'assets/change_requests.png',
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
