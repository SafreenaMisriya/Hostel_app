import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Admin/View/admin_all_staff_screen.dart';
import 'package:hostel_app/Admin/View/admin_hostel_fee_screen.dart';
import 'package:hostel_app/Admin/View/admin_profile_screen.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/custom_card.dart';
import '../../Res/Widgets/app_text.dart';
import 'admin_all_issues_screen.dart';
import 'admin_all_users.dart';
import 'admin_change_request.dart';
import 'admin_room_availablty.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppText(
          text: 'Dashboard',
          textColor: Colors.black,
          fontSize: 23,
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const AdminProfileScreen());
                },
                child: SvgPicture.asset('assets/profile.svg')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 800,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.blue3,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 30, left: 4, right: 4),
                          child: adminpanel(),
                        )),
                  ),
                  Positioned(
                    top: 150,
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
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                final cardData = [
                                  {
                                    'text': 'Room Availability',
                                    'imgPath': 'assets/room_availability.png',
                                    'onTap': () =>
                                        Get.to(() => const AdminRoomAvailability())
                                  },
                                  {
                                    'text': 'All Issues',
                                    'imgPath': 'assets/all_issues.png',
                                    'onTap': () =>
                                        Get.to(() => const AdminAllIssuesScreen())
                                  },
                                  {
                                    'text': 'Staff Members',
                                    'imgPath': 'assets/all_staff.png',
                                    'onTap': () => Get.to(() => const AdminAllStaff())
                                  },
                                  {
                                    'text': 'All Users',
                                    'imgPath': 'assets/student.png',
                                    'onTap': () => Get.to(() => const AdminAllUsers())
                                  },
                                  {
                                    'text': 'Hostel Fee',
                                    'imgPath': 'assets/hostel_fees.png',
                                    'onTap': () =>
                                        Get.to(() => const AdminHostelFeeScreen())
                                  },
                                  {
                                    'text': 'Change Request',
                                    'imgPath': 'assets/change_requests.png',
                                    'onTap': () =>
                                        Get.to(() => const AdminChangeRequest())
                                  },
                                ];
                                return CustomCard(
                                  text: cardData[index]['text'],
                                  imgPath: cardData[index]['imgPath'],
                                  onTap:
                                      cardData[index]['onTap'] as Function()?,
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
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> adminpanel() {
    return StreamBuilder(
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
          return const Center(
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final userList = userSnapshot.data!.docs;
            int bookedSeats = userList.length;
            int availableSeats = 48 - bookedSeats;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buidcontainer('12', 'Total Rooms'),
                buidcontainer('$availableSeats', 'Available Seats'),
                buidcontainer('$bookedSeats', 'Booked Seats'),
                buidcontainer('$totalStaff', 'Total Staffs'),
              ],
            );
          },
        );
      },
    );
  }

  buidcontainer(String number, String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
             gradient: const LinearGradient(
            colors: [AppColors.blue1, AppColors.blue2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
              borderRadius: BorderRadius.circular(12), ),
          height: 90,
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.white),
                ),
              ),
            ],
          )),
    );
  }
}
