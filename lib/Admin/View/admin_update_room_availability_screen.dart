import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Res/Widgets/InternetConnectivityError.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../Model/room_availability_model.dart';


class UpdateRoomAvailabilityScreen extends StatefulWidget {
  const UpdateRoomAvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<UpdateRoomAvailabilityScreen> createState() => _UpdateRoomAvailabilityScreenState();
}

class _UpdateRoomAvailabilityScreenState extends State<UpdateRoomAvailabilityScreen> {
  final GlobalKey<FormState> _roomAvailablityFormKey = GlobalKey<FormState>();
  String? selectedRoom;
  String? selectedBlock;
  String? availableSeats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppText(
          text: 'Update Room Availability',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? InternetConnectivityError()
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _roomAvailablityFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  AppText(
                    text: 'Room No:',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    iconEnabledColor: Colors.green,
                    value: selectedRoom,
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
                    hint: Text('Select Room'),
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = value;
                      });
                    },
                    items: ['1', '2', '3', '4']
                        .map((room) => DropdownMenuItem(
                      value: room,
                      child: Text(room),
                    ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a room';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  AppText(
                    text: 'Block:',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    iconEnabledColor: Colors.green,
                    value: selectedBlock,
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
                    hint: Text('Select Block'),
                    onChanged: (value) {
                      setState(() {
                        selectedBlock = value;
                      });
                    },
                    items: ['A', 'B', 'C']
                        .map((block) => DropdownMenuItem(
                      value: block,
                      child: Text(block),
                    ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a block';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  AppText(
                    text: 'Available Seats:',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    iconEnabledColor: Colors.green,
                    value: availableSeats,
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
                    hint: Text('Select Capacity'),
                    onChanged: (value) {
                      setState(() {
                        availableSeats = value;
                      });
                    },
                    items: ['1', '2', '3', '4']
                        .map((capacity) => DropdownMenuItem(
                      value: capacity,
                      child: Text(capacity),
                    ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a capacity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  CustomBotton(
                    onTap: () {
                      if (_roomAvailablityFormKey.currentState!.validate()) {
                        saveRoomAvailability();
                      }
                    },
                    label: 'Create Available Seats',
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  void saveRoomAvailability() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    RoomAvailabilityModel roomAvailability = RoomAvailabilityModel(
      roomNumber: selectedRoom!,
      block: selectedBlock!,
      capacity: int.parse(availableSeats!),
    );

    final docId = '${roomAvailability.block}_Room${roomAvailability.roomNumber}';

    try {
      final docRef = FirebaseFirestore.instance.collection('roomavailability').doc(docId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        await docRef.update(roomAvailability.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room availability updated successfully')),
        );
      } else {
        // Create new document
        await docRef.set(roomAvailability.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room availability added successfully')),
        );
      }

      // Clear form fields upon successful submission
      setState(() {
        selectedRoom = null;
        selectedBlock = null;
        availableSeats = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating room availability: $error')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }
}


