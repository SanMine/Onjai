<<<<<<< HEAD
# Oonjai (อุ่นใจ — “Warm Heart”)

A **Flutter + Firebase health management application** inspired by the principles of **Thai traditional medicine**, focusing on balancing the **four elements** — Earth, Water, Wind, and Fire.
Developed as a **volunteer project** to support the **School of Applied Medicine** at Mae Fah Luang University.

---

## 🌟 Features

* 🔑 **Authentication**
  Secure login, signup, and password reset with Firebase Authentication.

* 📅 **Personalized Health Guidance**
  User’s date of birth determines their **day of week → element mapping** for tailored recommendations.

* 🖼️ **Dynamic Content from Firebase**
  Posters and backgrounds for Dashboard, Traveling, and Self-care sections.

* 🍲 **Eating Recommendations**

  * Categorized foods (Great / Avoid / Suggestion)
  * Favorite system to save user-preferred foods

* ✈️ **Traveling Insights**

  * Element-specific travel poster & symptom text
  * Physical therapy routines with posters, descriptions, and linked medicines

* 💊 **Therapy Details**

  * Exercises with visuals and guidance
  * Recommended medicines with images

* 👤 **User Profile**
  Profile photo upload, personal details, date of birth, and element type.

* ⚙️ **Admin-lite CMS**
  Restricted admin interface to upload posters, foods, therapy, and medicine content.

* 🌏 **Internationalization**
  Multi-language support (English + Thai).

---

## 🏗️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend & Database:** Firebase (Auth, Firestore, Storage)

## 📲 App Workflow

1. **Login / Sign Up / Forgot Password**
2. **First-time User Popup** → Collect Name & Date of Birth
3. **Dashboard** → Shows element-based poster & 3 main functions:

   * Eating
   * Traveling
   * Self-care
4. **Eating Section** → Food recommendations (Great, Avoid, Suggestion, Favorites)
5. **Traveling Section** → Posters, Symptom guidance, Therapy routines + medicines
6. **Self-care Section** → Element-specific poster
7. **Profile** → User info, profile photo, logout

=======
# Oonjai - Flutter + Firebase App

A wellness app that provides personalized recommendations based on elemental astrology.

## Features

- **Authentication**: Email/password login with Firebase Auth
- **Profile Management**: Complete user profiles with DOB-based element mapping
- **Element-Based Content**: Personalized posters and recommendations
- **Eating Guide**: Food recommendations filtered by element and category
- **Traveling Guide**: Travel tips, symptoms, and therapy recommendations
- **Self-Care**: Element-specific wellness content
- **Profile Photos**: Upload and crop profile pictures
- **Favorites**: Save and manage favorite foods

## Setup Instructions

### 1. Firebase Configuration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password)
3. Enable Cloud Firestore Database
4. Enable Firebase Storage
5. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
6. Place them in the appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 2. Firebase Security Rules

#### Firestore Rules
Copy the contents of `lib/firebase_rules/firestore.rules` to your Firebase Console:
1. Go to Firestore Database → Rules
2. Replace the default rules with the provided rules
3. Click "Publish"

#### Storage Rules
Copy the contents of `lib/firebase_rules/storage.rules` to your Firebase Console:
1. Go to Storage → Rules
2. Replace the default rules with the provided rules
3. Click "Publish"

### 3. Dependencies

The app uses the following key dependencies:
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database operations
- `firebase_storage`: File storage
- `image_picker`: Image selection
- `image_cropper`: Image cropping
- `cached_network_image`: Image caching
- `shimmer`: Loading placeholders

### 4. Platform Configuration

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Kotlin version: 2.1.0
- Java version: 17

#### iOS
- Minimum iOS version: 12.0
- Permissions configured for camera and photo library access

## Debug Seeder (Development Only)

The app includes a debug seeder to populate sample data for testing. This is only available in debug mode.

### Accessing the Debug Seeder

1. Run the app in debug mode: `flutter run`
2. Navigate to the Dashboard
3. Tap the "Debug Seeder" button (science icon) in the app bar
4. Use the seeder buttons to populate data:

### Available Seeders

- **Seed Config**: Creates day-element mapping
- **Seed Content**: Creates element content with poster paths
- **Seed Foods**: Creates sample food items
- **Seed Medicines**: Creates sample medicine items
- **Seed Therapy**: Creates sample therapy items
- **Upload Placeholder Images**: Uploads placeholder images to Storage
- **Seed Everything**: Runs all seeders in sequence

