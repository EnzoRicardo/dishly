import 'package:flutter/material.dart';

class MealSearchBar extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final String hintText;

  const MealSearchBar({
    super.key,
    required this.onSubmitted,
    required this.onClear,
    this.hintText = 'Buscar prato...',
  });

  @override
  State<MealSearchBar> createState() => _MealSearchBarState();
}

class _MealSearchBarState extends State<MealSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clear,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onSubmitted: (value) {
          final trimmedValue = value.trim();
          _controller.text = trimmedValue;
          widget.onSubmitted(trimmedValue);
        }
      ),
    );
  }
}
