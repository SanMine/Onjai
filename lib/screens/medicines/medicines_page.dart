import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/medicine.dart';
import '../../services/medicines_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/asset_mapper.dart';

class MedicinesPage extends StatelessWidget {
  const MedicinesPage({super.key});

  static const List<String> categories = [
    'Skin','Respiratory System','Fever','Muscles and Bones','Urinary tract','Digestive system','Cardiovascular system','OB-GYN'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryCard(
                    label: category,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MedicineListPage(category: category),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CategoryCard({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralText,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineListPage extends StatelessWidget {
  final String category;
  const MedicineListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: SafeArea(
        child: _MedicineList(category: category),
      ),
    );
  }
}

class _MedicineList extends StatefulWidget {
  final String category;
  const _MedicineList({required this.category});

  @override
  State<_MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<_MedicineList> {
  final _service = MedicinesService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Medicine>>(
      stream: _service.getByCategory(widget.category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final medicines = snapshot.data ?? [];
        if (medicines.isEmpty) {
          return Center(
            child: Text(
              'No medicines in ${widget.category}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return StreamBuilder<Set<String>>(
          stream: _auth.currentUser == null
              ? const Stream.empty()
              : _service.streamFavoritePaths(_auth.currentUser!.uid),
          builder: (context, favSnap) {
            final favorites = favSnap.data ?? <String>{};
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];
                final isFav = favorites.contains(med.path);
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 56,
                      height: 56,
                      color: AppTheme.surfaceVariant,
                      child: med.imageKey.isNotEmpty
                          ? Image.asset(
                              AssetMapper.getAssetPath(med.imageKey),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.medical_services,
                                color: AppTheme.mintHighlight,
                              ),
                            )
                          : Icon(
                              Icons.medical_services,
                              color: AppTheme.mintHighlight,
                            ),
                    ),
                  ),
                  title: Text(
                    med.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppTheme.neutralText),
                    onPressed: _auth.currentUser == null
                        ? null
                        : () => _service.toggleFavoritePath(_auth.currentUser!.uid, med.path),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
