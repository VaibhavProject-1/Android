import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_login_screen.dart';
import 'screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/page_content.dart';
import 'providers/product_provider.dart'; // Import ProductProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageContent()),
        ChangeNotifierProvider(create: (_) => ProductProvider()), // Provide ProductProvider here
      ],
      child: Consumer<PageContent>(
        builder: (context, pageContent, child) {
          return MaterialApp(
            title: 'FlutterMart',
            theme: pageContent.isDarkMode
                ? ThemeData.dark().copyWith(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.black,
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
              ),
            )
                : ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
              ),
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return MainScreen();
                } else {
                  return const OnboardingScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}