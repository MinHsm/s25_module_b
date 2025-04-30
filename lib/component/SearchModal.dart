import 'package:flutter/material.dart';

class SearchModal extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onSearch;
  final List<String>? suggestions;

  const SearchModal(
      {super.key, required this.hintText, this.onSearch, this.suggestions});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
