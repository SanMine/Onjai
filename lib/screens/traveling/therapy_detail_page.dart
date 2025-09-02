import 'package:flutter/material.dart';

import '../../models/medicine.dart';
import '../../models/therapy.dart';
import '../../services/therapy_service.dart';
import '../../widgets/medicine_tile.dart';
import '../../widgets/poster_view.dart';

/// Detail page for therapy items
class TherapyDetailPage extends StatefulWidget {
  final String therapyPath;

  const TherapyDetailPage({
    super.key,
    required this.therapyPath,
  });

  @override
  State<TherapyDetailPage> createState() => _TherapyDetailPageState();
}

class _TherapyDetailPageState extends State<TherapyDetailPage> {
  final _therapyService = TherapyService();
  
  Therapy? _therapy;
  List<Medicine> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTherapyDetails();
  }

  /// Load therapy details and related medicines
  Future<void> _loadTherapyDetails() async {
    try {
      // Load therapy details
      // Prefer direct by body part; fall back to doc-by-path for safety
      Therapy? therapy;
      if (widget.therapyPath.startsWith('therapy/')) {
        final parts = widget.therapyPath.split('/');
        if (parts.length >= 2) {
          therapy = await _therapyService.getByBodyPart(parts[1]);
        }
      }
      therapy ??= await _therapyService.getByBodyPart(widget.therapyPath);
      if (therapy == null) {
        throw Exception('Therapy not found');
      }

      // No medicines in the simplified model
      List<Medicine> medicines = [];

      if (mounted) {
        setState(() {
          _therapy = therapy;
          _medicines = medicines;
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
            content: Text('Error loading therapy details: $e'),
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
        title: Text(_therapy?.id ?? 'Therapy Details'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _therapy == null
              ? _buildErrorState()
              : _buildContent(),
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
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Therapy not found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The requested therapy could not be loaded',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
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
          // Therapy poster
          Container(
            height: 300,
            width: double.infinity,
            child: PosterView(
              imageKey: _therapy!.imageKey,
              fit: BoxFit.contain,
            ),
          ),
          
          // Therapy details
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  _therapy!.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Recommended medicines
                if (_medicines.isNotEmpty) _buildMedicinesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build medicines section
  Widget _buildMedicinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Medicines',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _medicines.length,
          itemBuilder: (context, index) {
            final medicine = _medicines[index];
            return MedicineTile(medicine: medicine);
          },
        ),
      ],
    );
  }
}
