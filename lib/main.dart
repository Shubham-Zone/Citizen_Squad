import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackingly_new/Pages/index.dart';
import 'package:provider/provider.dart';
import 'Helpers/Provider.dart';
import 'Mongodb/MongoProvider.dart';
import 'Pages/SplashScreen.dart';
import 'firebase_options.dart';

void main() async {
  // Connect to MongoDB
  await MongoProvider().connectToMongo();

  WidgetsFlutterBinding.ensureInitialized();

  print("Initializing Firebase...");

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
          useMaterial3: true,
        ),
        home: const Index(),
      ),
    );
  }
}
