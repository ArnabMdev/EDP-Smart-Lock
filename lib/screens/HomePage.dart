import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edp_smart_lock_app/main.dart';
import 'package:edp_smart_lock_app/models/UnlockHistory.dart';
import 'package:edp_smart_lock_app/models/Lock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';


class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = LocalAuthentication();

  var titleString = 'Tap Below to Unlock';
  var _title = 'Smart Lock Assistant';
  var currentIcon = Icons.lock_open_outlined;
  var lastUnlocked = DateTime.now();
  var _canCheckBiometric = false;

  Lock? currentLock;
  List<BiometricType> _availableBiometric = [];

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/SignIn');
  }

  Future<void> _checkSignedIn() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/SignIn');
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('locks')
        .where('lockOwner', isEqualTo: user!.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final lockDoc = snapshot.docs.first;
      currentLock = Lock.fromMap(lockDoc.data(), lockDoc.reference.id);
      print(currentLock!.lockName);
    }

  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    }
    );
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticateBiometric() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Authenticate yourself to Unlock",
          useErrorDialogs: true,
          stickyAuth: true
      );
      await currentLock!.toggleLock();
    } catch (e) {
      print(e);
    }
    setState(() {
      var authorized = authenticated ? true : false;
      if(authorized){
        if(currentLock!.isLocked){
          titleString = "Tap below to Lock";
          currentIcon = Icons.lock_outline;
          lastUnlocked = DateTime.now();
          var unlockHistory = UnlockHistory(timestamp: DateTime.now().millisecondsSinceEpoch);
          unlockHistory. addUnlock();

        }else{
          titleString = "Tap below to Unlock";
          currentIcon = Icons.lock_open_outlined;
        }

      }
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkSignedIn(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return MaterialApp(
          title: _title,
          home: Scaffold(
              appBar: AppBar(
                title: const Text('Smart Lock Assistant'),
                backgroundColor: Colors.blue,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.mode_edit_outlined),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/RegisterLock');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/UnlockHistory');
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        _signOut();
                      })
                ],
              ),
              body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            titleString,
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.greenAccent, //<-- SEE HERE
                          padding: const EdgeInsets.all(100),
                        ),
                        onPressed: () {
                          _authenticateBiometric();
                        },
                        child: Icon(
                          currentIcon,
                          color: Colors.black,
                          size: 80,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Last unlocked at : ',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              '26th April 2023\n07:30 PM',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ],
                  ))),
        );

      },
    );
  }
}
