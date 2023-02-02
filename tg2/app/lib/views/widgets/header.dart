import 'package:flutter/material.dart';

// Widget used for headers and titles
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.headerText, this.headerAction, this.leading, required this.child});

  final String headerText;
  final Widget? headerAction;
  final Widget? leading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
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
                const SizedBox(height: 12),
                Divider(height: 0, thickness: 1, color: Theme.of(context).colorScheme.tertiary),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                headerAction ?? Container(),
                Divider(height: 0, thickness: 1, color: Theme.of(context).colorScheme.outline),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      child,
    ]);
  }
}
