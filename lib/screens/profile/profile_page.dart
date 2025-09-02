import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../utils/asset_mapper.dart';
import '../login.dart';

/// Profile page for displaying user information
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _userService = UserService();
  
  User? _currentUser;
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _loadUserProfile();
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
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? const Center(child: Text('User not found'))
              : _userProfile == null
                  ? const Center(child: Text('Profile not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile photo section
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      AssetMapper.getAssetPath('app_placeholder_avatar'),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Profile Photo',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // User information section
                          Text(
                            'Personal Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInfoCard([
                            _buildInfoRow('Name', _userProfile!.displayName),
                            _buildInfoRow('Email', _userProfile!.email),
                            _buildInfoRow('Date of Birth', _formatDate(_userProfile!.dob)),
                            _buildInfoRow('Day of Week', _userProfile!.dayOfWeek),
                            _buildElementRow(),
                          ]),
                          
                          const SizedBox(height: 24),
                          

                          
                          const SizedBox(height: 32),
                          
                          // Account actions section
                          Text(
                            'Account',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.red[400],
                                  ),
                                  title: const Text('Sign Out'),
                                  subtitle: const Text('Sign out of your account'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: _handleSignOut,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  /// Build placeholder avatar
  Widget _buildPlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: 60,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Build information card
  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Column(
        children: children,
      ),
    );
  }

  /// Build information row
  Widget _buildInfoRow(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value.isEmpty ? 'Not set' : value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build element row with icon and name on same line
  Widget _buildElementRow() {
    return ListTile(
      title: Text(
        'Element',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            _getElementIcon(_userProfile!.element),
            color: _getElementColor(_userProfile!.element),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _userProfile!.element,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get element icon
  IconData _getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'water':
        return Icons.water_drop;
      case 'earth':
        return Icons.landscape;
      case 'wind':
        return Icons.air;
      default:
        return Icons.help_outline;
    }
  }

  /// Get element color
  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'earth':
        return Colors.brown;
      case 'wind':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
