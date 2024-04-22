import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/screens/intervention/intervention_list_screen.dart';
import 'package:global_renov/services/intervention_service.dart';
import 'package:global_renov/state/intervention_state.dart';
import 'package:global_renov/utils/intervention_functions.dart';
import 'package:provider/provider.dart';

class DetailsInterventionScreen extends StatefulWidget {
  final String idIntervention;
  const DetailsInterventionScreen({super.key, required this.idIntervention});

  @override
  DetailsInterventionScreenState createState() =>
      DetailsInterventionScreenState();
}

class DetailsInterventionScreenState extends State<DetailsInterventionScreen> {
  bool _isLoading = false;
  late Future<Map<String, dynamic>?> _futureIntervention;
  static const Color _buttonColor = Color(0xFF55895B);
  static const Color _customGreenColor = Color(0xFF224125);

  @override
  void initState() {
    super.initState();
    _futureIntervention =
        InterventionService().fetchSingleIntervention(widget.idIntervention);
    _futureIntervention.then((data) {
      if (data != null &&
          data['interventions'] != null &&
          data['interventions'].isNotEmpty) {
        final firstIntervention = data['interventions'][0];
        Provider.of<InterventionState>(context, listen: false)
            .setCurrentStatus(firstIntervention['status']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final interventionService = Provider.of<InterventionService>(context);
    final interventionState = Provider.of<InterventionState>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: const Color(0xFF55895B),
        title: const Text("Détails intervention",
            style: TextStyle(color: Colors.white)),
        material: (_, __) => MaterialAppBarData(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InterventionListScreen())),
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InterventionListScreen())),
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
                _buildField('status', 'Statut'),
                const Spacer(),
                _buildActionButton(Icons.edit, Colors.green, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateEditInterventionScreen(
                              idIntervention: widget.idIntervention)));
                }),
                const SizedBox(width: 13),
                _buildActionButton(Icons.delete, Colors.red, () {}),
              ],
            ),
            const SizedBox(height: 32),
            _buildField('date', 'Date'),
            const SizedBox(height: 16),
            _buildField('customer', 'Client'),
            const SizedBox(height: 32),
            _buildField('address', 'Adresse'),
            const SizedBox(height: 32),
            _buildField('description', 'Description'),
            if (interventionState.currentStatus == "scheduled") ...[
              const SizedBox(height: 32),
              _buildCancelButton(interventionService, interventionState),
              const SizedBox(height: 32),
              _buildClosedButton(interventionService, interventionState),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildField(String fieldName, String labelText) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _futureIntervention,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Text('Erreur de chargement',
              textAlign: TextAlign.center);
        }

        if (!snapshot.hasData ||
            snapshot.data?['interventions'] == null ||
            snapshot.data!['interventions'].isEmpty) {
          return const Text('Aucune disponible', textAlign: TextAlign.center);
        }

        final interventions = snapshot.data!['interventions'] as List<dynamic>;
        final firstIntervention = interventions[0] as Map<String, dynamic>;

        return _buildFieldContent(firstIntervention, fieldName, labelText);
      },
    );
  }

  Widget _buildFieldContent(
      Map<String, dynamic> intervention, String fieldName, String labelText) {
    switch (fieldName) {
      case 'status':
        return _buildStatusField(intervention);
      case 'address':
        return _buildAddressField(intervention);
      case 'date':
        return _buildDateField(intervention);
      case 'customer':
        return _buildCustomerField(intervention);
      case 'description':
        return _buildDescriptionField(intervention, labelText);
      default:
        return _buildDefaultField(intervention, fieldName, labelText);
    }
  }

  Widget _buildStatusField(Map<String, dynamic> intervention) {
    TextStyle textStyle = const TextStyle(color: Colors.white);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getStatusColor(intervention['status']),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        translateStatus(intervention['status']),
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCustomerField(Map<String, dynamic> intervention) {
    String customerName = intervention['customer'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Client:',
          style: TextStyle(
              color: _customGreenColor,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            customerName,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField(Map<String, dynamic> intervention) {
    Map<String, dynamic> address =
        intervention['address'] as Map<String, dynamic>;
    String addressValue =
        '${address['street']} ${address['postalCode']} ${address['city']}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Adresse:',
            style: TextStyle(
                color: _customGreenColor,
                fontSize: 12,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              addressValue,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(Map<String, dynamic> intervention) {
    String dateValue =
        formatDateTime(intervention['date'], outputFormat: 'dd/M/yyyy');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Date:',
          style: TextStyle(
              color: _customGreenColor,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            dateValue,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
      Map<String, dynamic> intervention, String labelText) {
    String fieldValue =
        intervention['description'] ?? 'No Description Available';
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      initialValue: fieldValue,
      enabled: false,
      maxLines: null,
    );
  }

  Widget _buildDefaultField(
      Map<String, dynamic> intervention, String fieldName, String labelText) {
    var fieldValue = intervention[fieldName] ?? 'No $labelText available';
    return Text(
      '$labelText: $fieldValue',
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 40, color: color),
      onPressed: onPressed,
    );
  }

  Widget _buildClosedButton(InterventionService interventionService,
      InterventionState interventionState) {
    bool isEnabled =
        interventionState.currentStatus == "scheduled" && !_isLoading;

    return SizedBox(
      width: 400,
      height: 50,
      child: PlatformElevatedButton(
        onPressed: isEnabled
            ? () => _handleActionIntervention(interventionService,
                widget.idIntervention, "close", interventionState)
            : null,
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF55895B),
            textStyle: const TextStyle(color: Colors.white),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
            : const Text('Clôturer l\'intervention',
                style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _buildCancelButton(InterventionService interventionService,
      InterventionState interventionState) {
    bool isEnabled =
        interventionState.currentStatus == "scheduled" && !_isLoading;

    return SizedBox(
      width: 400,
      height: 50,
      child: PlatformElevatedButton(
        onPressed: isEnabled
            ? () => _handleActionIntervention(interventionService,
                widget.idIntervention, "cancel", interventionState)
            : null,
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 125, 148, 155),
            textStyle: const TextStyle(color: Colors.white),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
            : const Text('Annuler l\'intervention',
                style: TextStyle(color: Colors.white, fontSize: 18)),
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

  void _handleActionIntervention(
      InterventionService interventionService,
      String idIntervention,
      String actionType,
      InterventionState interventionState) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (actionType == "close") {
        await interventionService.changeStatusIntervention(
            "closed", idIntervention);
        interventionState.setCurrentStatus("closed");
      }

      if (actionType == "cancel") {
        await interventionService.changeStatusIntervention(
            "canceled", idIntervention);
        interventionState.setCurrentStatus("canceled");
      }
    } catch (e) {
      _showErrorDialog('Erreur lors du changement de statut: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
