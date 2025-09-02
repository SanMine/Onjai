import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/asset_mapper.dart';

/// Reusable widget for displaying medicine items
class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final bool showImage;

  const MedicineTile({
    super.key,
    required this.medicine,
    this.onTap,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 60,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Medicine image (if enabled)
              if (showImage) ...[
                _buildMedicineImage(),
                const SizedBox(width: 12),
              ],
              
              // Medicine name
              Expanded(
                child: Text(
                  medicine.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build medicine image using local asset
  Widget _buildMedicineImage() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          AssetMapper.getAssetPath(medicine.imageKey),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: child,
            );
          },
        ),
      ),
    );
  }

  /// Build error placeholder
  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.medication,
        color: Colors.grey[400],
        size: 20,
      ),
    );
  }
}

/// Compact medicine chip widget
class MedicineChip extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final bool showImage;

  const MedicineChip({
    super.key,
    required this.medicine,
    this.onTap,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: showImage
          ? CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.medication,
                size: 16,
                color: Colors.grey[600],
              ),
            )
          : null,
      label: Text(
        medicine.displayName,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.blue[50],
      side: BorderSide(color: Colors.blue[200]!),
    );
  }
}
