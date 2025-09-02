import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard.dart';
import 'screens/login.dart';
import 'services/user_service.dart';
import 'theme/app_theme.dart';
import 'widgets/collect_dob_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(const OonjaiApp());
}

/// Main application widget for Oonjai
class OonjaiApp extends StatelessWidget {
  const OonjaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oonjai',
      debugShowCheckedModeBanner: false,
      
      // Use the new app theme
      theme: AppTheme.lightTheme,
      
      home: const AuthWrapper(),
    );
  }
}

/// Widget that handles authentication state and navigation
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // If user is authenticated, check profile completeness
        if (snapshot.hasData && snapshot.data != null) {
          return ProfileCompletionWrapper(user: snapshot.data!);
        }
        
        // If user is not authenticated, show login screen
        return const LoginScreen();
      },
    );
  }
}

/// Widget that handles profile completion flow
class ProfileCompletionWrapper extends StatefulWidget {
  final User user;

  const ProfileCompletionWrapper({
    super.key,
    required this.user,
  });

  @override
  State<ProfileCompletionWrapper> createState() => _ProfileCompletionWrapperState();
}

class _ProfileCompletionWrapperState extends State<ProfileCompletionWrapper> {
  final _userService = UserService();
  bool _isLoading = true;
  bool _isProfileComplete = false;

  @override
  void initState() {
    super.initState();
    _checkProfileCompleteness();
  }

  /// Check if the user profile is complete
  Future<void> _checkProfileCompleteness() async {
    try {
      final isComplete = await _userService.isProfileComplete(widget.user.uid);
      
      if (mounted) {
        setState(() {
          _isProfileComplete = isComplete;
          _isLoading = false;
        });
      }
    } catch (e) {
      // If there's an error, assume profile is incomplete
      if (mounted) {
        setState(() {
          _isProfileComplete = false;
          _isLoading = false;
        });
      }
    }
  }

  /// Show the profile completion dialog
  Future<void> _showProfileDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CollectDobDialog(
        uid: widget.user.uid,
        email: widget.user.email ?? '',
      ),
    );

    // If profile was completed successfully, refresh the state
    if (result == true && mounted) {
      await _checkProfileCompleteness();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If profile is not complete, show the completion dialog
    if (!_isProfileComplete) {
      // Use a post-frame callback to show the dialog after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showProfileDialog();
      });
      
      // Show a loading screen while the dialog is being prepared
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Preparing your profile...'),
            ],
          ),
        ),
      );
    }

    // If profile is complete, show the dashboard
    return const DashboardScreen();
  }
}
