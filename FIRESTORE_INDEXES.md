# Firestore Composite Indexes Required

This document lists all the composite indexes required for the Oonjai app's Firestore queries.

## Foods Collection

**No composite indexes required** - The nested layout uses simple path-based queries:
- `foods/{element}/{category}` - no filters needed
- `foods/{element}/{category}` with `orderBy('name')` - uses default index

## Therapy Collection

### Index A: elements + title
- **Collection**: `therapy`
- **Fields**:
  - `elements` (Array)
  - `title` (Ascending)
- **Used by**: `TherapyService.getTherapiesByElement()`, `TherapyService.searchTherapies()`

## Medicines Collection

### Index A: elements + name
- **Collection**: `medicines`
- **Fields**:
  - `elements` (Array)
  - `name` (Ascending)
- **Used by**: `MedicinesService.getMedicinesByElement()`, `MedicinesService.searchMedicines()`

## How to Create Indexes

1. Go to Firebase Console
2. Navigate to Firestore Database
3. Click on the "Indexes" tab
4. Click "Create Index"
5. Select the collection and add the fields in the specified order
6. Set the field types correctly (Array for `elements`, Ascending for others)
7. Click "Create"

## Firestore Schema Reference

### Foods Collection (Nested Layout)
```
foods (collection)
  Fire   (document)
    great       (collection)
      {foodId}  { name, imageKey }
    avoid       (collection)
      {foodId}  { name, imageKey }
    suggestion  (collection)
      {foodId}  { name, imageKey }
  Water (document) { great/avoid/suggestion as above }
  Wind  (document) { great/avoid/suggestion as above }
  Earth (document) { great/avoid/suggestion as above }
```

### Therapy Collection
```json
{
  "title": "Hot Stone Therapy",
  "thumbnailKey": "therapy_hot_stone_thumb",
  "detailPosterKey": "therapy_hot_stone_poster",
  "description": "A therapeutic treatment...",
  "elements": ["Fire", "Earth"],
  "medicines": ["medicine_ginger_tea", "medicine_cinnamon_powder"]
}
```

### Medicines Collection
```json
{
  "name": "Ginger Tea",
  "imageKey": "medicine_ginger_tea",
  "elements": ["Fire", "Wind"]
}
```

## Notes

- All `imageKey` fields are resolved to local assets via `AssetMapper.getAssetPath()`
- The `elements` field is always an array containing one or more element values
- Simple queries (by document ID, single field orderBy) don't require composite indexes
- Search functionality uses simple prefix matching since Firestore doesn't support full-text search natively
- Foods collection uses nested layout where element and category are derived from the path, not stored in documents
