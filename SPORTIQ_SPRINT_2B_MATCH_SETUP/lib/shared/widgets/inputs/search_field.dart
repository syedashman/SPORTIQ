// Reusable search input used across dashboard/teams/tournaments search.
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
