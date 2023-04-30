import 'package:cloud_firestore/cloud_firestore.dart';

class Lock {
  String? lockId;
  String lockName;
  String lockLocation;
  String lockOwner;
  int? pinCode;
  bool isLocked;

  Lock({
    this.lockId,
    required this.lockName,
    required this.lockLocation,
    required this.pinCode,
    required this.lockOwner,
    required this.isLocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'lockId': lockId,
      'lockName': lockName,
      'lockLocation': lockLocation,
      'lockOwner': lockOwner,
      'isLocked': isLocked,
    };
  }

  static Lock fromMap(Map<String, dynamic> map,String id) {
    return Lock(
      lockId: id,
      lockName: map['lockName'],
      lockLocation: map['lockLocation'],
      pinCode: map['pinCode'],
      lockOwner: map['lockOwner'],
      isLocked: map['isLocked'],
    );
  }

  static Future<void> addLock(Lock lock) async {
    await FirebaseFirestore.instance.collection('locks').doc().set({
      'lockName': lock.lockName,
      'lockLocation' : lock.lockLocation,
      'lockOwner' : lock.lockOwner,
      'isLocked': lock.isLocked,
      'pinCode': lock.pinCode,
    });
  }

  Future<void> toggleLock() async {
    final lockRef = FirebaseFirestore.instance.collection('locks').doc(this.lockId);
    await lockRef.update({'isLocked': !isLocked});
  }
}
