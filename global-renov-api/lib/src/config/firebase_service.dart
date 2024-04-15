import 'package:firebase_dart/firebase_dart.dart';
import 'package:global_renov_api/src/config/firebase_data_config.dart';

class FirebaseService {
  static FirebaseApp? _app;
  late final FirebaseAuth _auth;
  late final FirebaseDatabase _database;

  FirebaseService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _app ??= await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: FirebaseDataConfig().dataConfiguration['apiKey']!,
        authDomain: FirebaseDataConfig().dataConfiguration['authDomain']!,
        projectId: FirebaseDataConfig().dataConfiguration['projectId']!,
        storageBucket: FirebaseDataConfig().dataConfiguration['storageBucket']!,
        messagingSenderId:
            FirebaseDataConfig().dataConfiguration['messagingSenderId']!,
        appId: FirebaseDataConfig().dataConfiguration['appId']!,
        measurementId: FirebaseDataConfig().dataConfiguration['measurementId']!,
        databaseURL: FirebaseDataConfig().dataConfiguration['databaseURL']!,
      ),
    );

    _auth = FirebaseAuth.instanceFor(app: _app!);

    _database = FirebaseDatabase(app: _app!);
  }

  FirebaseAuth get auth => _auth;

  FirebaseDatabase get database => _database;
}
