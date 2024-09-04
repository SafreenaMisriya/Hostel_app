import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Res/AppColors/appColors.dart';
import '../../Res/Widgets/app_text.dart';

class RoomAvailability extends StatefulWidget {
  const RoomAvailability({super.key, });

  @override
  State<RoomAvailability> createState() => _RoomAvailabilityState();
}

class _RoomAvailabilityState extends State<RoomAvailability> {

  final CollectionReference roomsRef = FirebaseFirestore.instance.collection('roomavailability');

  @override
  void initState() {
    super.initState();
    initializeRoomsIfNeeded();
    roomsRef.snapshots().listen((_) {
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
    const roomsPerBlock = 4;
    const seatsPerRoom = 4;

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
        iconTheme: const IconThemeData(color:AppColors.blue3),
        centerTitle: true,
        title: const AppText(
          text: 'Room Availabilities',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: AppColors.blue3,
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: roomsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rooms available'));
          } else {
            List<DocumentSnapshot> rooms = snapshot.data!.docs;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.blue3,borderRadius: BorderRadius.circular(12)),
                    
                    child: buildCard(rooms[index])),
                );
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
      return const Card(
        child: ListTile(
          title: Text('Room Data not available'),
        ),
      );
    }

    final availableSeats = data['availableSeats'] ?? 0;
    final block = data['block'];
    final roomNumber = data['room'];

    return availableSeats > 0 ? Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border:Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipOval(child: Image.asset('assets/bed.jpg',height: 100,width: 100,)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Block: $block',style: const TextStyle(color: Colors.white),),
              Text('Room: $roomNumber',style: const TextStyle(color: Colors.white),),
              Text('Available Seats: $availableSeats',style: const TextStyle(color: Colors.white),),
            ],

          ),
        ],
      ),
    ) : Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      padding: const EdgeInsets.all(5),
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
              const Text('No seats Available',style: TextStyle(color: Colors.red),),
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
          transaction.update(roomRef, {
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
            const SnackBar(content: Text('Room registered successfully')),
          );
        } else {
          // No seats available
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No seats available for this room')),
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
