import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../../smart_textfield.dart';
import 'state/query_notifier.dart';
import 'state/search_results_notifier.dart';

typedef SearchSources<T extends Searchable> = List<SearchSource<T>>;

class SearchableDropdownField<T extends Searchable> extends StatefulWidget {
  SearchableDropdownField({
    required this.sources,
    this.initialValue,
    SearchableDropdownFieldData? searchableDropdownFieldData,
    super.key,
  }) : data = searchableDropdownFieldData ?? SearchableDropdownFieldData();

  final SearchSources<T> sources;
  final T? initialValue;
  final SearchableDropdownFieldData data;

  @override
  State<SearchableDropdownField<T>> createState() => _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T extends Searchable>
    extends State<SearchableDropdownField<T>> {
  final _textFormFieldKey = GlobalKey(debugLabel: 'SearchableDropdownField');
  var _textFormFieldWidth = 0.0;

  late final _queryNotifier = QueryNotifier();
  late final _textController = TextEditingController();
  late final _foucsNode = FocusNode();

  late final _searchResultsNotifier = SearchResultsNotifier<T>(
    sources: widget.sources,
    textController: _textController,
    queryNotifier: _queryNotifier,
    focusNode: _foucsNode,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTextFormFieldWidth();
    });
  }

  @override
  void dispose() {
    _searchResultsNotifier.dispose();
    _textController.dispose();
    _foucsNode.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }

  void _getTextFormFieldWidth() {
    final _renderBox = _textFormFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (_renderBox == null) return;
    _textFormFieldWidth = _renderBox.paintBounds.size.width;

    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final _data = widget.data;

    return PortalTarget(
      visible: _searchResultsNotifier.isSuggestionsVisible,
      portalFollower: GestureDetector(
        behavior: _searchResultsNotifier.isSuggestionsVisible
            ? HitTestBehavior.opaque
            : HitTestBehavior.deferToChild,
        onTap: () => _searchResultsNotifier.updateSuggestionsVisibility = false,
      ),
      child: PortalTarget(
        visible: _searchResultsNotifier.isSuggestionsVisible,
        anchor: const Aligned(
          target: Alignment.bottomRight,
          follower: Alignment.topRight,
        ),
        portalFollower: ListenableBuilder(
          listenable: _searchResultsNotifier,
          builder: (context, child) => UnconstrainedBox(
            child: Container(
              padding: _data.padding,
              margin: _data.margin,
              decoration: _data.decoration,
              width: _textFormFieldWidth,
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _searchResultsNotifier.widgets
                      .map(
                        (item) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _searchResultsNotifier.selectValue(item.item),
                          child: item.builder(context, item.item),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        child: TextFormField(
          key: _textFormFieldKey,
          controller: _textController,
          readOnly: _searchResultsNotifier.selectedValue != null,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
