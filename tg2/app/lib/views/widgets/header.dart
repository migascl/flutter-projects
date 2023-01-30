import 'package:flutter/material.dart';

// Widget used for headers and titles
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.headerText, this.leading, required this.child});

  final String headerText;
  final Widget? leading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(headerText,
            style: Theme.of(context).textTheme.headline6?.apply(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Row(
          children: [
            Flexible(flex: 2, child: Divider(height: 24, thickness: 1, color: Theme.of(context).colorScheme.tertiary)),
            Flexible(flex: 1, child: Divider(height: 24, thickness: 0.5, color: Theme.of(context).colorScheme.outline)),
          ],
        ),
        child
      ],
    );
  }
}
