import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:practice_firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice_firebase/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const providerConfigs = [EmailProviderConfiguration()];
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const SignInPage(),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providerConfigs: providerConfigs,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providerConfigs: providerConfigs,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _users = _firestore.collection('users');
  // final Stream<QuerySnapshot> _userStream = _users.snapshots();
  final Stream<QuerySnapshot> _userStream = _users.snapshots();


    //????????????
  Future<void> addUser() async{
    await _users.add({
      'name': 'murakami',
      'age': 19
    });
    print("USER??????????????????????????????");
  }

//  ????????????
  Future<void> updateUser(String docId) async{
    await _users.doc(docId).update({
      'name': '???????????????',
      'age': 140
    });
    print("???????????????????????????");
  }

//  ????????????
  Future<void> deleteUser(String docId) async{
    await _users.doc(docId).delete();
    print("????????????????????????");
  }

//  ??????????????????????????????
  Future<void> deleteField(String docId) async{
    _users.doc(docId).update({
      'age': FieldValue.delete()
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {


          if(snapshot.hasError) {
            return const Text("?????????????????????????????????");
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text("?????????????????????");
          }else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }else {
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            return ListView(
              children: docs.map((doc) {
                Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
                String name = data["name"];
                int? age = data["age"];
                return ListTile(
                  title: Text(name),
                  // subtitle: Text(age.toString()),
                  onTap: () {
                    deleteField(doc.id);
                  },
                );
              }).toList(),
            );
          }
        },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
