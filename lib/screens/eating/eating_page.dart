import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/favorites_service.dart';
import '../../services/foods_service.dart';
import '../../services/user_service.dart';
import 'tabs/avoid_tab.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/great_tab.dart';
import 'tabs/suggestion_tab.dart';

/// Eating page with bottom navigation tabs
class EatingPage extends StatefulWidget {
  const EatingPage({super.key});

  @override
  State<EatingPage> createState() => _EatingPageState();
}

class _EatingPageState extends State<EatingPage> {
  final _userService = UserService();
  final _foodsService = FoodsService();
  final _favoritesService = FavoritesService();
  
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
        title: const Text('Eating Guide'),
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
                  icon: Icon(Icons.thumb_up),
                  label: 'Great',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.thumb_down),
                  label: 'Avoid',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb),
                  label: 'Suggestion',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
            ),
    );
  }

  /// Build tab view based on current index
  Widget _buildTabView() {
    switch (_currentIndex) {
      case 0:
        return GreatTab(
          element: _userProfile!.element,
          foodsService: _foodsService,
          favoritesService: _favoritesService,
          userId: _currentUser!.uid,
        );
      case 1:
        return AvoidTab(
          element: _userProfile!.element,
          foodsService: _foodsService,
          favoritesService: _favoritesService,
          userId: _currentUser!.uid,
        );
      case 2:
        return SuggestionTab(
          element: _userProfile!.element,
          foodsService: _foodsService,
          favoritesService: _favoritesService,
          userId: _currentUser!.uid,
        );
      case 3:
        return FavoritesTab(
          element: _userProfile!.element,
          foodsService: _foodsService,
          favoritesService: _favoritesService,
          userId: _currentUser!.uid,
        );
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }
}
