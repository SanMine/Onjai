import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/content_service.dart';
import '../../services/user_service.dart';
import 'tabs/symptom_tab.dart';
import 'tabs/therapy_tab.dart';
import 'tabs/travel_tab.dart';

/// Traveling page with bottom navigation tabs
class TravelingPage extends StatefulWidget {
  const TravelingPage({super.key});

  @override
  State<TravelingPage> createState() => _TravelingPageState();
}

class _TravelingPageState extends State<TravelingPage> {
  final _userService = UserService();
  final _contentService = ContentService();
  
  User? _currentUser;
  UserProfile? _userProfile;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserProfile();
  }

  /// Load user profile to get element
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      final profile = await _userService.getUserProfile(_currentUser!.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Handle tab change
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveling Guide'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userProfile == null
                ? const Center(
                    child: Text('User profile not found'),
                  )
                : _buildTabView(),
      ),
      bottomNavigationBar: _isLoading || _userProfile == null
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onTabChanged,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.flight),
                  label: 'Travel',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medical_services),
                  label: 'Symptom',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.healing),
                  label: 'Therapy',
                ),
              ],
            ),
    );
  }

  /// Build tab view based on current index
  Widget _buildTabView() {
    switch (_currentIndex) {
      case 0:
        return TravelTab();
      case 1:
        return SymptomTab(
          element: _userProfile!.element,
          contentService: _contentService,
        );
      case 2:
        return const TherapyTab();
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }
}
