import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/user_profile.dart';
import '../../../services/content_service.dart';
import '../../../services/user_service.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/asset_mapper.dart';

/// Travel tab showing element-based travel poster
class TravelTab extends StatefulWidget {
  const TravelTab({super.key});

  @override
  State<TravelTab> createState() => _TravelTabState();
}

class _TravelTabState extends State<TravelTab> {
  final _contentService = ContentService();
  final _userService = UserService();
  
  User? _currentUser;
  UserProfile? _userProfile;
  bool _isLoading = true;
  
  // Element travel poster
  String? _travelPosterKey;
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
      if (elementContent?.travelPosterKey.isNotEmpty == true) {
        if (mounted) {
          setState(() {
            _travelPosterKey = elementContent!.travelPosterKey;
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _userProfile == null
            ? _buildErrorState()
            : _buildContent();
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
                            'Travel Guide for',
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
          
          // Travel poster with new styling (element-based)
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
                    child: _travelPosterKey != null && _travelPosterKey!.isNotEmpty
                        ? Image.asset(
                            AssetMapper.getAssetPath(_travelPosterKey!),
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
