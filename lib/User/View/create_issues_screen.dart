import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/Res/Widgets/CustomTextformField.dart';
import 'package:hostel_app/Res/Widgets/InternetConnectivityError.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../Model/create_issue_model.dart';

class CreateIssueScreen extends StatefulWidget {
  const CreateIssueScreen({Key? key}) : super(key: key);

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {

  final TextEditingController roomController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? issue;
  bool isLoading = false; // Loading state variable

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userData.exists) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        setState(() {
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          roomController.text = data['room'] ?? '';
          blockController.text = data['block'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phoneNumber'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveIssueData() async {
    setState(() {
      isLoading = true; // Set loading state to true when saving data starts
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String roomNumber = roomController.text.trim();
      String blockNumber = blockController.text.trim();
      String email = emailController.text.trim();
      String phoneNumber = phoneController.text.trim();
      String reason = reasonController.text.trim();

      if (firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          roomNumber.isNotEmpty &&
          blockNumber.isNotEmpty &&
          email.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          reason.isNotEmpty &&
          issue != null) {
        String status = 'Pending';
        IssueModel issueModel = IssueModel(
          firstName:firstName,
          lastName:lastName,
          roomNumber: roomNumber,
          blockNumber: blockNumber,
          email: email,
          phoneNumber: phoneNumber,
          reason: reason,
          issue: issue!,
          uid: uid,
          status: status,// Include user UID in the model
        );

        await FirebaseFirestore.instance
            .collection('studentissues')
            .add(issueModel.toMap());

        // Clear text fields after submitting
        firstNameController.clear();
        lastNameController.clear();
        roomController.clear();
        blockController.clear();
        emailController.clear();
        phoneController.clear();
        reasonController.clear();
        issue = null;

        setState(() {
          isLoading = false; // Set loading state to false after data is saved
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Issue submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        setState(() {
          isLoading = false; // Set loading state to false if fields are not filled
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppText(
          text: 'Create issues Screen',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: isLoading
            ?InternetConnectivityError()
            : Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: 'First Name', fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: firstNameController,
                    hintText: 'Enter your First Name',
                  ),
                  SizedBox(height: 10),
                  AppText(text: 'Last Name',fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: lastNameController,
                    hintText: 'Enter your Last Name',
                  ),
                  SizedBox(height: 10),
                  AppText(text: 'Room Number',fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    controller: roomController,
                    hintText: '1',
                  ),
                  SizedBox(height: 10),
                  AppText(text: 'Block',fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: blockController,
                    hintText: 'A',
                  ),
                  SizedBox(height: 10),
                  AppText(text: 'Email', fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: emailController,
                    hintText: 'Enter your Email',
                  ),
                  SizedBox(height: 10),
                  AppText(text: 'Phone Number', fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    hintText: 'Enter your Phone Number',
                  ),
                  SizedBox(height: 10),
                  AppText(text: 'Issue', fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          iconEnabledColor: Colors.green,
                          value: issue,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          hint: Text('Select Reason'),
                          onChanged: (value) {
                            setState(() {
                              issue = value;
                            });
                          },
                          items: ['AC not working', 'water issue', 'window not open']
                              .map((block) => DropdownMenuItem(
                            value: block,
                            child: Text(block),
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  AppText(text: 'Reason for change',fontWeight: FontWeight.w600,fontSize: 16,),
                  SizedBox(height: 20,),
                  CustomTextFormField(
                    height: 200,
                    maxLines: 5,
                    controller: reasonController,
                    hintText: 'Reason',
                  ),
                  CustomBotton(
                    onTap: saveIssueData,
                    label: isLoading?'Submitting...':'Submit',
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
