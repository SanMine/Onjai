import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/content_service.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import '../utils/asset_mapper.dart';
import 'eating/eating_page.dart';
import 'login.dart';
import 'profile/profile_page.dart';
import 'selfcare/selfcare_page.dart';
import 'traveling/traveling_page.dart';
import 'medicines/medicines_page.dart';

/// Dashboard screen for the Oonjai app
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Services
  final _authService = AuthService();
  final _userService = UserService();
  final _contentService = ContentService();

  // Current user and profile
  User? _currentUser;
  UserProfile? _userProfile;
  bool _isLoading = true;

  // Element content
  String? _dashboardPosterKey;
  bool _isLoadingPoster = true;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _loadUserProfile();
  }

  /// Load element content and poster
  Future<void> _loadElementContent() async {
    if (_userProfile?.element == null) return;

    try {
      final elementContent =
          await _contentService.getElementContent(_userProfile!.element);

      if (elementContent?.dashboardPosterKey.isNotEmpty == true) {
        if (mounted) {
          setState(() {
            _dashboardPosterKey = elementContent!.dashboardPosterKey;
            _isLoadingPoster = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingPoster = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPoster = false;
        });
      }
    }
  }

  /// Load user profile from Firestore
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      final profile = await _userService.getUserProfile(_currentUser!.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });

        // Load element content after profile is loaded
        if (profile != null) {
          _loadElementContent();
        }
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

  /// Handle sign out
  Future<void> _handleSignOut() async {
    try {
      await _authService.signOut();

      if (mounted) {
        // Navigate to login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/app/Oonjai.png',
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/app/Label.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: 'Menu',
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: AppTheme.divider,
            ),
          ),
        ),
      ),
      endDrawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.lightSageBg, Color(0xFFF1F6F5)],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userProfile == null
                  ? const Center(child: Text('User profile not found'))
                  : SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom + 24,
                      ),
                      child: Column(
                        children: [
                          _buildPosterSection(),
                          _buildActionButtonsSection(),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildPosterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 7 / 10,
            child: _isLoadingPoster
                ? _buildPosterPlaceholder()
                : _dashboardPosterKey != null && _dashboardPosterKey!.isNotEmpty
                    ? Image.asset(
                        AssetMapper.getAssetPath(_dashboardPosterKey!),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPosterPlaceholder(),
                      )
                    : _buildPosterPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonsSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(),
          const SizedBox(height: 16),
          _buildActionButtonsGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Column(
      children: [
        Text(
          'เลือกเส้นทางสู่ความสมดุล',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryTeal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Discover your wellness journey',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6C7A76),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Divider(color: AppTheme.divider),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButtonsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildActionButton(
          icon: Icons.restaurant,
          title: 'อาหาร (Eating)',
          color: const Color(0xFF27AE60),
          gradientColors: const [
            Color(0xFFE8F8F1),
            Color(0xFFDFF5EE),
          ],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EatingPage()),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.flight,
          title: 'การเดินทาง (Traveling)',
          color: const Color(0xFF2D9CDB),
          gradientColors: const [
            Color(0xFFEDF6FA),
            Color(0xFFE6F2F8),
          ],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TravelingPage()),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.self_improvement,
          title: 'ดูแลตนเอง (Self-care)',
          color: const Color(0xFF9B51E0),
          gradientColors: const [
            Color(0xFFF4EDFA),
            Color(0xFFEFE8F8),
          ],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SelfcarePage()),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.medical_services,
          title: 'ยาสมุนไพร (Medicines)',
          color: const Color(0xFFEB5757),
          gradientColors: const [
            Color(0xFFFDECEC),
            Color(0xFFFBE6E6),
          ],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MedicinesPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    List<Color>? gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.neutralText,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _userProfile?.displayName ?? 'User',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              _handleSignOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 64,
              color: AppTheme.mintHighlight,
            ),
            const SizedBox(height: 16),
            Text(
              'กำลังโหลดโปสเตอร์…',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6C7A76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
