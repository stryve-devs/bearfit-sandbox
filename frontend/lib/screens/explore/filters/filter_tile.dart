import 'package:flutter/material.dart';

class FilterTile extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(List<String>) onSelectionChanged;

  const FilterTile({
    super.key,
    required this.title,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  State<FilterTile> createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  late List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.options
              .map(
                (option) => FilterChip(
                  label: Text(option),
                  selected: selectedOptions.contains(option),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                    widget.onSelectionChanged(selectedOptions);
                  },
                  backgroundColor: const Color(0xFF1C1C1E),
                  selectedColor: Colors.orange,
                  labelStyle: TextStyle(
                    color: selectedOptions.contains(option)
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
