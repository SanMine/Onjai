# Therapy Steps Firestore Structure Example

This document shows how to structure Firestore data for the new steps-based therapy system.

## Firestore Schema

### Collection: `therapy`
### Document: `Leg` (Body Part)

```json
{
  "steps": [
    {
      "imageKey": "leg_stretch_1",
      "text": "Start by sitting on the floor with your legs extended straight in front of you. Keep your back straight and shoulders relaxed.",
      "title": "Step 1: Seated Position",
      "durationSec": 30,
      "warning": "If you feel any sharp pain, stop immediately and consult a healthcare provider."
    },
    {
      "imageKey": "leg_stretch_2", 
      "text": "Slowly bend forward from your hips, reaching toward your toes. Hold this position for 30 seconds while breathing deeply.",
      "title": "Step 2: Forward Bend",
      "durationSec": 30
    },
    {
      "imageKey": "leg_massage_1",
      "text": "Using your hands, gently massage your calf muscles in circular motions. Start from the ankle and work your way up to the knee.",
      "title": "Step 3: Calf Massage",
      "durationSec": 60
    }
  ],
  "imageKey": "leg1",
  "description": "Complete leg therapy routine for improved flexibility and circulation",
  "medicineRefs": ["medicines/Skin/medicine/AloeVera", "medicines/General/medicine/Turmeric"]
}
```

### Document: `Arm` (Body Part)

```json
{
  "steps": [
    {
      "imageKey": "arm_exercise_1",
      "text": "Stand with your feet shoulder-width apart. Extend your arms straight out to the sides at shoulder level.",
      "title": "Step 1: Arm Extension",
      "durationSec": 20
    },
    {
      "imageKey": "arm_exercise_2",
      "text": "Slowly rotate your arms in small circles, first clockwise for 10 rotations, then counterclockwise for 10 rotations.",
      "title": "Step 2: Arm Circles", 
      "durationSec": 40
    }
  ],
  "imageKey": "therapy_arm_poster",
  "description": "Arm mobility and strength exercises for daily wellness",
  "medicineRefs": []
}
```

### Document: `Shoulder` (Body Part)

```json
{
  "steps": [
    {
      "imageKey": "shoulder_stretch_1",
      "text": "Stand or sit with your back straight. Bring your right arm across your chest and hold it with your left hand.",
      "title": "Step 1: Cross-Body Stretch",
      "durationSec": 30,
      "warning": "Avoid this stretch if you have recent shoulder surgery or injury."
    },
    {
      "imageKey": "shoulder_stretch_2",
      "text": "Hold the stretch for 30 seconds, then switch arms. Repeat 3 times on each side.",
      "title": "Step 2: Hold and Switch",
      "durationSec": 60
    }
  ],
  "imageKey": "therapy_shoulder_poster",
  "description": "Shoulder flexibility and tension relief exercises",
  "medicineRefs": ["medicines/Muscles and Bones/medicine/Herbal_compress"]
}
```

## Field Descriptions

### Steps Array Fields

- **`imageKey`** (required): String key that maps to an image in AssetMapper
- **`text`** (required): Description of what to do in this step
- **`title`** (optional): Short title for the step
- **`durationSec`** (optional): How long to perform this step in seconds
- **`warning`** (optional): Safety warning or precaution for this step
- **`videoKey`** (optional): Future use for video content

### Fallback Fields (for backward compatibility)

- **`imageKey`**: Single image for the entire therapy (used when no steps)
- **`description`**: Single description for the entire therapy (used when no steps)
- **`medicineRefs`**: Array of medicine document paths (optional)

## Backward Compatibility

If a therapy document doesn't have a `steps` array or has an empty `steps` array, the UI will automatically fall back to displaying the single `imageKey` and `description` fields.

## Asset Requirements

Make sure all `imageKey` values used in the `steps` array exist in your `AssetMapper` class and correspond to actual image files in the `assets/images/therapy/` directory.

## Example Usage in Flutter

The TherapyTab will automatically detect if `steps` exist and render either:
1. **Steps Mode**: Horizontal PageView slider with dot indicators
2. **Fallback Mode**: Single image + description (existing behavior)

No code changes are needed in the UI - it automatically adapts based on the data structure.


