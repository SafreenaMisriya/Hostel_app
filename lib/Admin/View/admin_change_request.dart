import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Res/Widgets/InternetConnectivityError.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../../User/Model/room_change_request_model.dart';

class AdminChangeRequest extends StatefulWidget {
  const AdminChangeRequest({super.key});

  @override
  State<AdminChangeRequest> createState() => _AdminChangeRequestState();
}

class _AdminChangeRequestState extends State<AdminChangeRequest> {
  List<RoomChangeRequestModel> roomChangeRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoomChangeRequests();
  }

  Future<void> approveRequest(String requestId, String uid, String newBlock, String newRoomNo) async {
    await FirebaseFirestore.instance.collection('roomchangerequest').doc(requestId).update({'status': 'Approved'});
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'block': newBlock,
      'room': newRoomNo,
    });

    setState(() {
      roomChangeRequests.removeWhere((request) => request.requestId == requestId);
    });
  }

  Future<void> rejectRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('roomchangerequest').doc(requestId).update({'status': 'Rejected'});

    setState(() {
      roomChangeRequests.removeWhere((request) => request.requestId == requestId);
    });
  }

  void fetchRoomChangeRequests() async {
    QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('roomchangerequest')
        .where('status', isEqualTo: 'Pending')
        .get();
    setState(() {
      isLoading = false;
      roomChangeRequests = requestSnapshot.docs
          .map((doc) => RoomChangeRequestModel.fromMap(doc.data() as Map<String, dynamic>)
        ..requestId = doc.id) // Capture the document ID
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
          text: 'Room Change Requests',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? InternetConnectivityError()
          : roomChangeRequests.isEmpty
          ? Center(
        child: AppText(
          text: 'No room change requests found',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      )
          : ListView.builder(
        itemCount: roomChangeRequests.length,
        itemBuilder: (context, index) {
          RoomChangeRequestModel request = roomChangeRequests[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(text: 'Requested By: ', fontWeight: FontWeight.w600),
                    AppText(text: ' ${request.firstName} '),
                  ],
                ),
                Row(
                  children: [
                    AppText(text: 'Current Block: ', fontWeight: FontWeight.w600),
                    AppText(text: '${request.currentBlock}'),
                  ],
                ),
                Row(
                  children: [
                    AppText(text: 'Current Room No: ', fontWeight: FontWeight.w600),
                    AppText(text: '${request.currentRoomNo}'),
                  ],
                ),
                Row(
                  children: [
                    AppText(text: 'New Block: ', fontWeight: FontWeight.w600),
                    AppText(text: '${request.newBlock}'),
                  ],
                ),
                Row(
                  children: [
                    AppText(text: 'New Room No:', fontWeight: FontWeight.w600),
                    AppText(text: ' ${request.newRoomNo}'),
                  ],
                ),

                AppText(text: 'Reason: ',fontWeight: FontWeight.w600,),
                AppText(text: '${request.reason}',),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBotton(
                      height: 30,
                      width: 130,
                      label: 'Reject',
                      backgroundColor: Colors.red,
                      onTap: () {
                        rejectRequest(request.requestId!);
                      },
                    ),
                    CustomBotton(
                      height: 30,
                      width: 130,
                      label: 'Approve',
                      backgroundColor: Colors.green,
                      onTap: () {
                        approveRequest(
                          request.requestId!,
                          request.uid,
                          request.newBlock,
                          request.newRoomNo,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
