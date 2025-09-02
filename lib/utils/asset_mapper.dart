/// Utility class to map Firestore image keys to local asset paths
/// 
/// This replaces Firebase Storage paths with local asset references.
/// To add new images:
/// 1. Add the image file to the appropriate assets/images/ subfolder
/// 2. Add a mapping entry in this class
/// 3. Update Firestore documents to use the new key
class AssetMapper {
  // Private constructor to prevent instantiation
  AssetMapper._();

  /// Map of image keys to asset paths
  static const Map<String, String> _assetMap = {
    // Element posters
    'fire_dashboard': 'assets/images/posters/fire_dashboard.jpg',
    'fire_travel': 'assets/images/posters/fire_travel.jpg',
    'fire_selfcare': 'assets/images/posters/fire_selfcare.jpg',
    
    'water_dashboard': 'assets/images/posters/water_dashboard.jpg',
    'water_travel': 'assets/images/posters/water_travel.jpg',
    'water_selfcare': 'assets/images/posters/water_selfcare.jpg',
    
    'wind_dashboard': 'assets/images/posters/wind_dashboard.jpg',
    'wind_travel': 'assets/images/posters/wind_travel.jpg',
    'wind_selfcare': 'assets/images/posters/wind_selfcare.jpg',
    
    'earth_dashboard': 'assets/images/posters/earth_dashboard.jpg',
    'earth_travel': 'assets/images/posters/earth_travel.jpg',
    'earth_selfcare': 'assets/images/posters/earth_selfcare.jpg',
    
    // Food images
    'ginger': 'assets/images/foods/ginger.jpg',
    'galangal': 'assets/images/foods/galangal.jpg',
    'lemongrass': 'assets/images/foods/lemongrass.jpg',
    'black_pepper': 'assets/images/foods/black_pepper.jpg',
    'thai_basil': 'assets/images/foods/thai_basil.jpg',
    'cumin_seeds': 'assets/images/foods/cumin_seeds.jpg',
    'garlic': 'assets/images/foods/garlic.jpg',
    'holy_basil': 'assets/images/foods/holy_basil.jpg',
    'turmeric': 'assets/images/foods/turmeric.jpg',
    'coriander_seeds': 'assets/images/foods/coriander_seeds.jpg',
    'Lime_leaves': 'assets/images/foods/Lime_leaves.jpg',
    'thong_yip': 'assets/images/foods/thong_yip.jpg',
    'thong_yot': 'assets/images/foods/thong_yot.jpg',
    'foi_thong': 'assets/images/foods/foi_thong.jpg',
    'mango_sticky_rice': 'assets/images/foods/mango_sticky_rice.jpg',
    'cake': 'assets/images/foods/cake.jpg',
    'cookies': 'assets/images/foods/cookies.jpg',
    'ice_cream': 'assets/images/foods/ice_cream.jpg',
    'tom_kha_gai': 'assets/images/foods/tom_kha_gai.jpg',
    'tom_yum_soup': 'assets/images/foods/tom_yum_soup.jpg',
    'som_tam': 'assets/images/foods/som_tam.jpg',
    'noodle_soup': 'assets/images/foods/noodle_soup.jpg',
    'bbq': 'assets/images/foods/bbq.jpg',


    // Therapy images
    'leg1': 'assets/images/therapy/leg1.jpg',
    'leg2': 'assets/images/therapy/leg2.jpg',
    'arm1': 'assets/images/therapy/arm1.jpg',
    'shoulder1': 'assets/images/therapy/shoulder1.jpg',
    'therapy_cooling_bath_thumb': 'assets/images/therapy/therapy_cooling_bath_thumb.jpg',
    'therapy_cooling_bath_poster': 'assets/images/therapy/therapy_cooling_bath_poster.jpg',
    'therapy_wind_massage_thumb': 'assets/images/therapy/therapy_wind_massage_thumb.jpg',
    'therapy_wind_massage_poster': 'assets/images/therapy/therapy_wind_massage_poster.jpg',
    'therapy_earth_acupressure_thumb': 'assets/images/therapy/therapy_earth_acupressure_thumb.jpg',
    'therapy_earth_acupressure_poster': 'assets/images/therapy/therapy_earth_acupressure_poster.jpg',
    
    // Therapy step images (examples for the new steps-based structure)
    'leg_stretch_1': 'assets/images/therapy/leg_stretch_1.jpg',
    'leg_stretch_2': 'assets/images/therapy/leg_stretch_2.jpg',
    'leg_massage_1': 'assets/images/therapy/leg_massage_1.jpg',
    'leg_massage_2': 'assets/images/therapy/leg_massage_2.jpg',
    'arm_exercise_1': 'assets/images/therapy/arm_exercise_1.jpg',
    'arm_exercise_2': 'assets/images/therapy/arm_exercise_2.jpg',
    'shoulder_stretch_1': 'assets/images/therapy/shoulder_stretch_1.jpg',
    'shoulder_stretch_2': 'assets/images/therapy/shoulder_stretch_2.jpg',
    
    // Medicine images
    'Aloe_Vera': 'assets/images/medicines/Aloe_Vera.jpg',
    'Centella_asiatica_capsule_medicine': 'assets/images/medicines/Centella_asiatica_capsule_medicine.jpg',
    'Garcidine': 'assets/images/medicines/Garcidine.jpg',
    'Pharaoh_yo_cream': 'assets/images/medicines/Pharaoh_yo_cream.jpg',
    'Amaruektawatee': 'assets/images/medicines/Amaruektawatee.jpg',
    'Ya_Prab_Chom_Phoo_Ta_Weep': 'assets/images/medicines/Ya_Prab_Chom_Phoo_Ta_Weep.jpg',
    'Fa_Thalai_Chon': 'assets/images/medicines/Fa_Thalai_Chon.jpg',
    'Ya_Prasah_Ma_Waeng': 'assets/images/medicines/Ya_Prasah_Ma_Waeng.jpg',
    'Yaa_Om_Kae_Ai_Makham_Pom': 'assets/images/medicines/Yaa_Om_Kae_Ai_Makham_Pom.jpg',
    'Yaa_Khieow': 'assets/images/medicines/Yaa_Khieow.jpg',
    'Ha_Rak_Herbal': 'assets/images/medicines/Ha_Rak_Herbal.jpg',
    'Ya_Prasa_Chan_Daeng': 'assets/images/medicines/Ya_Prasa_Chan_Daeng.jpg',
    'Ya_Jan_Leela': 'assets/images/medicines/Ya_Jan_Leela.jpg',
    'Ya_Thao_Wan_Priang': 'assets/images/medicines/Ya_Thao_Wan_Priang.jpg',
    'Herbal_compress': 'assets/images/medicines/Herbal_compress.jpg',
    'Kae_Lom_Kae_Sen': 'assets/images/medicines/Kae_Lom_Kae_Sen.jpg',
    'Pla_Oil': 'assets/images/medicines/Pla_Oil.jpg',
    'Sahas_Thara': 'assets/images/medicines/Sahas_Thara.jpg',
    'compound_cat_whisker_capsule': 'assets/images/medicines/compound_cat_whisker_capsule.jpg',
    'Ya_Krajiap_Daeng': 'assets/images/medicines/Ya_Krajiap_Daeng.jpg',
    'Ya_Rang_Jued': 'assets/images/medicines/Ya_Rang_Jued.jpg',
    'Ya_Benjakul': 'assets/images/medicines/Ya_Benjakul.jpg',
    'Ya_Khamin_Chan': 'assets/images/medicines/Ya_Khamin_Chan.jpg',
    'Ya_Chum_Hed_Thet': 'assets/images/medicines/Ya_Chum_Hed_Thet.jpg',
    'Ya_Prasa_Kra_Pao': 'assets/images/medicines/Ya_Prasa_Kra_Pao.jpg',
    'Ya_Hom_Nawa_Kot': 'assets/images/medicines/Ya_Hom_Nawa_Kot.jpg',
    'Ya_Hom_Inthajak': 'assets/images/medicines/Ya_Hom_Inthajak.jpg',
    'Ya_Thip_Osot': 'assets/images/medicines/Ya_Thip_Osot.jpg',
    'Ya_Hom_Thepchit': 'assets/images/medicines/Ya_Hom_Thepchit.jpg',
    'Ya_Luead_Ngam': 'assets/images/medicines/Ya_Luead_Ngam.jpg',
    'Ya_Leng_Khun': 'assets/images/medicines/Ya_Leng_Khun.jpg',
    'Ya_Pluk_Fai_That': 'assets/images/medicines/Ya_Pluk_Fai_That.jpg',
    'Ya_Prasa_Phlai': 'assets/images/medicines/Ya_Prasa_Phlai.jpg',

    
    
    
    // App images
    'app_logo': 'assets/images/app/app_logo.png',
    'app_placeholder_avatar': 'assets/images/app/app_placeholder_avatar.png',
    'app_placeholder_food': 'assets/images/app/app_placeholder_food.png',
    'app_placeholder_therapy': 'assets/images/app/app_placeholder_therapy.png',
    'app_placeholder_medicine': 'assets/images/app/app_placeholder_medicine.png',
  };

