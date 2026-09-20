import 'package:flutter/material.dart';

enum CollectionType {
  cooked(
    title: 'Pratos Cozinhados',
    icon: Icons.restaurant_outlined,
    selectedIcon: Icons.restaurant,
    activeColor: Colors.green,
    activeTooltip: 'Remover dos feitos',
    inactiveTooltip: 'Marcar como feitos',
    searchHint: 'Buscar nos cozinhados...',
    emptyMessage: 'Nenhum prato cozinhado ainda.',
  ),
  favorites(
    title: 'Meus Favoritos',
    icon: Icons.favorite_outline,
    selectedIcon: Icons.favorite,
    activeColor: Colors.amber,
    activeTooltip: 'Remover dos favoritos',
    inactiveTooltip: 'Adicionar aos favoritos',
    searchHint: 'Buscar nos favoritos...',
    emptyMessage: 'Nenhum prato favorito ainda.',
  );

  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final Color activeColor;
  final String activeTooltip;
  final String inactiveTooltip;
  final String searchHint;
  final String emptyMessage;

  const CollectionType({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.activeColor,
    required this.activeTooltip,
    required this.inactiveTooltip,
    required this.searchHint,
    required this.emptyMessage,
  });
}
