import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final Stream<QuerySnapshot> _userStream = _users.where("name", isEqualTo: "murakami").snapshots();

  Future<void> addUser() async{
    await _users.add({
      'name': '吉野ヶ里遺跡',
      'age': 19
    });
    print("USER情報を追加しました。");
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
            return const Text("エラーが発生しました！");
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text("ドキュメント！");
          }else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }else {
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            return ListView(
              children: docs.map((doc) {
                Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
                String name = data["name"];
                int age = data["age"];
                return ListTile(
                  title: Text(name),
                  subtitle: Text(age.toString()),
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
