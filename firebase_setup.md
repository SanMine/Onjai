# Firebase Setup Guide for Oonjai

This guide will help you set up Firebase for your Oonjai Flutter app.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: "Oonjai"
4. Choose whether to enable Google Analytics (recommended)
5. Click "Create project"

## Step 2: Enable Authentication

1. In your Firebase project, go to "Authentication" in the left sidebar
2. Click "Get started"
3. Go to the "Sign-in method" tab
4. Enable "Email/Password" provider
5. Click "Save"

## Step 3: Add Your App

### For Android:

1. Click the Android icon (</>) to add an Android app
2. Enter Android package name: `com.example.oonjai` (or your custom package name)
3. Enter app nickname: "Oonjai Android"
4. Click "Register app"
5. Download the `google-services.json` file
6. Place it in `android/app/` directory

### For iOS:

1. Click the iOS icon to add an iOS app
2. Enter iOS bundle ID: `com.example.oonjai` (or your custom bundle ID)
3. Enter app nickname: "Oonjai iOS"
4. Click "Register app"
5. Download the `GoogleService-Info.plist` file
6. Place it in `ios/Runner/` directory

### For Web:

1. Click the Web icon to add a Web app
2. Enter app nickname: "Oonjai Web"
3. Click "Register app"
4. Copy the Firebase configuration object

## Step 4: Configure Platform-Specific Files

### Android Configuration

1. Add to `android/build.gradle` (project level):
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

2. Add to `android/app/build.gradle` (app level):
```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS Configuration

1. Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from your `GoogleService-Info.plist` file.

### Web Configuration

1. Add to `web/index.html` before the closing `</body>` tag:
```html
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-auth.js"></script>
<script>
  const firebaseConfig = {
    apiKey: "your-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-app-id"
  };
  firebase.initializeApp(firebaseConfig);
</script>
```

Replace the config values with your actual Firebase configuration.

## Step 5: Test the Setup

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to start the app
3. Try creating a new account or signing in
4. Check Firebase Console > Authentication > Users to see if users are being created

## Troubleshooting

### Common Issues:

1. **"No Firebase App '[DEFAULT]' has been created"**
   - Make sure Firebase is properly initialized in `main.dart`
   - Check that configuration files are in the correct locations

2. **"google-services.json not found"**
   - Ensure the file is placed in `android/app/` directory
   - Check that the package name matches your app's package name

3. **"GoogleService-Info.plist not found"**
   - Ensure the file is placed in `ios/Runner/` directory
   - Check that the bundle ID matches your app's bundle ID

4. **Authentication not working**
   - Verify Email/Password provider is enabled in Firebase Console
   - Check that the app is properly registered in Firebase

### Getting Help:

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firebase Console Help](https://support.google.com/firebase/)
- [Flutter Firebase Community](https://github.com/FirebaseExtended/flutterfire)

## Security Rules

For production, consider setting up proper Firebase Security Rules:

1. Go to Firebase Console > Firestore Database > Rules
2. Set up appropriate read/write rules
3. Consider implementing user-based access control

## Next Steps

After setting up Firebase:

1. Test all authentication flows (login, signup, password reset)
2. Consider adding email verification
3. Implement user profile management
4. Add social authentication providers if needed
5. Set up proper error monitoring and analytics
