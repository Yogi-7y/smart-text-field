import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

class SyncSearchExample extends StatefulWidget {
  const SyncSearchExample({super.key});

  @override
  State<SyncSearchExample> createState() => _SyncSearchExampleState();
}

class _SyncSearchExampleState extends State<SyncSearchExample> {
  late final _controller = TextEditingController();

  final _sources = <SearchSource>[
    SearchSource(
      provider: CountrySearchProvider(items: countries),
      renderer: CountrySearchRenderer(),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchableDropdownField(
      controller: _controller,
      sources: _sources,
      textFormFieldBuilder: (context, controller) => TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Search',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class CountrySearchRenderer extends SearchRenderer<Country> {
  @override
  Widget render(BuildContext context, Country item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.shortName} • ${item.code}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              item.gmtString,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      );
}

class CountrySearchProvider extends SyncSearchProvider<Country> {
  CountrySearchProvider({required super.items});

  @override
  bool query({required String text, required Country item}) {
    final searchLower = text.toLowerCase();
    return item.name.toLowerCase().contains(searchLower) ||
        item.code.toLowerCase().contains(searchLower) ||
        item.shortName.toLowerCase().contains(searchLower);
  }
}

class Country implements Searchable {
  const Country({
    required this.name,
    required this.code,
    required this.shortName,
    required this.gmtOffset,
  });
  final String name;
  final String code;
  final String shortName;
  final double gmtOffset;

  String get gmtString {
    final hours = gmtOffset.toInt();
    final minutes = ((gmtOffset - hours) * 60).toInt().abs();
    final sign = gmtOffset >= 0 ? '+' : '-';
    return 'GMT$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

final countries = [
  const Country(
    name: 'India',
    code: 'IN',
    shortName: 'IND',
    gmtOffset: 5.5,
  ),
  const Country(
    name: 'United States',
    code: 'US',
    shortName: 'USA',
    gmtOffset: -5,
  ),
  const Country(
    name: 'United Kingdom',
    code: 'GB',
    shortName: 'UK',
    gmtOffset: 0,
  ),
  const Country(
    name: 'Japan',
    code: 'JP',
    shortName: 'JPN',
    gmtOffset: 9,
  ),
];
