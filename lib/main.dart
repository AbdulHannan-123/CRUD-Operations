import 'package:cruid/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // ignore: prefer_const_constructors
    options: FirebaseOptions(
        apiKey: "",
        appId: "",
        messagingSenderId: "",
        projectId: "fluttercrud-24fd4"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _initialization,
    builder:(context,snapshot){
      if(snapshot.hasError){
        print('SomeThing Went Wrong');
      } if(snapshot.connectionState==ConnectionState.done){
        return MaterialApp(
      title: 'Flutter Firebase',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
      }
      return CircularProgressIndicator();
    }
    );
    
    
    
  }
}