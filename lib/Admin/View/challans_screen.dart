import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChallansScreen extends StatelessWidget {
  final List<DocumentSnapshot> challan;
  final bool isPaid;

  const ChallansScreen({
    Key? key,
    required this.challan,
    required this.isPaid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          isPaid ? 'Paid Challans' : 'Unpaid Challans',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: challan.isNotEmpty
          ? ListView.builder(
              itemCount: challan.length,
              itemBuilder: (context, index) {
                final challans = challan[index].data() as Map<String, dynamic>;
                return Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isPaid ? Colors.green.shade100:Colors.red.shade100,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Challan No: '),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.teal
                              ),
                              child: Text('${challans['challanNumber']}',style: TextStyle(color: Colors.white,fontSize: 12),)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('UserName: '),
                          Text('${challans['studentName']}'),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Issue date:'),
                        Text('${DateFormat('dd-MM-yyyy').format(challans['issueDate'].toDate().toLocal())}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Due date: '),
                          Text('${DateFormat('dd-MM-yyyy').format(challans['dueDate'].toDate().toLocal())}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('MessFee: '),
                          Text('${challans['messFee']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ParkingCharges: '),
                          Text('${challans['parkingCharges']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ElectricityFee: '),
                          Text('${challans['electricityFee']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('WaterCharges: '),
                          Text('${challans['waterCharges']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('RoomCharges: '),
                          Text('${challans['roomCharges']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Before DueDate:'),
                          Text('${challans['beforeDueDate']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('After DueDate:'),
                          Text('${challans['afterDueDate']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status: '),
                          Container( padding: EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:isPaid ? Colors.green: Colors.orange
                              ),
                              child: Text('${challans['status']}',style: TextStyle(color: Colors.white,fontSize: 10),)),
                        ],
                      ),
                    ],
                  ),
                );
              })
          : Center(child: Text('No record found')),
    );
  }
}
