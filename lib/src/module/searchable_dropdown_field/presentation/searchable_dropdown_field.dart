import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../../smart_textfield.dart';

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
    });
  }

  void _getTextFormFieldWidth() {
    final _renderBox = _textFormFieldKey.currentContext?.findRenderObject();
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
    return PortalTarget(
      anchor: const Aligned(
        follower: Alignment.bottomRight,
        target: Alignment.topRight,
      ),
      portalFollower: UnconstrainedBox(
        child: Container(
          width: _textFormFieldWidth,
          constraints: const BoxConstraints(
            maxHeight: 300,
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
