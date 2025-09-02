// Simple test to verify asset mapping and file existence
import 'lib/utils/asset_mapper.dart';

void main() {
  print('=== Asset Mapping Debug Test ===');
  
  // Test the three therapy keys
  final testKeys = ['leg1', 'arm1', 'shoulder1'];
  
  for (final key in testKeys) {
    final path = AssetMapper.getAssetPath(key);
    print('Key: "$key" -> Path: "$path"');
  }
  
  print('\n=== All Therapy-related Keys ===');
  // This will show us what therapy keys are actually available
  // Note: We can't easily access _assetMap here, but the debug prints in AssetMapper will help
}
