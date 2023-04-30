import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnlockHistoryScreen extends StatelessWidget {
  final CollectionReference unlockHistoryRef =
  FirebaseFirestore.instance.collection('unlock_history');

  String MonthName(int month){
    switch(month)
    {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return  "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      default:
        return "December";
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Unlock History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: unlockHistoryRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No unlock history found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int index) {
              var timestamp = docs[index].get('timestamp');
              DateTime unlockTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              return Card(
                child: ListTile(
                  title: Text('Unlocked at ${unlockTime.day.toString()} ${MonthName(unlockTime.month)} ${unlockTime.year} at ${unlockTime.hour.toString().length==1?'0${unlockTime.hour}':unlockTime.hour.toString()}:${unlockTime.minute.toString().length==1?'0${unlockTime.minute}':unlockTime.minute.toString()}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
