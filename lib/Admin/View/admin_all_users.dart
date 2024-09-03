import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Admin/View/admin_deleted_users_history.dart';
import 'dart:io';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../Model/room_availability_model.dart';
import 'challans_screen.dart'; // Import the new screen

class AdminAllUsers extends StatefulWidget {
  const AdminAllUsers({Key? key}) : super(key: key);

  @override
  State<AdminAllUsers> createState() => _AdminAllUsersState();
}

class _AdminAllUsersState extends State<AdminAllUsers> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference deletedUsersCollection = FirebaseFirestore.instance.collection('deleted_users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppText(
          text: 'All Users',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AdminDeletedUsers());
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: usersCollection.snapshots(),
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

          final userList = snapshot.data!.docs;

          return userList.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final userData = userList[index].data() as Map<String, dynamic>;
                final userId = userList[index].id;

                return GestureDetector(
                  onTap: () {
                    showUserDetailsDialog(context, userData);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade50,
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            userData?['imageUrl'] != null
                                ? Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    userData!['imageUrl'],
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/person.png', width: 50, height: 50);
                                    },
                                  ),
                                ),
                              ),
                            )
                                : Image.asset('assets/person.png', width: 50, height: 50),
                            SizedBox(height: 10),
                            AppText(
                              text: userData != null && userData!['firstName'] != null
                                  ? userData!['firstName'].toLowerCase().substring(0, userData!['firstName'].length > 15 ? 15 : userData!['firstName'].length)
                                  : '',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),

                            SizedBox(height: 5),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Email: ${userData['email']}',
                              fontSize: 12,
                            ),
                            AppText(
                              text: 'Phone No: ${userData['phoneNumber']}',
                              fontSize: 12,
                            ),
                            AppText(
                              text: 'Block: ${userData['block']}',
                              fontSize: 12,
                            ),
                            AppText(
                              text: 'Room No: ${userData['room']}',
                              fontSize: 12,
                            ),
                            SizedBox(height: 5),
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
                                        content: Text('Are you sure you want to delete this user?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop(); // Close the dialog
                                              // Move user data to history collection
                                              await moveUserDataToHistory(userId, userData);
                                              // Delete user from main collection
                                              await usersCollection.doc(userId).delete();
                                            },
                                            child: Text('Delete'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
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

  void showUserDetailsDialog(BuildContext context, Map<String, dynamic> userData) async {
    // Fetch the user's block and room number
    String userBlock = userData['block'];
    String userRoomNo = userData['room'];
    String username = userData['firstName'];

    // Initialize counts
    int paidCount = 0;
    int unpaidCount = 0;

    // Fetch challans where block and roomNo match
    final challansSnapshot = await FirebaseFirestore.instance
        .collection('challan')
        .where('blockNo', isEqualTo: userBlock)
        .where('roomNo', isEqualTo: userRoomNo)
        .where('studentName', isEqualTo: username)
        .get();

    final challansList = challansSnapshot.docs;
    List<DocumentSnapshot> paidChallans = [];
    List<DocumentSnapshot> unpaidChallans = [];

    challansList.forEach((challan) {
      if (challan['status'] == 'Paid') {
        paidChallans.add(challan);
        paidCount++;
      } else {
        unpaidChallans.add(challan);
        unpaidCount++;
      }
    });

    // Show AlertDialog with user details and counts
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${userData['firstName']} ${userData['lastName']}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email: ${userData['email']}'),
                Text('Phone Number: ${userData['phoneNumber']}'),
                Text('Block: ${userData['block']}'),
                Text('Room: ${userData['room']}'),
                Text('Roll No: ${userData['rollNo']}'),
                Text('CNIC: ${userData['cnic']}'),
                SizedBox(height: 10),
                userData['cnicImageUrl'] != null
                    ? _buildImageWidget(userData['cnicImageUrl'])
                    : Container(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Paid Challans: $paidCount'),
                    CustomBotton(
                      borderRadius: 5,
                      height: 20,
                      width: 70,
                      fontSize: 8,
                      label: 'Show Challans',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChallansScreen(
                              challan: paidChallans,
                              isPaid: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Unpaid Challans: $unpaidCount'),
                    CustomBotton(
                      backgroundColor: Colors.teal,
                      borderRadius: 5,
                      height: 20,
                      width: 100,
                      fontSize: 8,
                      label: 'Show Unpaid Challans',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChallansScreen(
                              challan: unpaidChallans,
                              isPaid: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> moveUserDataToHistory(String userId, Map<String, dynamic> userData) async {
    try {
      // Add user data to deleted users collection
      await FirebaseFirestore.instance
          .collection('deletedUsers')
          .doc(userId)
          .set(userData);

      // Update room availability if user had a room assigned
      String? userBlock = userData['block'];
      String? userRoomNo = userData['room'];

      if (userBlock != null && userRoomNo != null) {
        // Create a reference to the room document
        DocumentReference roomDocRef = FirebaseFirestore.instance
            .collection('roomavailability')
            .doc('${userBlock}_Room$userRoomNo');

        // Run transaction to ensure atomicity
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot roomDoc = await transaction.get(roomDocRef);

          if (roomDoc.exists) {
            Map<String, dynamic>? roomData = roomDoc.data() as Map<String, dynamic>?;
            if (roomData != null) {
              int availableSeats = roomData['availableSeats'] ?? 0;
              availableSeats += 1;

              // Update the room availability in Firestore
              transaction.update(roomDocRef, {
                'availableSeats': availableSeats,
              });
            }
          }
        });
      }

      // Optionally, delete the user from the original collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .delete();

    } catch (e) {
      print('Error moving user data to history: $e');
    }
  }


  bool _isImage(String url) {
    final extension = url.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  Widget _buildImageWidget(String imageUrl) {
    try {
      final isImage = _isImage(imageUrl);

      return Container(
        width: 100,
        height: 150,
        child: isImage
            ? Image.file(
          File(imageUrl),
          fit: BoxFit.fill,
        )
            : PDFView(
          filePath: imageUrl,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: false,
          onRender: (pages) {
            print("Rendered $pages pages");
          },
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {});
          },
          onPageChanged: (int? page, int? total) {
            setState(() {});
            print('page change: $page/$total');
          },
        ),
      );
    } catch (e) {
      print('Error loading image: $e');
      return Container(); // Return an empty container or placeholder image
    }
  }

}
