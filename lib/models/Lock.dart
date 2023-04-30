import 'package:cloud_firestore/cloud_firestore.dart';


class Lock {
  String lockName;
  String lockLocation;
  String lockOwner;
  int lastUnlocked;
  bool isLocked;

  Lock({
    required this.lockName,
    required this.lockLocation,
    required this.lockOwner,
    required this.lastUnlocked,
    required this.isLocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'lockName': lockName,
      'lockLocation': lockLocation,
      'lockOwner': lockOwner,
      'lastUnlocked': lastUnlocked,
      'isUnlocked': isLocked,
    };
  }

  static Lock fromMap(Map<String, dynamic> map) {
    return Lock(
      lockName: map['lockName'],
      lockLocation: map['lockLocation'],
      lockOwner: map['lockOwner'],
      lastUnlocked: map['lastUnlocked'],
      isLocked: map['isUnlocked'],
    );
  }

  Future<void> addLock(Lock lock) async {
    await FirebaseFirestore.instance.collection('locks').add({
      'lockName': lock.lockName,
      'lockLocation' : lock.lockLocation,
      'lockOwner' : lock.lockOwner,
      'lastUnlocked' : lock.lastUnlocked,
      'isLocked': lock.isLocked,
    });
  }
}