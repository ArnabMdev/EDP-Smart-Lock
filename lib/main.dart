import 'package:edp_smart_lock_app/Screens/HomePage.dart';
import 'package:edp_smart_lock_app/Screens/RegisterLock.dart';
import 'package:edp_smart_lock_app/Screens/SignIn.dart';
import 'package:edp_smart_lock_app/Screens/SignUp.dart';
import 'package:edp_smart_lock_app/screens/UnlockHistoryPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Smart Lock Assistant';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      initialRoute: '/HomePage',
      routes: {
        '/SignIn' : (context) => SignIn(),
        '/SignUp' : (context) =>  const SignUp(),
        '/HomePage' : (context) =>  HomePage(),
        '/RegisterLock' : (context) =>  const RegisterLock(),
        '/UnlockHistory' : (context) => UnlockHistoryScreen(),
      },
    );
  }
}

