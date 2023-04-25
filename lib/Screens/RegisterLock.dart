import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edp_smart_lock_app/Models/Lock.dart';
import 'package:edp_smart_lock_app/utils/fire_auth.dart';
import 'package:edp_smart_lock_app/utils/validator.dart';

class RegisterLock extends StatelessWidget {
  const RegisterLock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Lock'),
      ),
      body: const RegisterLockForm(),
    );
  }
}

class RegisterLockForm extends StatefulWidget {
  const RegisterLockForm({Key? key}) : super(key: key);

  @override
  _RegisterLockFormState createState() => _RegisterLockFormState();
}

class _RegisterLockFormState extends State<RegisterLockForm> {
  final _formKey = GlobalKey<FormState>();

  final _lockNameTextController = TextEditingController();
  final _lockLocationTextController = TextEditingController();

  final _focusLockName = FocusNode();
  final _focusLockLocation = FocusNode();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushNamed('/SignIn');
    }
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          _focusLockName.unfocus();
          _focusLockLocation.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Icon(Icons.lock_outline, size: 200.0, color: Colors.black),
                ),
                TextFormField(
                  controller: _lockNameTextController,
                  focusNode: _focusLockName,
                  validator: (value) => Validator.validateName(
                    name: value!,
                  ),
                  decoration: InputDecoration(
                    hintText: "Lock Name",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _lockLocationTextController,
                  focusNode: _focusLockLocation,
                  validator: (value) => Validator.validateName(name: value!),
                  decoration: InputDecoration(
                    hintText: "Lock Location",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    child: const Text('Register Lock'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Lock lock = Lock(
                          lockName: _lockNameTextController.text,
                          lockLocation: _lockLocationTextController.text,
                          lastUnlocked: DateTime.now().millisecondsSinceEpoch,
                          isLocked: true,
                          lockOwner: user!.uid,
                        );
                        await FirebaseFirestore.instance
                            .collection('locks')
                            .add(lock.toMap());
                        await _showSuccessDialog();
                        Navigator.of(context).pushNamedAndRemoveUntil('/HomePage', ModalRoute.withName('/SignIn'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You have successfully registered a lock!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
