import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_renov/screens/auth/register_screen.dart';
import 'package:global_renov/screens/intervention/intervention_list_screen.dart';
import 'package:global_renov/services/auth_service.dart';
import 'package:global_renov/state/app_state.dart';
import 'package:global_renov/utils/shared_preferences.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildLoginButton(authService),
          const SizedBox(height: 10),
          _buildCreateAccountButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return PlatformTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      material: (_, __) => MaterialTextFieldData(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: _buttonColor),
          ),
          labelText: 'Email',
          labelStyle: TextStyle(color: _buttonColor),
          prefixIcon: Icon(Icons.email),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: 'Email',
        prefix: const Icon(Icons.email, color: Colors.grey),
        placeholderStyle: const TextStyle(color: _buttonColor),
      ),
    );
  }

  Widget _buildPasswordField() {
    return PlatformTextField(
      controller: _passwordController,
      obscureText: true,
      material: (_, __) => MaterialTextFieldData(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: _buttonColor),
          ),
          labelText: 'Mot de passe',
          labelStyle: TextStyle(color: _buttonColor),
          prefixIcon: Icon(Icons.lock),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
          placeholder: 'Mot de passe',
          prefix: const Icon(Icons.lock, color: Colors.grey),
          placeholderStyle: const TextStyle(color: _buttonColor)),
    );
  }

  Widget _buildLoginButton(AuthService authService) {
    return PlatformElevatedButton(
      onPressed: _isLoading ? null : () => _handleLogin(authService),
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
              'Se connecter',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Widget _buildCreateAccountButton() {
    return PlatformTextButton(
      onPressed: _handleCreateAccount,
      material: (_, __) => MaterialTextButtonData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoTextButtonData(
        child: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
          child: Text('Pas de compte ? Créez-en un'),
        ),
      ),
      child: const Text('Pas de compte ? Créez-en un',
          style: TextStyle(color: Colors.grey)),
    );
  }

  void _handleLogin(AuthService authService) async {
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog(
          'Veuillez renseigner l\'adresse email et le mot de passe.');
    }

    try {
      var result = await authService.signIn(
          _emailController.text.trim(), _passwordController.text.trim());
      if (result != null) {
        Provider.of<AppState>(context, listen: false).setUser(result);
        await PreferenceService.setToken(result['token']);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const InterventionListScreen()));
      } else {
        _showErrorDialog(
            'Informations d\'identification non valides. Veuillez réessayer.');
      }
    } catch (e) {
      _showErrorDialog('Erreur de connexion: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleCreateAccount() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
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
