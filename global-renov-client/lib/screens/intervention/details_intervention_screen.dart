import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/screens/intervention/intervention_list_screen.dart';
import 'package:global_renov/services/intervention_service.dart';
import 'package:global_renov/utils/intervention_functions.dart';
import 'package:provider/provider.dart';

class DetailsInterventionScreen extends StatefulWidget {
  final String idIntervention;
  const DetailsInterventionScreen({Key? key, required this.idIntervention}) : super(key: key);

  @override
  DetailsInterventionScreenState createState() => DetailsInterventionScreenState();
}

class DetailsInterventionScreenState extends State<DetailsInterventionScreen> {
  bool _isLoading = false;
  late Future<Map<String, dynamic>?> _futureIntervention;
  static const Color _buttonColor = Color(0xFF55895B);

  @override
  void initState() {
      super.initState();
      _futureIntervention = InterventionService().fetchSingleIntervention(widget.idIntervention);
  }

  @override
  Widget build(BuildContext context) {
    final interventionService = Provider.of<InterventionService>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: const Color(0xFF55895B),
        title: const Text("Détails intervention", style: TextStyle(color: Colors.white)),
        material: (_, __) => MaterialAppBarData(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InterventionListScreen())),
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InterventionListScreen())),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
          const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: _buildField('status', 'Statut')),
                const SizedBox(width: 16),
                _buildActionButton(Icons.edit, Colors.green, () {}),
                _buildActionButton(Icons.delete, Colors.red, () {}),
              ],
            ),
            _buildField('date', 'Date'),
            const SizedBox(height: 16),
            _buildField('customer', 'Client'),
            const SizedBox(height: 32),
            _buildField('address', 'Adresse'),
            const SizedBox(height: 32),
            _buildField('description', 'Description'),
            const SizedBox(height: 32),
            _buildCancelButton(interventionService),
            const SizedBox(height: 32),
            _buildClosedButton(interventionService)
            ],
          ),
      ),
    );
  }

  Widget _buildField(String fieldName, String labelText) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: _futureIntervention,
    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Text('Erreur de chargement');
      } else if (snapshot.hasData) {
        final interventions = snapshot.data?['interventions'];
        if (interventions != null && interventions.isNotEmpty) {
          final firstIntervention = interventions[0] as Map<String, dynamic>;
          var fieldValue = firstIntervention[fieldName] ?? 'Pas de $labelText disponible';

          if (fieldName == 'status') {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: getStatusColor(firstIntervention['status']),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                translateStatus(firstIntervention['status']),
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (fieldName == 'address') {
            final address = firstIntervention['address'] as Map<String, dynamic>;
            fieldValue = '${address['street']} ${address['postalCode']} ${address['city']}';
          } else if (fieldName == 'date') {
            fieldValue = formatDateTime(firstIntervention['date'], outputFormat: 'dd/M/yyyy');
          }

          if (fieldName == 'description') {
            return TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              initialValue: fieldValue.toString(),
              enabled: false,
              maxLines: null, 
            );
          } else {
            return TextFormField(
              decoration: InputDecoration(
                labelText: '$labelText : $fieldValue',
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              enabled: false,
              maxLines: null,
            );
          }
        } else {
          return const Text('Aucune disponible');
        }
      } else {
        return const Text('Aucune disponible');
      }
    },
 );
}


  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
      return IconButton(
        icon: Icon(icon, size: 40, color: color),
        onPressed: onPressed,
      );
  }

  Widget _buildClosedButton(InterventionService interventionService) {
    return SizedBox(
      width: 400,
      height: 50,
      child: PlatformElevatedButton(
        onPressed: _isLoading ? null : () => _handleActionIntervention(interventionService, widget.idIntervention, "close"),
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF55895B),
            textStyle: const TextStyle(color: Colors.white),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          color: const Color(0xFF55895B),
          borderRadius: BorderRadius.circular(7),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                 valueColor: AlwaysStoppedAnimation<Color>(_buttonColor),
                 strokeWidth: 2.0,
                 backgroundColor: Colors.white,
                ),
              )
            : const Text('Clôturer', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _buildCancelButton(InterventionService interventionService) {
    return SizedBox(
      width: 400,
      height: 50,
      child: PlatformElevatedButton(
        onPressed: _isLoading ? null : () => _handleActionIntervention(interventionService, widget.idIntervention, "cancel"),
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            //backgroundColor: Color.fromARGB(255, 66, 76, 68),
            backgroundColor: const Color.fromARGB(255, 125, 148, 155),
            textStyle: const TextStyle(color: Colors.white),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          color: const Color(0xFF55895B),
          borderRadius: BorderRadius.circular(7),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                 valueColor: AlwaysStoppedAnimation<Color>(_buttonColor),
                 strokeWidth: 2.0,
                 backgroundColor: Colors.white,
                ),
              )
            : const Text('Annuler', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            child: PlatformText('D\'accord'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _handleActionIntervention(InterventionService interventionService, String idIntervention, String actionType) async {

    setState(() {
      _isLoading = true;
    });

    try {

      if (actionType == "close") {
        await interventionService.changeStatusIntervention(
          "closed",
          idIntervention
        );
      } else if (actionType == "cancel") {
          await interventionService.changeStatusIntervention(
            "canceled",
            idIntervention
          );
      }
    } catch (e) {
      _showErrorDialog('Erreur de la création: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
