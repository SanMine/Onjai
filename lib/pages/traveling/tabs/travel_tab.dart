import 'package:flutter/material.dart';

import '../../../models/element_content.dart';
import '../../../services/content_service.dart';
import '../../../utils/asset_mapper.dart';

class TravelTab extends StatelessWidget {
  final String userElement;

  const TravelTab({
    super.key,
    required this.userElement,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<ElementContent?>(
            future: ContentService().getElementContent(userElement),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final content = snapshot.data;
              if (content == null || content.travelPosterKey.isEmpty) {
                return const Center(
                  child: Text('No travel poster found for your element'),
                );
              }

              final posterPath = AssetMapper.getAssetPath(content.travelPosterKey);

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 7/10,
                    child: Image.asset(
                      posterPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
