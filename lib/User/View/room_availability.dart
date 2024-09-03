import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Res/Widgets/app_text.dart';

class RoomAvailability extends StatefulWidget {
  const RoomAvailability({Key? key});

  @override
  State<RoomAvailability> createState() => _RoomAvailabilityState();
}

class _RoomAvailabilityState extends State<RoomAvailability> {

  final CollectionReference roomsRef = FirebaseFirestore.instance.collection('roomavailability');

  @override
  void initState() {
    super.initState();
    // Initialize rooms if needed (can be moved to a separate initialization method)
    initializeRoomsIfNeeded();
    // Set up Firestore listener to listen for changes in roomavailability collection
    roomsRef.snapshots().listen((_) {
      // Update the UI when changes occur
      setState(() {});
    });
  }

  Future<void> initializeRoomsIfNeeded() async {
    QuerySnapshot querySnapshot = await roomsRef.get();
    if (querySnapshot.docs.isEmpty) {
      // Initialize rooms if collection is empty
      await initializeRooms();
    }
  }

  Future<void> initializeRooms() async {
    final blocks = ['A', 'B', 'C'];
    final roomsPerBlock = 4;
    final seatsPerRoom = 4;

    for (String block in blocks) {
      for (int roomNumber = 1; roomNumber <= roomsPerBlock; roomNumber++) {
        final docId = '${block}_Room$roomNumber';
        await roomsRef.doc(docId).set({
          'block': block,
          'room': '$roomNumber', // Store roomNumber as a string
          'availableSeats': seatsPerRoom,
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
          text: 'Room Availabilities',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: roomsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No rooms available'));
          } else {
            List<DocumentSnapshot> rooms = snapshot.data!.docs;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return buildCard(rooms[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildCard(DocumentSnapshot room) {
    final data = room.data() as Map<String, dynamic>?;

    if (data == null) {
      return Card(
        child: ListTile(
          title: Text('Room Data not available'),
        ),
      );
    }

    final availableSeats = data['availableSeats'] ?? 0;
    final block = data['block'];
    final roomNumber = data['room'];

    return availableSeats > 0 ? Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border:Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/bed.png',height: 100,width: 100,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Block: $block'),
              Text('Room: $roomNumber'),
              Text('Available Seats: $availableSeats'),
            ],

          ),
        ],
      ),
    ) : Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border:Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/bed.png',height: 100,width: 100,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Block: $block'),
              Text('Room: $roomNumber'),
              Text('No seats Available',style: TextStyle(color: Colors.red),),
            ],

          ),
        ],
      ),
    );
  }


  // Function to handle room registration
  void registerRoom(DocumentReference roomRef) async {
    final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot roomSnapshot = await transaction.get(roomRef);
        int currentAvailableSeats = roomSnapshot['availableSeats'];

        if (currentAvailableSeats > 0) {
          // Update available seats
          await transaction.update(roomRef, {
            'availableSeats': currentAvailableSeats - 1,
          });

          // Add user registration to 'users' collection
          await usersRef.add({
            'block': roomSnapshot['block'],
            'room': roomSnapshot['room'], // Assuming 'roomNumber' is the correct field
            // Add other user details here
          });

          // Inform user registration successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Room registered successfully')),
          );
        } else {
          // No seats available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No seats available for this room')),
          );
        }
      });
    } catch (error) {
      // Handle transaction errors
      print('Transaction failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: $error')),
      );
    }
  }


}
