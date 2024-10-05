import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'helpers/provider.dart';
import 'data/mongodb/mongo_provider.dart';
import 'ui/screens/auth/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Connect to MongoDB
  await MongoProvider().connectToMongo();

  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isNotEmpty) {
    // The Firebase app has already been initialized, so don't initialize it again.
    return;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MongoProvider>(
          create: (_) => MongoProvider(),
        ),
        ChangeNotifierProvider<ReportsProvider>(
          create: (_) => ReportsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Abandoned Vehicle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
