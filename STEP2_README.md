# Oonjai App - Step 2: Profile Completion & Element Mapping

This document describes the implementation of Step 2 of the Oonjai app, which adds profile completion flow and element mapping functionality.

## Overview

Step 2 implements a blocking profile completion flow that:
1. Collects user's full name and date of birth after first login
2. Derives day of week from DOB (local timezone)
3. Maps day to element using Firestore configuration
4. Saves complete profile to `users/{uid}` collection
5. Displays element information on dashboard

## New Files Created

### Models
- **`lib/models/user_profile.dart`** - User profile data model with Firestore serialization

### Services
- **`lib/services/user_service.dart`** - User profile CRUD operations
- **`lib/services/element_mapping_service.dart`** - Day-to-element mapping logic

### Widgets
- **`lib/widgets/collect_dob_dialog.dart`** - Blocking modal for profile completion

### Utils
- **`lib/utils/firestore_seeder.dart`** - Utility to seed Firestore with initial data

## Updated Files

### `lib/main.dart`
- Added `ProfileCompletionWrapper` to handle auth state and profile completeness
- Integrated blocking modal flow before dashboard access

### `lib/screens/dashboard.dart`
- Added user profile loading and display
- Shows element information with icons and colors
- Added debug button to seed Firestore data

## Firestore Structure

### Collections

#### `users/{uid}`
```json
{
  "displayName": "John Doe",
  "email": "john@example.com",
  "dob": "1990-01-15T00:00:00.000Z",
  "dayOfWeek": "Monday",
  "element": "Earth",
  "photoUrl": "",
  "favorites": []
}
```

#### `config/dayElementMapping`
```json
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

## Setup Instructions

### 1. Firebase Configuration

Ensure your Firebase project has:
- Authentication enabled (email/password)
- Firestore Database enabled
- Proper security rules for `users` and `config` collections

### 2. Seed Firestore Data

**Option A: Use Debug Button**
1. Run the app and log in
2. Tap the bug icon (🐛) in the dashboard app bar
3. Check console for success message

**Option B: Manual Firestore Console**
1. Go to Firebase Console > Firestore Database
2. Create collection `config`
3. Create document `dayElementMapping`
4. Add the mapping data as shown above

### 3. Security Rules

Add these Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read config (for element mapping)
    match /config/{document} {
      allow read: if request.auth != null;
    }
  }
}
```

## App Flow

### First Login Flow
1. User signs up/logs in successfully
2. `ProfileCompletionWrapper` checks if profile is complete
3. If incomplete → shows blocking `CollectDobDialog`
4. User enters name and selects DOB
5. App fetches day-element mapping from Firestore
6. Calculates day of week from DOB (local timezone)
7. Maps day to element using Firestore config
8. Saves complete profile to `users/{uid}`
9. Dismisses dialog and shows dashboard

### Subsequent Logins
1. User logs in
2. `ProfileCompletionWrapper` checks profile completeness
3. If complete → directly shows dashboard
4. Dashboard loads and displays user's element information

## Key Features

### Profile Completion Dialog
- **Blocking**: Cannot be dismissed until profile is complete
- **Validation**: Requires non-empty name and valid DOB
- **Date Picker**: User-friendly date selection
- **Error Handling**: Shows SnackBar messages for failures
- **Loading States**: Visual feedback during save operations

### Element Mapping
- **Dynamic**: Loads from Firestore, not hardcoded
- **Local Calculation**: Uses device timezone for day-of-week
- **Fallback**: Handles missing mapping gracefully
- **Extensible**: Easy to modify mapping without app updates

### Dashboard Integration
- **Profile Display**: Shows user's element with appropriate icon/color
- **Loading States**: Handles async profile loading
- **Error Handling**: Graceful fallback for missing data
- **Debug Tools**: Built-in Firestore seeding capability

## Element Icons & Colors

| Element | Icon | Color |
|---------|------|-------|
| Fire | 🔥 | Orange |
| Water | 💧 | Blue |
| Earth | 🌍 | Brown |
| Wind | 💨 | Green |

## Error Handling

### Network Errors
- SnackBar notifications for fetch/write failures
- Graceful fallback to safe states
- Retry mechanisms in UI

### Missing Data
- Handles missing Firestore mapping document
- Validates profile completeness before proceeding
- User-friendly error messages

### Validation
- Name must be at least 2 characters
- DOB cannot be in the future
- Required fields validation before save

## Testing

### Manual Testing Checklist
- [ ] First login shows profile completion dialog
- [ ] Dialog cannot be dismissed without completing profile
- [ ] Name validation works (empty, too short)
- [ ] Date picker works and validates future dates
- [ ] Element mapping loads from Firestore
- [ ] Profile saves successfully to Firestore
- [ ] Dashboard shows correct element information
- [ ] Subsequent logins skip profile dialog
- [ ] Debug button seeds Firestore data
- [ ] Error handling works for network issues

### Edge Cases Tested
- [ ] Missing Firestore mapping document
- [ ] Network connectivity issues
- [ ] Invalid date selections
- [ ] Empty or invalid names
- [ ] App restart after partial completion

## Next Steps (Step 3)

The dashboard currently shows element information as text. Step 3 will:
1. Add Firebase Storage for element posters
2. Display visual element posters instead of text
3. Implement poster selection and favorites
4. Add poster upload/management functionality

## Debug Tools

### Firestore Seeder
The `FirestoreSeeder` utility provides:
- `seedDayElementMapping()` - Creates initial mapping
- `isDayElementMappingExists()` - Checks if mapping exists
- `getDayElementMapping()` - Retrieves current mapping
- `deleteDayElementMapping()` - Removes mapping (testing)

### Debug Button
Located in dashboard app bar (bug icon), allows:
- One-click Firestore data seeding
- Success/error feedback via SnackBar
- Development and testing convenience

## Code Organization

```
lib/
├── models/
│   └── user_profile.dart          # User profile data model
├── services/
│   ├── user_service.dart          # User profile operations
│   └── element_mapping_service.dart # Element mapping logic
├── widgets/
│   └── collect_dob_dialog.dart    # Profile completion modal
├── utils/
│   └── firestore_seeder.dart      # Firestore seeding utility
├── main.dart                      # Updated with profile flow
└── screens/
    └── dashboard.dart             # Updated with element display
```

## Performance Considerations

- Profile completeness check on every auth state change
- Firestore mapping cached during dialog session
- Efficient profile loading with error handling
- Minimal network calls with proper state management

## Security Notes

- User profiles are user-specific (uid-based access)
- Config data is read-only for authenticated users
- Input validation on both client and server
- Proper error handling prevents data leakage

## Troubleshooting

### Common Issues

1. **"Day element mapping document not found"**
   - Use debug button to seed data
   - Check Firestore console for config collection

2. **Profile dialog not showing**
   - Check if user is authenticated
   - Verify profile completeness logic
   - Check console for errors

3. **Element not displaying**
   - Verify profile was saved correctly
   - Check Firestore for user document
   - Ensure mapping document exists

4. **Network errors**
   - Check Firebase configuration
   - Verify internet connectivity
   - Check Firestore security rules

### Debug Steps

1. Check Firebase Console for data
2. Use debug button to seed mapping
3. Verify user authentication state
4. Check console logs for errors
5. Test with different DOB values
6. Verify timezone calculations

## Future Enhancements

- [ ] Profile editing functionality
- [ ] Multiple element support
- [ ] Element compatibility features
- [ ] Profile sharing capabilities
- [ ] Advanced validation rules
- [ ] Offline support
- [ ] Profile backup/restore
