import 'package:ayur_scoliosis_management/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class PatientDocumentsTab extends StatelessWidget {
  const PatientDocumentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // A sample list of image paths. Replace with your actual data.
    final List<String> documentImages = [
      // Replace these with your actual image paths or URLs.
      Assets.images.xRay,
      Assets.images.xRay,
      Assets.images.xRay,
      Assets.images.xRay,
    ];

    return SliverGrid.builder(
      // We use NeverScrollableScrollPhysics because the parent is a SingleChildScrollView.
      // This makes the grid expand to its full height.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 0, // Horizontal space between items
        mainAxisSpacing: 16, // Vertical space between items
        childAspectRatio: 1.0, // Make items square
      ),
      itemCount: documentImages.length,
      itemBuilder: (context, index) {
        final imagePath = documentImages[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
