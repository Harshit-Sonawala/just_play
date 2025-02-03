import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  // Catching the TextEditingController and FocusNode
  final TextEditingController searchTextFieldController;
  final FocusNode searchTextFieldFocusNode;

  const SearchScreen({
    super.key,
    required this.searchTextFieldController,
    required this.searchTextFieldFocusNode,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => {
                      Navigator.of(context).pop(),
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Search Results',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Hero(
                  tag: 'search_hero',
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: widget.searchTextFieldController,
                      focusNode: widget.searchTextFieldFocusNode,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Enter search query...',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 24,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
