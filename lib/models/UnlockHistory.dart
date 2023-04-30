import 'package:cloud_firestore/cloud_firestore.dart';

class UnlockHistory {
  String? id;
  final int timestamp;

  UnlockHistory({
    this.id,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
    };
  }

  static UnlockHistory fromMap(Map<String, dynamic> map) {
    return UnlockHistory(
      id: map['id'],
      timestamp: map['timestamp'],
    );
  }

  Future<void> addUnlock() async {
    final CollectionReference unlockCollection =
    FirebaseFirestore.instance.collection('unlock_history');
    await unlockCollection.add(this.toMap()).then((documentReference) {
      id = documentReference.id;
    });
  }

  static Future<int> fetchLatestUnlock() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('unlock_history')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final unlockDoc = snapshot.docs.first;
      final unlockHistory = UnlockHistory.fromMap(unlockDoc.data());
      return unlockHistory.timestamp;
    } else {
      throw Exception('No locks found in Firestore');
    }
  }
}
