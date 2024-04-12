import 'package:flutter/material.dart';
import 'package:global_renov/screens/create.dart';
import 'dart:math';

void main() {
  runApp(const HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'home'),
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
            onPressed: () {},
          ),
          title: Row(
            children: [
              const Text(
                "Interventions",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF55895B),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateApp()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: InterventionsList(),
    );
  }
}

class InterventionsList extends StatelessWidget {
  final List interventions = List.generate(10, (index) {
    final random = Random();
    String status = ['Programmé', 'Annulé', 'Clôturé'][random.nextInt(3)];
    return {
      "status": status,
      "date": "30/04/2024",
      "customer": "John Smith",
      "address": "12 rue des lilas, 60001 Lyon"
    };
  });

  InterventionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: interventions.length,
              itemBuilder: (context, index) => Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                    interventions[index]["status"]),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                interventions[index]["status"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                interventions[index]["date"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                interventions[index]["customer"],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                interventions[index]["address"],
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        color: Color(0xFF022606),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case "Programmé":
      return Color(0xFF51BEE0);
    case "Annulé":
      return Color(0xFF7D949B);
    default:
      return Color(0xFF84CD8D);
  }
}
