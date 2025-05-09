import 'package:flutter/material.dart';

class SearchModal extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onSearch;
  final List<String>? suggestions;

  const SearchModal(
      {super.key,
      this.hintText = 'What transport do you want?',
      this.onSearch,
      this.suggestions});

  static Future<void> show(
      {required BuildContext context,
      String? hintText,
      ValueChanged<String>? onSearch,
      List<String>? suggestions}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchModal(
        hintText: hintText ?? 'Search...',
        onSearch: onSearch,
        suggestions: suggestions,
      ),
    );
  }

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  late TextEditingController _controller;
  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _results = widget.suggestions ?? [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _results = widget.suggestions
              ?.where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList() ??
          [];
    });
    widget.onSearch?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildSearchField(),
          Expanded(child: _buildResultList())
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 60,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
        child: TextField(
          autofocus: true,
          controller: _controller,
          onChanged: _handleSearch,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              prefixIcon: Icon(
                Icons.search,
              ),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _controller.clear();
                        _handleSearch('');
                      },
                      icon: Icon(Icons.clear))),
        ),
      ),
    );
  }

  Widget _buildResultList() {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(_results[index]),
        onTap: () {
          Navigator.pop(context);
          _controller.text = _results[index];
        },
      ),
    );
  }
}
