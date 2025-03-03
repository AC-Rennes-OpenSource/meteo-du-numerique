import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({super.key, required this.value, required this.onChanged});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: widget.value ? Theme.of(context).colorScheme.primary : Colors.transparent,
          border: widget.value
              ? null
              : Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1.0,
                ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: widget.value
            ? Icon(
                Icons.check,
                size: 17.0,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : Container(),
      ),
    );
  }
}

class CustomCheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Icon leadingIcon;

  const CustomCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            leadingIcon,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
            ),
            CustomCheckbox(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}