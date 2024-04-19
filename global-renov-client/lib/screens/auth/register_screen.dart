import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:global_renov/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  static const Color _formContainerColor = Colors.white;
  static const Color _buttonColor = Color(0xFF55895B);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return PlatformScaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 250, height: 200),
                _buildFormContainer(authService),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer(AuthService authService) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: _formContainerColor.withOpacity(0.9),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFirstNameField(),
          const SizedBox(height: 20),
          _buildLastNameField(),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildRegisterButton(authService),
          const SizedBox(height: 10),
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return PlatformTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => setState(() {}),
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Email',
          prefixIcon: const Icon(Icons.email),
          hintText: 'Saisissez un e-mail valide',
          errorText:
              _validateEmail(_emailController.text) ? null : 'Email invalide',
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: 'Email',
        prefix: const Icon(Icons.email, color: Colors.grey),
        clearButtonMode: OverlayVisibilityMode.editing,
      ),
    );
  }

  bool _validateEmail(String value) {
    String pattern = r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        PlatformTextField(
          controller: _passwordController,
          obscureText: true,
          onChanged: (value) => setState(() {}),
          material: (_, __) => MaterialTextFieldData(
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              hintText:
                  'Saisissez un mot de passe avec un minimum de 6 caractères, une majuscule, un caractère special',
              helperText: 'Majuscule, caractères spéciaux et 6+ caractères',
              errorText: _validatePassword(_passwordController.text)
                  ? null
                  : 'Mot de passe faible',
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          cupertino: (_, __) => CupertinoTextFieldData(
            placeholder: 'Mot de passe',
            prefix: const Icon(Icons.lock_outline, color: Colors.grey),
            obscureText: true,
          ),
        ),
        LinearProgressIndicator(
          value: _calculatePasswordStrength(_passwordController.text),
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
              _calculatePasswordStrength(_passwordController.text) >= 1
                  ? Colors.green
                  : Colors.red),
        ),
      ],
    );
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      return 0.0;
    }
    double strength = 0.0;
    // List of RegExp objects, each representing a pattern to match
    List<RegExp> patterns = [
      RegExp(r'[A-Z]'), // Uppercase letters
      RegExp(r'[a-z]'), // Lowercase letters
      RegExp(r'[0-9]'), // Digits
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'), // Special characters
    ];
    for (var pattern in patterns) {
      if (pattern.hasMatch(password)) {
        strength += 1 / patterns.length;
      }
    }
    return strength;
  }

  bool _validatePassword(String password) {
    String pattern = r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Widget _buildFirstNameField() {
    return PlatformTextField(
      controller: _firstNameController,
      material: (_, __) => MaterialTextFieldData(
        decoration: const InputDecoration(
          labelText: 'Nom',
          prefixIcon: Icon(Icons.person_outline),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: 'Nom',
        prefix: const Icon(Icons.person_outline, color: Colors.grey),
      ),
    );
  }

  Widget _buildLastNameField() {
    return PlatformTextField(
      controller: _lastNameController,
      material: (_, __) => MaterialTextFieldData(
        decoration: const InputDecoration(
          labelText: 'Prénom',
          prefixIcon: Icon(Icons.person),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: 'Prénom',
        prefix: const Icon(Icons.person, color: Colors.grey),
      ),
    );
  }

  Widget _buildRegisterButton(AuthService authService) {
    return PlatformElevatedButton(
      onPressed: _isLoading ? null : () => _handleRegistration(authService),
      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoElevatedButtonData(
        color: _buttonColor,
        borderRadius: BorderRadius.circular(5.0),
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
          : const Text(
              'Créer mon compte',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Widget _buildCancelButton() {
    return PlatformTextButton(
      onPressed: () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen())),
      child: const Text('Vous avez déjà un compte ? Connectez-vous',
          style: TextStyle(color: Colors.grey)),
      material: (_, __) => MaterialTextButtonData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoTextButtonData(
        child: const DefaultTextStyle(
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
          child: Text('Vous avez déjà un compte ? Connectez-vous'),
        ),
      ),
    );
  }

  void _handleRegistration(AuthService authService) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var result = await authService.createAccount(
          _emailController.text,
          _passwordController.text,
          _firstNameController.text,
          _lastNameController.text);
      if (result != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        _showErrorDialog(
            'Erreur lors de la création de votre compte. Veuillez reessayer.');
      }
    } catch (e) {
      _showErrorDialog('Erreur de connexion: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
