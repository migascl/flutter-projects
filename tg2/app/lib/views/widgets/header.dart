import 'package:flutter/material.dart';
import 'package:tg2/main.dart';

// Widget used for headers and titles
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.headerText, this.leading, this.child});

  final String headerText;
  final Widget? leading;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  headerText,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6?.apply(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Divider(height: 24, thickness: 1, color: Theme.of(context).colorScheme.tertiary),
              ],
            ),
          ),
          Expanded(child: Divider(height: 24, thickness: 1, color: Theme.of(context).colorScheme.outline)),
        ],
      ),
      const SizedBox(height: 8),
      child ?? Container(),
    ]);
  }
}
