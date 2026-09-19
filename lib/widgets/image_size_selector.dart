import 'package:flutter/material.dart';

import '../models/meal.dart';

class ImageSizeSelector extends StatelessWidget {
  final ImageSize selectedSize;
  final ValueChanged<ImageSize> onSelected;

  const ImageSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ImageSize>(
      icon: Icon(
        Icons.photo_size_select_actual_outlined,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      tooltip: 'Tamanho da Imagem',
      initialValue: selectedSize,
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(value: ImageSize.small, child: Text('Pequeno (150px)')),
        PopupMenuItem(value: ImageSize.medium, child: Text('Médio (240px)')),
        PopupMenuItem(value: ImageSize.large, child: Text('Grande (500px)')),
      ],
    );
  }
}
