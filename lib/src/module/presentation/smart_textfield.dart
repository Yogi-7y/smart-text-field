import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'smart_text_field_controller.dart';

typedef SuggestionItemBuilder = Widget Function(BuildContext context, String suggestion);

/// Pass in the [TextFormField] over which the suggestions will be shown.
typedef TextFormFieldBuilder = TextFormField Function(
  BuildContext context,
  SmartTextFieldController controller,
);

class SmartTextField extends StatefulWidget {
  const SmartTextField({
    required this.controller,
    required this.textFormFieldBuilder,
    this.suggestionItemBuilder,
    super.key,
  });

  final SmartTextFieldController controller;

  /// UI to display the suggestion items.
  final SuggestionItemBuilder? suggestionItemBuilder;

  /// Pass in the [TextFormField] over which the suggestions will be shown.
  final TextFormFieldBuilder textFormFieldBuilder;

  @override
  State<SmartTextField> createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  // late final _globalKey = GlobalKey<FormState>();

  String query = '';
  int currentModifier = -1;

  @override
  void initState() {
    super.initState();
    final _textFormFieldController =
        widget.textFormFieldBuilder(context, widget.controller).controller;

    assert(
      _textFormFieldController == widget.controller,
      'TextFormField must use the same controller as passed into the SmartTextField.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: widget.controller.suggestions,
      child: widget.textFormFieldBuilder(context, widget.controller),
      builder: (context, suggestions, child) => PortalTarget(
        visible: suggestions.isNotEmpty,
        anchor: const Aligned(
          follower: Alignment.bottomRight,
          target: Alignment.topRight,
        ),
        portalFollower: Material(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _width * .8,
              maxHeight: 200,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  suggestions.length,
                  (index) {
                    final _suggestion = suggestions[index];

                    return GestureDetector(
                      onTap: () {
                        final _cursorPosition = widget.controller.selection.base.offset;

                        final _textBeforeCursor =
                            widget.controller.text.substring(0, _cursorPosition);

                        final _textAfterCursor = widget.controller.text.substring(_cursorPosition);

                        final _prefixIndex = _textBeforeCursor.lastIndexOf(_suggestion.prefix);

                        final _value = '${_suggestion.prefix}${_suggestion.stringValue} ';

                        final _newText =
                            '${_textBeforeCursor.substring(0, _prefixIndex)}$_value$_textAfterCursor';

                        widget.controller.text = _newText;
                      },
                      child: widget.suggestionItemBuilder == null
                          ? ListTile(
                              title: Text(_suggestion.stringValue),
                            )
                          : widget.suggestionItemBuilder!(
                              context,
                              _suggestion.stringValue,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        child: child!,
      ),
    );
  }
}

@immutable
class SmartTextFieldOverlay extends StatelessWidget {
  const SmartTextFieldOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Portal(child: child);
}
