import 'package:flutter/material.dart';
import 'package:global_renov/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

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
