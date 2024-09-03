import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hostel_app/Admin/View/admin_create_staff.dart';

import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';

class AdminAllStaff extends StatefulWidget {
  const AdminAllStaff({Key? key}) : super(key: key);

  @override
  State<AdminAllStaff> createState() => _AdminAllStaffState();
}

class _AdminAllStaffState extends State<AdminAllStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppText(
          text: 'All Staff',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        actions: [
          IconButton(onPressed: () {
            Get.to(()=>AdminCreateStaff());
          }, icon: Icon(Icons.add)),
        ],
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('staff').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final staffList = snapshot.data!.docs;

          return staffList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: staffList.length,
                    itemBuilder: (context, index) {
                      final staffData =
                          staffList[index].data() as Map<String, dynamic>;
                      final staffId = staffList[index].id;

                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green.shade50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/person.png',
                                  width: 70,
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AppText(
                                  text:
                                      '${staffData['firstName']} ${staffData['lastName']}',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Job Role: ${staffData['jobRole']}',
                                  fontSize: 12,
                                ),
                                SizedBox(height: 5),
                                AppText(
                                  text: 'Email: ${staffData['email']}',
                                  fontSize: 12,
                                ),
                                SizedBox(height: 5),
                                AppText(
                                  text: 'Phone No: ${staffData['phoneNumber']}',
                                  fontSize: 12,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomBotton(
                                      fontSize: 10,
                                      borderRadius: 5,
                                      width: 60,
                                      height: 25,
                                      label: 'Delete',
                                      backgroundColor: Colors.red,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Confirm Delete'),
                                            content: Text(
                                                'Are you sure you want to delete this staff member?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('staff')
                                                      .doc(staffId)
                                                      .delete();
                                                },
                                                child: Text('Delete'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Cancel'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: AppText(
                    text: 'No Data Found',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
        },
      ),
    );
  }
}
