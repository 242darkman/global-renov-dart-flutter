import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/models/address_model.dart';
import 'package:global_renov/screens/intervention/details_intervention_screen.dart';
import 'package:global_renov/screens/intervention/intervention_list_screen.dart';
import 'package:global_renov/services/intervention_service.dart';
import 'package:provider/provider.dart';

class CreateEditInterventionScreen extends StatefulWidget {
  final String? idIntervention;
  const CreateEditInterventionScreen({super.key, this.idIntervention = ''});

  @override
  CreateEditInterventionScreenState createState() =>
      CreateEditInterventionScreenState();
}

class CreateEditInterventionScreenState
    extends State<CreateEditInterventionScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Future<Map<String, dynamic>?> _futureIntervention;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.idIntervention!.isNotEmpty) {
      _futureIntervention = InterventionService()
          .fetchSingleIntervention(widget.idIntervention as String);
      _futureIntervention.then((data) {
        if (data!.isNotEmpty && data['interventions'].isNotEmpty) {
          final firstIntervention = data['interventions'][0];
          _dateController.text = firstIntervention['date'];
          _clientNameController.text = firstIntervention['customer'];
          _streetController.text = firstIntervention['address']['street'];
          _postalCodeController.text =
              firstIntervention['address']['postalCode'];
          _cityController.text = firstIntervention['address']['city'];
          _descriptionController.text = firstIntervention['description'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final interventionService = Provider.of<InterventionService>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Colors.green,
        title: Text(
            widget.idIntervention!.isEmpty
                ? "Créer une intervention"
                : "Modifier l'intervention",
            style: const TextStyle(color: Colors.white)),
        material: (_, __) => MaterialAppBarData(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => widget.idIntervention!.isEmpty
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InterventionListScreen()))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsInterventionScreen(
                            idIntervention: widget.idIntervention as String))),
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => widget.idIntervention!.isEmpty
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InterventionListScreen()))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsInterventionScreen(
                            idIntervention: widget.idIntervention as String))),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildSectionHeader("Général"),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildTextField(_clientNameController, 'Client :', 'Nom du client'),
            const SizedBox(height: 32),
            _buildSectionHeader("Adresse"),
            _buildTextField(_streetController, 'Rue :', 'Rue'),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildTextField(
                      _postalCodeController, 'Code postal :', 'Code postal'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(_cityController, 'Ville :', 'Ville'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader("Description"),
            _buildDescriptionField(),
            const SizedBox(height: 32),
            _buildCreateOrUpdateButton(interventionService),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green)),
      ),
    );
  }

  Widget _buildDateField() {
    return PlatformWidget(
      material: (_, __) => TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: 'Date :',
          hintText: '30/04/2024',
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate =
                '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
            setState(() {
              _dateController.text = formattedDate;
            });
          }
        },
      ),
      cupertino: (_, __) => CupertinoTextField(
        controller: _dateController,
        placeholder: '30/04/2024',
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.0, color: Colors.grey)),
        ),
        suffix: CupertinoButton(
          child: const Icon(Icons.calendar_today, color: Colors.grey),
          onPressed: () async {
            DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 216,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      String formattedDate =
                          '${newDate.day}/${newDate.month}/${newDate.year}';
                      _dateController.text = formattedDate;
                    },
                  ),
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                _dateController.text =
                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String placeholder) {
    return PlatformTextField(
      controller: controller,
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: placeholder,
        prefix: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(label),
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.0, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return PlatformTextField(
      controller: _descriptionController,
      maxLines: 3,
      material: (_, __) => MaterialTextFieldData(
        decoration: const InputDecoration(
          labelText: 'Description',
          hintText: 'Ajoutez une description',
          border: OutlineInputBorder(),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: 'Ajoutez une description',
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        clearButtonMode: OverlayVisibilityMode.editing,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCreateOrUpdateButton(InterventionService interventionService) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: PlatformElevatedButton(
        onPressed: _isLoading
            ? null
            : () => _handleCreateOrUpdateIntervention(interventionService),
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          color: Colors.green,
          borderRadius: BorderRadius.circular(7),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 2.0,
                  backgroundColor: Colors.white,
                ),
              )
            : Text(widget.idIntervention!.isEmpty ? 'Créer' : 'Mettre à jour',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  void _handleCreateOrUpdateIntervention(
      InterventionService interventionService) async {
    String defaultStatus = "scheduled";
    Map<String, dynamic> data = {};

    if (_dateController.text.isNotEmpty) {
      data['date'] = _dateController.text;
    }

    if (_clientNameController.text.isNotEmpty) {
      data['customer'] = _clientNameController.text;
    }

    if (_streetController.text.isNotEmpty ||
        _postalCodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty) {
      data['address'] = Address(
        street: _streetController.text,
        postalCode: _postalCodeController.text,
        city: _cityController.text,
      ).toJson();
    }

    if (_descriptionController.text.isNotEmpty) {
      data['description'] = _descriptionController.text;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.idIntervention!.isNotEmpty) {
        await interventionService.updateAnIntervention(
            widget.idIntervention as String, data);

        return;
      }

      await interventionService.createIntervention(
        defaultStatus,
        _dateController.text,
        _clientNameController.text,
        Address(
          street: _streetController.text,
          postalCode: _postalCodeController.text,
          city: _cityController.text,
        ),
        _descriptionController.text,
      );
    } catch (e) {
      String interventionIdentifier = widget.idIntervention as String;
      String modeText =
          widget.idIntervention!.isEmpty ? 'création' : 'mise à jour';
      String message =
          'Erreur lors de la ${modeText} de l\'intervention $interventionIdentifier: ${e.toString()}';
      _showErrorDialog(message);
    } finally {
      setState(() => _isLoading = false);
      if (widget.idIntervention!.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsInterventionScreen(
                    idIntervention: widget.idIntervention as String)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const InterventionListScreen()));
      }
    }
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
}
