import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../../smart_textfield.dart';
import 'state/query_notifier.dart';
import 'state/search_results_notifier.dart';

typedef SearchSources = List<SearchSource>;

@immutable
class SearchableDropdownField<T extends Searchable> extends StatefulWidget {
  const SearchableDropdownField({
    required this.sources,
    this.initialValue,
    super.key,
  });

  final SearchSources sources;
  final T? initialValue;

  @override
  State<SearchableDropdownField> createState() => _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
  final _textFormFieldKey = GlobalKey(debugLabel: 'SearchableDropdownField');
  var _textFormFieldWidth = 0.0;

  late final _textController = TextEditingController();

  late final _queryNotifier = QueryNotifier();
  late final _searchResultsNotifier = SearchResultsNotifier(
    sources: widget.sources,
  );

  bool _isOverlayVisible = false;
  void _changeOverlayStatus(bool isVisible) {
    if (_isOverlayVisible == isVisible) return;
    setState(() => _isOverlayVisible = isVisible);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTextFormFieldWidth();
      _syncTextAndQuery();
      _syncQueryAndSearchResults();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _queryNotifier.dispose();
    _searchResultsNotifier.dispose();
    super.dispose();
  }

  void _getTextFormFieldWidth() {
    final _renderBox = _textFormFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (_renderBox == null) return;
    _textFormFieldWidth = _renderBox.paintBounds.size.width;

    setState(() {});
  }

  void _syncTextAndQuery() {
    _textController.addListener(() {
      _queryNotifier.value = _textController.text;
      if (!_isOverlayVisible) _changeOverlayStatus(true);
    });
  }

  void _syncQueryAndSearchResults() {
    _queryNotifier.addListener(
      () async {
        final _query = _queryNotifier.value;
        await _searchResultsNotifier.search(context, _query);
      },
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _isOverlayVisible,
      portalFollower: GestureDetector(
        behavior: _isOverlayVisible ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
        onTap: () => _changeOverlayStatus(false),
      ),
      child: PortalTarget(
        visible: _isOverlayVisible,
        anchor: const Aligned(
          follower: Alignment.bottomRight,
          target: Alignment.topRight,
        ),
        portalFollower: ListenableBuilder(
          listenable: _searchResultsNotifier,
          builder: (context, child) => UnconstrainedBox(
            child: Container(
              color: Colors.red,
              width: _textFormFieldWidth,
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _searchResultsNotifier.widgets,
                ),
              ),
            ),
          ),
        ),
        child: TextFormField(
          key: _textFormFieldKey,
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
