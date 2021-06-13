import 'package:flutter/material.dart';

class RotatedListWheel extends StatefulWidget {

  final List<Widget> children;
  final double itemExtent;
  final int initialItem;
  final Function(int)? onSelectedItemChanged;

  RotatedListWheel({
    required this.children,
    required this.itemExtent,
    this.initialItem = 0,
    this.onSelectedItemChanged
  });

  @override
  State<StatefulWidget> createState() => _RotatedListWheelState();

}

class _RotatedListWheelState extends State<RotatedListWheel> {

  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = FixedExtentScrollController(initialItem: widget.initialItem);
  }

  // ListWheelScrollView currently has bug of not
  // re-rendering when child count changes
  // https://github.com/flutter/flutter/issues/58144

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: ListWheelScrollView.useDelegate(
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.children.length,
          builder: (ctx, index) => rotateSingleChild(widget.children[index]),
        ),
        onSelectedItemChanged: widget.onSelectedItemChanged,
        itemExtent: widget.itemExtent,
        controller: controller,
        offAxisFraction: -0.5,
        physics: FixedExtentScrollPhysics(),
      ),
    );
  }

  Widget rotateSingleChild(Widget child) {
    return RotatedBox(
      quarterTurns: 1,
      child: child
    );
  }

}