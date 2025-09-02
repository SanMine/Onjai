## Debug Steps for leg1 Image Issue

### **IMMEDIATE TESTING STEPS:**

1. **Run the app** and go to Traveling → Therapy tab
2. **Tap "Legs" button** - this should trigger our debug logging
3. **Check the console output** for these debug messages:
   ```
   DEBUG: Selected body part: Leg
   DEBUG AssetMapper: Looking up key: "leg1"
   DEBUG AssetMapper: Found mapping for "leg1" -> "assets/images/therapy/leg1.jpg"
   DEBUG: Therapy data for Leg: id=Leg, imageKey=leg1, description length=X
   DEBUG: Asset path will be: assets/images/therapy/leg1.jpg
   ```

### **EXPECTED BEHAVIOR:**
- If the image loads: You should see the leg1.jpg image
- If the image fails: You should see a broken image icon with error details

### **WHAT TO LOOK FOR:**

#### Scenario A: Image Key Issue
If you see in console:
```
DEBUG AssetMapper: No mapping found for "leg1"
```
**Problem**: The imageKey in Firestore might not be exactly "leg1"
**Solution**: Check Firestore document for exact imageKey value

#### Scenario B: Asset Path Issue  
If you see:
```
DEBUG: Image loading error for leg1
DEBUG: Asset path attempted: assets/images/therapy/leg1.jpg
```
**Problem**: Asset file might be corrupted or not properly bundled
**Solution**: Replace the leg1.jpg file

#### Scenario C: Firestore Data Issue
If you see:
```
No therapy found for this body part
```
**Problem**: Firestore document missing or incorrectly named
**Solution**: Verify document ID is exactly "Leg" (capital L)

### **QUICK FIXES TO TRY:**

1. **Hot Restart**: Press ⚡ (hot reload) then 🔄 (hot restart)
2. **Clean Build**: 
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. **Replace Image**: Copy arm1.jpg to leg1.jpg:
   ```bash
   cp assets/images/therapy/arm1.jpg assets/images/therapy/leg1.jpg
   ```

### **FIRESTORE VERIFICATION:**

Your Firestore document should look EXACTLY like this:
```
Collection: therapy
Document ID: Leg
Fields:
  imageKey: "leg1" (string)
  description: "Your description text" (string)
```

**Common Issues:**
- Document ID is "leg" instead of "Leg" 
- imageKey is "leg_1" or "Leg1" instead of "leg1"
- Extra spaces in imageKey value
