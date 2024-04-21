import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/models/intervention_model.dart';
import 'package:global_renov/screens/intervention/create_intervention_screen.dart';
import 'package:global_renov/screens/intervention/details_intervention_screen.dart';
import 'package:global_renov/services/intervention_service.dart';
import 'package:global_renov/utils/intervention_functions.dart';
import 'package:global_renov/utils/logger.dart';
import 'package:global_renov/widgets/custom_loading.dart';

class InterventionListScreen extends StatefulWidget {
  const InterventionListScreen({super.key});

  @override
  InterventionListScreenState createState() => InterventionListScreenState();
}

class InterventionListScreenState extends State<InterventionListScreen> {
  late Future<Map<String, dynamic>?> _futureIntervention;

  @override
  void initState() {
    super.initState();
    _futureIntervention = InterventionService().fetchInterventions();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        material: (_, __) => MaterialAppBarData(
          backgroundColor: const Color(0xFF55895B),
        ),
        title: Text(
          "Interventions",
          style: platformThemeData(
            context,
            material: (data) => const TextStyle(color: Colors.white),
            cupertino: (data) => const TextStyle(color: CupertinoColors.white),
          ),
        ),
        trailingActions: <Widget>[
          PlatformIconButton(
            icon: Icon(
              PlatformIcons(context).add,
              color: const Color(0xFF55895B),
            ),
            onPressed: () => Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => const CreateInterventionScreen(),
              ),
            ),
            material: (_, __) => MaterialIconButtonData(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  PlatformIcons(context).add,
                  color: const Color(0xFF55895B),
                ),
              ),
            ),
            cupertino: (_, __) => CupertinoIconButtonData(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  PlatformIcons(context).add,
                  color: const Color(0xFF55895B),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListInterventions(futureIntervention: _futureIntervention),
    );
  }
}

class ListInterventions extends StatelessWidget {
  final Future<Map<String, dynamic>?> futureIntervention;

  const ListInterventions({super.key, required this.futureIntervention});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: futureIntervention,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadingIndicator();
        }

        if (snapshot.hasError) {
          log.severe('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || (snapshot.data?['interventions'] is! List)) {
          log.severe('No interventions found');
          return const Text('No interventions found');
        }

        var interventions = (snapshot.data!['interventions'] as List)
            .map((i) => Intervention.fromJson(i))
            .toList();

        return ListView.builder(
          itemCount: interventions.length,
          itemBuilder: (context, index) {
            return interventionCard(context, interventions[index]);
          },
        );
      },
    );
  }
}

Widget interventionCard(BuildContext context, Intervention intervention) {
  return Card(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: getStatusColor(intervention.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    translateStatus(intervention.status),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    //formatDateTime(intervention.date),
                    formatDateTime(intervention.date, outputFormat: 'dd/M/yyyy'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(intervention.customer),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "${intervention.address.street} ${intervention.address.postalCode} ${intervention.address.city}",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
          PlatformIconButton(
            icon: Icon(PlatformIcons(context).forward),
            onPressed: () {
             
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsInterventionScreen(idIntervention: intervention.id))
              );
            },
          ),
        ],
      ),
    ),
  );
}
