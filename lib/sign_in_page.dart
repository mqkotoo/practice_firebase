import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    print(userCredential.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("サインイン"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signInAnonymously();
          },
          child: const Text('匿名ログイン'),
        ),
      ),
    );
  }
}
