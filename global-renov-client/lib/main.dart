import 'package:flutter/material.dart';
import 'package:global_renov/screens/auth/login_screen.dart';
import 'package:global_renov/utils/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        Provider(create: (context) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Global\'Renov',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: LoginScreen(),
      ),
    );
  }
}