### Manual Data Setup (Alternative)

If you prefer to set up data manually, here are the required collections:

#### 1. Day-Element Mapping
```
Collection: config
Document: dayElementMapping
{
  "sunday": "Fire",
  "monday": "Earth", 
  "tuesday": "Wind",
  "wednesday": "Water",
  "thursday": "Earth",
  "friday": "Water",
  "saturday": "Fire"
}
```

#### 2. Element Content
```
Collection: content
Document: {element} (Fire, Water, Wind, Earth)
{
  "dashboardPosterKey": "fire_dashboard",
  "travelPosterKey": "fire_travel", 
  "selfCarePosterKey": "fire_selfcare",
  "symptomText": "Element-specific symptom description..."
}
```

#### 3. Foods
```
Collection: foods
Document: {foodId}
{
  "name": "Food Name",
  "imagePath": "foods/food_image.jpg",
  "category": "great|avoid|suggestion",
  "elements": ["Fire", "Water", "Wind", "Earth"]
}
```

#### 4. Medicines
```
Collection: medicines
Document: {medicineId}
{
  "name": "Medicine Name",
  "imagePath": "medicines/medicine_image.jpg",
  "elements": ["Fire", "Water", "Wind", "Earth"]
}
```

#### 5. Therapy
```
Collection: therapy
Document: {therapyId}
{
  "title": "Therapy Title",
  "thumbnailPath": "therapy/therapy_thumb.jpg",
  "detailPosterPath": "therapy/therapy_poster.jpg",
  "description": "Therapy description...",
  "elements": ["Fire", "Water", "Wind", "Earth"],
  "medicines": ["medicineId1", "medicineId2"]
}
```

## App Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_profile.dart
│   ├── element_content.dart
│   ├── food.dart
│   ├── therapy.dart
│   └── medicine.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── user_service.dart
│   ├── element_mapping_service.dart
│   ├── storage_service.dart
│   ├── content_service.dart
│   ├── foods_service.dart
│   ├── therapy_service.dart
│   ├── medicines_service.dart
│   └── favorites_service.dart
├── screens/                  # UI screens
│   ├── login.dart
│   ├── signup.dart
│   ├── forgot_password.dart
│   ├── dashboard.dart
│   ├── profile/
│   │   └── profile_page.dart
│   ├── eating/
│   │   ├── eating_page.dart
│   │   └── tabs/
│   ├── traveling/
│   │   ├── traveling_page.dart
│   │   ├── therapy_detail_page.dart
│   │   └── tabs/
│   ├── selfcare/
│   │   └── selfcare_page.dart
│   └── debug/
│       └── debug_seeder_page.dart
├── widgets/                  # Reusable components
│   ├── collect_dob_dialog.dart
│   ├── profile_photo_uploader.dart
│   ├── poster_view.dart
│   ├── food_tile.dart
│   ├── therapy_tile.dart
│   └── medicine_tile.dart
├── utils/                    # Utilities
│   ├── firebase_diagnostics.dart
│   └── firestore_seeder.dart
└── firebase_rules/           # Security rules
    ├── firestore.rules
    └── storage.rules
```

## Development Workflow

1. **Setup**: Configure Firebase and run the debug seeder
2. **Testing**: Test authentication, profile completion, and content loading
3. **Customization**: Modify content, add new features, or adjust UI
4. **Deployment**: Build for production and deploy

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Ensure `google-services.json` and `GoogleService-Info.plist` are in the correct locations
2. **Permission denied**: Check that Firebase security rules are properly configured
3. **Image upload fails**: Verify Storage rules allow user uploads
4. **Build errors**: Ensure all dependencies are properly configured in `pubspec.yaml`

### Debug Tools

- Use the Firebase Diagnostics utility to check configuration
- Use the Debug Seeder to populate test data
- Check Firebase Console logs for detailed error information

## Next Steps

The app is ready for:
- Content customization
- Additional features
- UI/UX improvements
- Performance optimization
- Production deployment

## License

This project is for educational and development purposes.
>>>>>>> 67a3357 (Initial commit: Oonjai Flutter app with user profile and therapy features)
