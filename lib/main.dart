import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'Admin/Auth/admin_auth_page.dart';
import 'Admin/View/admin_home_screen.dart';
import 'Res/routes/routes.dart';
import 'User/Auth/authPage.dart';
import 'User/View/home_screen.dart';
import 'User/View/welcome_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mahar Hostel',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // User is authenticated
            return AuthDecisionScreen();
          } else {
            // User is not authenticated
            return AuthPage();
          }
        },
      ),
      getPages: AppRoutes.appRoutes(),
    );
  }
}

class AuthDecisionScreen extends StatefulWidget {
  const AuthDecisionScreen({Key? key}) : super(key: key);

  @override
  _AuthDecisionScreenState createState() => _AuthDecisionScreenState();
}

class _AuthDecisionScreenState extends State<AuthDecisionScreen> {
  Future<bool?> _getUserRole() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          final String? role = snapshot.data()?['role'];
          if (role != null) {
            return role.toLowerCase() == 'admin';
          }
        }
      } catch (e) {
        print('Error determining user role: $e');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: _getUserRole(),
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return WelcomeScreen();
        }
        if (snapshot.data == true) {
          return AdminHomeScreen();
        } else {
          return HomeScreen();
        }
      },
    );
  }
}

class AdminAuthPage extends StatelessWidget {
  AdminAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading...'),
            );
          }
          if (snapshot.hasData) {
            return AdminHomeScreen();
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
