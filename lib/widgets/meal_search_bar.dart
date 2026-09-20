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
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear();
  }

  void _submit(String value) {
    final trimmedValue = value.trim();
    _controller.text = trimmedValue;
    widget.onSubmitted(trimmedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Limpar busca',
                  onPressed: _clear,
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _submit(_controller.text),
                  child: const Text('Buscar'),
                ),
              ),
            ],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onSubmitted: _submit,
      ),
    );
  }
}
