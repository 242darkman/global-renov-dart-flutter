import 'package:flutter/material.dart';
import 'package:global_renov/screens/home.dart';

void main() {
  runApp(const CreateApp());
}

class CreateApp extends StatelessWidget {
  const CreateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'create'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), 
        child: AppBar(
          backgroundColor: const Color(0xFF55895B),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => const HomeApp()),
                );
            },
          ),
          title: Row(
            children: [
              const Text(
                "Créer une intervention",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
            ],
          ), 
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
          ],
        ),
      ),
    );
  }
}
