import 'package:flutter/material.dart';

class MetricsData extends StatelessWidget {
  final String label;
  final String value;
  final Function()? onTap;
  final Color textColor;
  final Color? backgroundColor;

  const MetricsData({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.textColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(left: 8), child: Text(label)),
          DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor?.withAlpha(35) ?? textColor.withAlpha(35),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: backgroundColor ?? Colors.transparent),
            ),
            child: Container(
              constraints: BoxConstraints(minWidth: 100),
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: SelectableText(
                  value,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  onTap: onTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
