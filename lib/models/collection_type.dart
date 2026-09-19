import 'package:flutter/material.dart';

enum CollectionType {
  cooked(
    icon: Icons.restaurant_outlined,
    selectedIcon: Icons.restaurant,
    activeColor: Colors.green,
    activeTooltip: 'Remover dos feitos',
    inactiveTooltip: 'Marcar como feitos',
  ),
  favorites(
    icon: Icons.favorite_outline,
    selectedIcon: Icons.favorite,
    activeColor: Colors.amber,
    activeTooltip: 'Remover dos favoritos',
    inactiveTooltip: 'Adicionar aos favoritos',
  );

  final IconData icon;
  final IconData selectedIcon;
  final Color activeColor;
  final String activeTooltip;
  final String inactiveTooltip;

  const CollectionType({
    required this.icon,
    required this.selectedIcon,
    required this.activeColor,
    required this.activeTooltip,
    required this.inactiveTooltip,
  });
}
