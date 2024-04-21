import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/models/address_model.dart';
import 'package:global_renov/screens/intervention/intervention_list_screen.dart';
import 'package:global_renov/services/intervention_service.dart';
import 'package:provider/provider.dart';


class CreateInterventionScreen extends StatefulWidget {
  const CreateInterventionScreen({super.key});

  @override
  CreateInterventionScreenState createState() =>
      CreateInterventionScreenState();
}

class CreateInterventionScreenState extends State<CreateInterventionScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  static const Color _buttonColor = Color(0xFF55895B);

  @override
  Widget build(BuildContext context) {
    final interventionService = Provider.of<InterventionService>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: const Color(0xFF55895B),
        title: const Text("Créer une intervention",
            style: TextStyle(color: Colors.white)),
        material: (_, __) => MaterialAppBarData(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InterventionListScreen()),
            ),
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InterventionListScreen()),
            ),
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
            _buildCreateButton(interventionService),
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
                color: Color(0xFF55895B))),
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

  Widget _buildCreateButton(InterventionService interventionService) {
    return SizedBox(
      width: 400,
      height: 50,
      child: PlatformElevatedButton(
        onPressed: _isLoading
            ? null
            : () => _handleCreateIntervention(interventionService),
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
            : const Text('Créer',
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

  void _handleCreateIntervention(
    InterventionService interventionService) async {

      String defaultStatus = "scheduled";
      String date = _dateController.text;
      String customer = _clientNameController.text;
      String street = _streetController.text;
      String postalCode = _postalCodeController.text;
      String city = _cityController.text;
      Address address = Address(street: street, postalCode: postalCode, city: city);
      String description = _descriptionController.text;
      
      
      setState(() {
        _isLoading = true;
      });

      try {
        await interventionService.createIntervention(
          defaultStatus,
          date,
          customer,
          address,
          description,
        );

      } catch (e) {
        _showErrorDialog('Erreur de la création: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
  }
}