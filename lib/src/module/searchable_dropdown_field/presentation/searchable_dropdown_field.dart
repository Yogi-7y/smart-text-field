import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../../smart_textfield.dart';
import 'state/query_notifier.dart';
import 'state/search_results_notifier.dart';

typedef SearchSources = List<SearchSource>;
typedef TextFormFieldBuilder = TextFormField Function(
  BuildContext context,
  TextEditingController controller,
);

@immutable
class SearchableDropdownField extends StatefulWidget {
  const SearchableDropdownField({
    required this.sources,
    required this.controller,
    required this.textFormFieldBuilder,
    super.key,
  });

  final SearchSources sources;
  final TextEditingController controller;
  final TextFormFieldBuilder textFormFieldBuilder;

  @override
  State<SearchableDropdownField> createState() => _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
  final _textFormFieldKey = GlobalKey(debugLabel: 'SearchableDropdownField');
  var _textFormFieldWidth = 0.0;

  late final _queryNotifier = QueryNotifier();
  late final _searchResultsNotifier = SearchResultsNotifier(
    sources: widget.sources,
  );

  @override
  void initState() {
    super.initState();

    final _textFormFieldController =
        widget.textFormFieldBuilder(context, widget.controller).controller;

    assert(
      _textFormFieldController == widget.controller,
      'TextFormField must use the same controller as passed into the SearchableDropdownField.',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTextFormFieldWidth();
      _syncTextControllerAndQueryNotifier();
      _syncQueryAndSearchResults();
    });
  }

  @override
  void dispose() {
    _queryNotifier.dispose();
    _searchResultsNotifier.dispose();
    super.dispose();
  }

  void _getTextFormFieldWidth() {
    final _renderBox = _textFormFieldKey.currentContext?.findRenderObject();
    if (_renderBox == null) return;
    _textFormFieldWidth = _renderBox.paintBounds.size.width;
    setState(() {});
  }

  void _syncTextControllerAndQueryNotifier() => widget.controller.addListener(
        () => _queryNotifier.updateQuery = widget.controller.text,
      );

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
      child: SizedBox(
        key: _textFormFieldKey,
        child: widget.textFormFieldBuilder(context, widget.controller),
      ),
    );
  }
}
