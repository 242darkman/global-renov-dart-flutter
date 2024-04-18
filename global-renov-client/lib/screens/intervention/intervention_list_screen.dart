import 'package:flutter/material.dart';
import 'package:global_renov/models/intervention_model.dart';
import 'package:global_renov/screens/intervention/create_intervention_screen.dart';
import 'package:global_renov/services/api.dart';

void main() {
  runApp(const InterventionList());
}

class InterventionList extends StatefulWidget {
  const InterventionList({super.key});

  @override
  State<InterventionList> createState() => _InterventionListState();
}

class _InterventionListState extends State<InterventionList> {
  late Future<List<Intervention>> futureIntervention;

  @override
  void initState() {
    super.initState();
    futureIntervention = fetchInterventions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: newMethod(context));
  }

  Scaffold newMethod(BuildContext context) {
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
        body: ListInterventions(futureIntervention: futureIntervention));
  }
}

class ListInterventions extends StatelessWidget {
  const ListInterventions({
    super.key,
    required this.futureIntervention,
  });

  final Future<List<Intervention>> futureIntervention;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FutureBuilder<List<Intervention>>(
            future: futureIntervention,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                              snapshot.data![index].status),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          snapshot.data![index].status,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          snapshot.data![index].date,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                            snapshot.data![index].customer),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          "${snapshot.data![index].address.street} ${snapshot.data![index].address.postalCode} ${snapshot.data![index].address.city} ",
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  color: const Color(0xFF022606),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ));
              } else if (snapshot.hasError) {
                return Text("Erreur : ${snapshot.error}");
              }
              return const CircularProgressIndicator();
            }));
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case "Programmé":
      return const Color(0xFF51BEE0);
    case "Annulé":
      return const Color(0xFF7D949B);
    default:
      return const Color(0xFF84CD8D);
  }
}
