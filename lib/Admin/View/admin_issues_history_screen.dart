import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Res/Widgets/app_text.dart';
import '../../User/Model/create_issue_model.dart';

class AdminIssuesHistory extends StatefulWidget {
  const AdminIssuesHistory({super.key});

  @override
  State<AdminIssuesHistory> createState() => _AdminIssuesHistoryState();
}

class _AdminIssuesHistoryState extends State<AdminIssuesHistory> {
  List<IssueModel> resolvedIssuesList = [];
  List<IssueModel> rejectedIssuesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllIssuesHistoryData();
  }

  void fetchAllIssuesHistoryData() async {
    QuerySnapshot resolvedIssuesSnapshot = await FirebaseFirestore.instance
        .collection('resolvedissues')
        .get();

    QuerySnapshot rejectedIssuesSnapshot = await FirebaseFirestore.instance
        .collection('rejectedissues')
        .get();

    setState(() {
      isLoading = false;
      resolvedIssuesList = resolvedIssuesSnapshot.docs
          .map((doc) => IssueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      rejectedIssuesList = rejectedIssuesSnapshot.docs
          .map((doc) => IssueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppText(
          text: 'Issues History',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : resolvedIssuesList.isNotEmpty || rejectedIssuesList.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            if (resolvedIssuesList.isNotEmpty) ...[
              AppText(
                textAlign: TextAlign.center,
                text: 'Resolved Issues',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              SizedBox(height: 10,),
              ...resolvedIssuesList.map((issue) => buildIssueItem(issue)).toList(),
            ],
            if (rejectedIssuesList.isNotEmpty) ...[
              AppText(
                textAlign: TextAlign.center,
                text: 'Rejected Issues',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              SizedBox(height: 10,),
              ...rejectedIssuesList.map((issue) => buildIssueItem(issue)).toList(),
            ],
          ],
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

  Widget buildIssueItem(IssueModel issue) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              AppText(
                text: 'Username:',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: '${issue.firstName}'.toUpperCase(),
                fontSize: 12,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Room Number: ',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: ' ${issue.roomNumber}',
                fontSize: 12,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Email Id: ',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: ' ${issue.email}',
                fontSize: 12,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Phone No:',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: '${issue.phoneNumber}',
                fontSize: 12,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Issue: ',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: '${issue.issue}',
                fontSize: 12,
              ),
            ],
          ),
          AppText(
            text: 'Student Comment: ',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          AppText(
            text: ' ${issue.reason}',
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
