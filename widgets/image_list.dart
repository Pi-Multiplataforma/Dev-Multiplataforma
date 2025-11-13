import 'package:flutter/material.dart';
import '../src/models/image_model.dart';

class ImageList extends StatelessWidget {
  final List<ImageModel> images;
  const ImageList(this.images, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (_, i) {
        final img = images[i];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(img.url),
              ),
              const SizedBox(height: 8),
              Text(img.alt.isEmpty ? '(sem descrição)' : img.alt,
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
