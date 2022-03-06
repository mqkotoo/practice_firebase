import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 匿名サインインのメソッド
  Future<void> signInAnonymously() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    print(userCredential.user);
  }

  // メールアドレス、パスワードでユーザー作成
  Future<void> createUserFromEmail() async{
    UserCredential userCredential = await  _auth.createUserWithEmailAndPassword(
        email: 'test@test.com',
        password: 'testtest'
    );
    print("Emailからユーザー作成完了");
  }

  Future<void> signInFromEmail() async{
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'testtest'
    );
    print(userCredential.user);
    print("rグイン完了");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("サインイン"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 匿名ログイン
            ElevatedButton(
              onPressed: () {
                createUserFromEmail();
              },
              child: const Text('アカウント作成'),
            ),
            // メール、パスワードログイン
            ElevatedButton(
              onPressed: () {
                signInFromEmail();
              },
              child: const Text('メールアドレスログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
