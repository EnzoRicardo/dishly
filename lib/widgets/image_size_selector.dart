import 'package:flutter/material.dart';

import '../models/meal.dart';

/// Controla a densidade da grade e, junto com ela, a resolução do thumbnail
/// que cada card baixa — ver [Meal.getImage].
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: SegmentedButton<ImageSize>(
          segments: [
            for (final size in ImageSize.values)
              ButtonSegment(
                value: size,
                icon: Icon(size.icon),
                tooltip: size.label,
              ),
          ],
          selected: {selectedSize},
          onSelectionChanged: (selection) => onSelected(selection.first),
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            // Sem contorno: `side` desenha a moldura externa e as divisórias
            // entre segmentos, então zerar os dois deixa só o track sólido.
            side: BorderSide.none,
            backgroundColor: colorScheme.surfaceContainerHighest,
            foregroundColor: colorScheme.onSurfaceVariant,
            selectedBackgroundColor: colorScheme.primary,
            selectedForegroundColor: colorScheme.onPrimary,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ),
    );
  }
}
