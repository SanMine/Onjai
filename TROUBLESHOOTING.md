# Oonjai App - Sign Up Troubleshooting Guide

This guide helps you resolve common issues with the sign up functionality.

## Quick Diagnostic

1. **Run Firebase Diagnostics**
   - Open the app and go to the login screen
   - Tap the "🔍 Run Firebase Diagnostics" button
   - Check the console output and SnackBar message
   - This will identify if Firebase is properly configured

## Common Issues & Solutions

### 1. "Email/password accounts are not enabled"

**Problem**: Firebase Authentication doesn't have email/password provider enabled.

**Solution**:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Authentication → Sign-in method
4. Enable "Email/Password" provider
5. Click "Save"

### 2. "Network error" or "Network request failed"

**Problem**: Internet connectivity or Firebase configuration issues.

**Solutions**:
1. Check your internet connection
2. Verify Firebase configuration files are present:
   - `android/app/google-services.json` (Android)
   - `ios/Runner/GoogleService-Info.plist` (iOS)
3. Ensure Firebase project is active and not suspended

### 3. "Invalid email" error

**Problem**: Email format validation is failing.

**Solution**:
- Use a valid email format (e.g., `user@example.com`)
- Avoid special characters or spaces
- Ensure email domain is valid

### 4. "Weak password" error

**Problem**: Password doesn't meet Firebase requirements.

**Solution**:
- Use at least 6 characters
- Include a mix of letters, numbers, and symbols
- Avoid common passwords

### 5. "Email already in use"

**Problem**: An account with this email already exists.

**Solution**:
- Use a different email address
- Or try logging in instead of signing up
- Or reset password if you forgot it

### 6. "Firebase not initialized" error

**Problem**: Firebase Core is not properly initialized.

**Solution**:
1. Check that `google-services.json` is in the correct location
2. Verify Android build.gradle files are configured
3. Clean and rebuild the project:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### 7. "Permission denied" or "Security rules" error

**Problem**: Firestore security rules are blocking access.

**Solution**:
1. Go to Firebase Console → Firestore Database → Rules
2. Temporarily set rules to allow all access (for testing):
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```
3. Test sign up again
4. Remember to set proper security rules for production

## Debug Steps

### Step 1: Check Firebase Configuration
1. Verify `google-services.json` exists in `android/app/`
2. Check that Firebase project is active
3. Ensure Authentication is enabled

### Step 2: Test Firebase Connection
1. Run the diagnostic tool in the app
2. Check console output for specific errors
3. Verify network connectivity

### Step 3: Check App Logs
1. Run the app in debug mode
2. Watch console output during sign up attempt
3. Look for specific error codes and messages

### Step 4: Test with Different Credentials
1. Try a different email address
2. Use a stronger password
3. Test on different network (mobile data vs WiFi)

## Firebase Console Checklist

- [ ] Project is active (not suspended)
- [ ] Authentication is enabled
- [ ] Email/Password provider is enabled
- [ ] Firestore Database is enabled
- [ ] Security rules allow user creation
- [ ] App is properly registered in project

## Android Configuration Checklist

- [ ] `google-services.json` in `android/app/`
- [ ] Google Services plugin in `android/build.gradle`
- [ ] Plugin applied in `android/app/build.gradle`
- [ ] Firebase dependencies in `pubspec.yaml`
- [ ] App package name matches Firebase registration

## Testing Sign Up

### Valid Test Credentials
- Email: `test@example.com`
- Password: `TestPassword123!`

### Invalid Test Cases
- Email: `invalid-email` (should fail)
- Password: `123` (too short, should fail)
- Email: `existing@example.com` (if already exists, should fail)

## Getting Help

If you're still having issues:

1. **Check the console output** for specific error messages
2. **Run the diagnostic tool** and share the results
3. **Verify Firebase Console** settings
4. **Test with the provided test credentials**
5. **Check network connectivity**

## Common Error Codes

| Error Code | Meaning | Solution |
|------------|---------|----------|
| `email-already-in-use` | Account exists | Use different email or login |
| `invalid-email` | Bad email format | Use valid email format |
| `weak-password` | Password too weak | Use stronger password |
| `operation-not-allowed` | Auth provider disabled | Enable in Firebase Console |
| `network-request-failed` | Network issue | Check internet connection |
| `user-disabled` | Account disabled | Contact support |
| `too-many-requests` | Rate limited | Wait and try again |

## Production Considerations

Before deploying to production:

1. **Set proper Firestore security rules**
2. **Enable email verification** (optional)
3. **Configure password reset** functionality
4. **Set up proper error monitoring**
5. **Test on multiple devices and networks**
6. **Remove debug buttons and diagnostic tools**