  /// Get asset path for a given image key
  /// 
  /// Returns the asset path if the key exists, otherwise returns a placeholder
  static String getAssetPath(String key) {
    // Debug: Print the key being requested
    print('DEBUG AssetMapper: Looking up key: "$key"');
    
    if (key.isEmpty) {
      print('DEBUG AssetMapper: Key is empty, returning placeholder');
      return _assetMap['app_placeholder_food'] ?? 'assets/images/app/app_placeholder_food.png';
    }
    
    final assetPath = _assetMap[key];
    if (assetPath != null) {
      print('DEBUG AssetMapper: Found mapping for "$key" -> "$assetPath"');
      return assetPath;
    } else {
      print('DEBUG AssetMapper: No mapping found for "$key", using placeholder');
      print('DEBUG AssetMapper: Available therapy keys: ${_assetMap.keys.where((k) => k.contains('leg') || k.contains('arm') || k.contains('shoulder')).toList()}');
      return _getPlaceholderForCategory(key);
    }
  }

  /// Get appropriate placeholder based on key category
  static String _getPlaceholderForCategory(String key) {
    if (key.startsWith('food_')) {
      return _assetMap['app_placeholder_food'] ?? 'assets/images/app/app_placeholder_food.png';
    } else if (key.startsWith('therapy_')) {
      return _assetMap['app_placeholder_therapy'] ?? 'assets/images/app/app_placeholder_therapy.png';
    } else if (key.startsWith('medicine_')) {
      return _assetMap['app_placeholder_medicine'] ?? 'assets/images/app/app_placeholder_medicine.png';
    } else if (key.contains('dashboard') || key.contains('travel') || key.contains('selfcare')) {
      return _assetMap['app_placeholder_therapy'] ?? 'assets/images/app/app_placeholder_therapy.png';
    } else {
      return _assetMap['app_placeholder_food'] ?? 'assets/images/app/app_placeholder_food.png';
    }
  }

  /// Check if an asset key exists
  static bool hasAsset(String key) {
    return _assetMap.containsKey(key);
  }

  /// Get all available asset keys
  static List<String> getAvailableKeys() {
    return _assetMap.keys.toList();
  }

  /// Get all asset keys for a specific category
  static List<String> getKeysForCategory(String category) {
    return _assetMap.keys.where((key) => key.startsWith('${category}_')).toList();
  }

  /// Get all poster keys for an element
  static List<String> getPosterKeysForElement(String element) {
    return [
      '${element.toLowerCase()}_dashboard',
      '${element.toLowerCase()}_travel',
      '${element.toLowerCase()}_selfcare',
    ];
  }

  /// Get all food keys
  static List<String> getFoodKeys() {
    return getKeysForCategory('food');
  }

  /// Get all therapy keys
  static List<String> getTherapyKeys() {
    return getKeysForCategory('therapy');
  }

  /// Get all medicine keys
  static List<String> getMedicineKeys() {
    return getKeysForCategory('medicine');
  }
}
