import 'package:edp_smart_lock_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final String _title = 'Smart Lock Assistant';
  var currentIcon = Icons.lock_open_outlined;
  String titleString = 'Tap Below to Unlock';
  bool isLocked = true;
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/SignIn');
  }

  Future<void> _checkSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/SignIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkSignedIn();
    return MaterialApp(
      title: _title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Smart Lock Assistant'),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed('/RegisterLock');
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
                      setState(() {
                        if (isLocked) {
                          currentIcon = Icons.lock_open_outlined;
                          titleString = 'Tap Below to Unlock';
                          isLocked = false;
                        } else {
                          currentIcon = Icons.lock_outline;
                          titleString = 'Tap Below to Lock';
                          isLocked = true;
                        }
                      });
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
                      child: Text(
                        '${DateTime.now().hour}:${DateTime.now().minute}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                ],
              ))),
    );
  }
}
