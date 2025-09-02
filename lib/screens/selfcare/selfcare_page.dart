import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/content_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/asset_mapper.dart';

/// Self-care page showing element-based wellness content
class SelfcarePage extends StatefulWidget {
  const SelfcarePage({super.key});

  @override
  State<SelfcarePage> createState() => _SelfcarePageState();
}

class _SelfcarePageState extends State<SelfcarePage> {
  final _contentService = ContentService();
  final _userService = UserService();
  
  User? _currentUser;
  UserProfile? _userProfile;
  bool _isLoading = true;
  
  // Element content
  String? _selfCarePosterKey;
  bool _isLoadingPoster = true;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserProfile();
  }

  /// Load element content and poster
  Future<void> _loadElementContent() async {
    if (_userProfile?.element == null) return;

    try {
      final elementContent = await _contentService.getElementContent(_userProfile!.element);
      if (elementContent?.selfCarePosterKey.isNotEmpty == true) {
        if (mounted) {
          setState(() {
            _selfCarePosterKey = elementContent!.selfCarePosterKey;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Care'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userProfile == null
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.mintHighlight,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.deepTeal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6C7A76),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserProfile,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Build main content
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryTeal,
                  AppTheme.mintHighlight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getElementIcon(_userProfile!.element),
                      size: 32,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Self-Care for',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            _userProfile!.element,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Self-care poster with new styling
          if (!_isLoadingPoster) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
                    child: _selfCarePosterKey != null && _selfCarePosterKey!.isNotEmpty
                        ? Image.asset(
                            AssetMapper.getAssetPath(_selfCarePosterKey!),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => _buildPosterPlaceholder(),
                          )
                        : _buildPosterPlaceholder(),
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: AspectRatio(
                aspectRatio: 7 / 10,
                child: _buildPosterPlaceholder(),
              ),
            ),
          ],
          
          // Content section
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWellnessTip(
                  icon: Icons.self_improvement,
                  title: 'Mindfulness',
                  description: 'Practice daily meditation and breathing exercises to maintain balance.',
                ),
                _buildWellnessTip(
                  icon: Icons.fitness_center,
                  title: 'Physical Activity',
                  description: 'Engage in gentle exercises that align with your element energy.',
                ),
                _buildWellnessTip(
                  icon: Icons.restaurant,
                  title: 'Nutrition',
                  description: 'Choose foods that support your element balance and overall wellness.',
                ),
                _buildWellnessTip(
                  icon: Icons.bedtime,
                  title: 'Rest & Recovery',
                  description: 'Ensure adequate sleep and rest periods to maintain energy balance.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Build poster placeholder
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

  /// Build wellness tip card
  Widget _buildWellnessTip({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryTeal,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.neutralText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6C7A76),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get element icon
  IconData _getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'water':
        return Icons.water_drop;
      case 'wind':
        return Icons.air;
      case 'earth':
        return Icons.landscape;
      default:
        return Icons.nature;
    }
  }
}
