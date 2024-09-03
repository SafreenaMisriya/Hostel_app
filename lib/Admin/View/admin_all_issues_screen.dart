import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/Widgets/InternetConnectivityError.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../../User/Model/create_issue_model.dart';
import 'admin_issues_history_screen.dart';

class AdminAllIssuesScreen extends StatefulWidget {
  const AdminAllIssuesScreen({super.key});

  @override
  State<AdminAllIssuesScreen> createState() => _AdminAllIssuesScreenState();
}

class _AdminAllIssuesScreenState extends State<AdminAllIssuesScreen> {
  List<IssueModel> issuesList = [];
  bool isLoading = true;
  Map<String, dynamic>? userData;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
        userId = uid;
        fetchAllIssuesData(); // Fetch issues after getting user data
      });
    }
  }

  void fetchAllIssuesData() async {
    QuerySnapshot issuesSnapshot = await FirebaseFirestore.instance
        .collection('studentissues')
        .where('status', isEqualTo: 'Pending')
        .get();
    setState(() {
      isLoading = false;
      issuesList = issuesSnapshot.docs
          .map((doc) => IssueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> resolveIssue(String issueId, Map<String, dynamic> issueData) async {
    try {
      // Move issue to resolvedissues collection
      await FirebaseFirestore.instance.collection('resolvedissues').doc(issueId).set(issueData);

      // Update status in studentissues collection and delete it
      await FirebaseFirestore.instance.collection('studentissues').doc(issueId).delete();

      // Update UI
      fetchAllIssuesData();
    } catch (e) {
      print('Error resolving issue: $e');
    }
  }

  Future<void> rejectIssue(String issueId, Map<String, dynamic> issueData) async {
    try {
      // Move issue to rejectedissues collection
      await FirebaseFirestore.instance.collection('rejectedissues').doc(issueId).set(issueData);

      // Update status in studentissues collection and delete it
      await FirebaseFirestore.instance.collection('studentissues').doc(issueId).delete();

      // Update UI
      fetchAllIssuesData();
    } catch (e) {
      print('Error rejecting issue: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppText(
          text: 'Students Issues',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AdminIssuesHistory());
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
      body: isLoading
          ? InternetConnectivityError()
          : issuesList.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.builder(
          itemCount: issuesList.length,
          itemBuilder: (context, index) {
            IssueModel issue = issuesList[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(height: 5),
                          AppText(
                            text: '${issue.firstName}'.length > 16 ? ' ${issue.firstName}'.substring(0, 16) : ' ${issue.firstName}',
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Username: ${issue.firstName}',
                            fontSize: 10,
                          ),
                          SizedBox(height: 10),
                          AppText(
                            text: 'Room Number: ${issue.roomNumber}',
                            fontSize: 10,
                          ),
                          SizedBox(height: 10),
                          AppText(
                            text: 'Email Id: ${issue.email}',
                            fontSize: 10,
                          ),
                          SizedBox(height: 10),
                          AppText(
                            text: 'Phone No: ${issue.phoneNumber}',
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Issue: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextSpan(
                          text: issue.issue ?? '',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Student Comment: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextSpan(
                          text: issue.reason ?? '',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomBotton(
                        width: 140,
                        height: 30,
                        onTap: () => resolveIssue(issue.id!, issue.toMap()),
                        label: 'Resolve',
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(width: 15),
                      CustomBotton(
                        width: 140,
                        height: 30,
                        onTap: () => rejectIssue(issue.id!, issue.toMap()),
                        label: 'Reject',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
      ),
    );
  }
}
