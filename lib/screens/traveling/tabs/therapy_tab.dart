import 'package:flutter/material.dart';

import '../../../models/therapy.dart';
import '../../../services/therapy_service.dart';
import '../../../utils/asset_mapper.dart';

class TherapyTab extends StatefulWidget {
  const TherapyTab({super.key});

  @override
  State<TherapyTab> createState() => _TherapyTabState();
}

class _TherapyTabState extends State<TherapyTab> {
  final _therapyService = TherapyService();
  String _selectedBodyPart = 'Shoulder';

  /// Updates the selected body part and rebuilds the UI
  void _selectBodyPart(String bodyPart) {
    setState(() {
      _selectedBodyPart = bodyPart;
    });
    // Debug: Print selected body part
    print('DEBUG: Selected body part: $bodyPart');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Body part selection buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Shoulder', 'Arm', 'Leg'].map((part) {
                  final isSelected = part == _selectedBodyPart;
                  return ElevatedButton(
                    onPressed: () => _selectBodyPart(part),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      foregroundColor: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: Text(part == 'Shoulder' ? 'Shoulders' : part == 'Arm' ? 'Arms' : 'Legs'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Therapy content
              StreamBuilder<Therapy?>(
                stream: _therapyService.streamByBodyPart(_selectedBodyPart),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final therapy = snapshot.data;
                  if (therapy == null) {
                    return const Center(
                      child: Text('No therapy found for this body part'),
                    );
                  }

                  // Debug: Print therapy data
                  print('DEBUG: Therapy data for $_selectedBodyPart: id=${therapy.id}, imageKey=${therapy.imageKey}, description length=${therapy.description.length}');
                  print('DEBUG: Asset path will be: ${AssetMapper.getAssetPath(therapy.imageKey)}');

                  return _buildTherapyContent(therapy);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the therapy content display with image and description
  Widget _buildTherapyContent(Therapy therapy) {
    return Column(
      children: [
        // Therapy poster
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 7/10,
              child: Image.asset(
                AssetMapper.getAssetPath(therapy.imageKey),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Debug: Print error details
                  print('DEBUG: Image loading error for ${therapy.imageKey}');
                  print('DEBUG: Asset path attempted: ${AssetMapper.getAssetPath(therapy.imageKey)}');
                  print('DEBUG: Error: $error');
                  print('DEBUG: StackTrace: $stackTrace');
                  
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load: ${therapy.imageKey}',
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Path: ${AssetMapper.getAssetPath(therapy.imageKey)}',
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Therapy description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            therapy.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
