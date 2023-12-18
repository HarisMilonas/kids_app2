import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:HappyTeeth/componets/dialogs/sure_dialog.dart';

class PopAlert extends StatefulWidget {
  final Scaffold myLayout;
  // final VoidCallback stopTimerCallback;

  const PopAlert({
    Key? key,
    required this.myLayout,
    // required this.stopTimerCallback,
  }) : super(key: key);

  @override
  State<PopAlert> createState() => _PopAlertState();
}

class _PopAlertState extends State<PopAlert> with TickerProviderStateMixin {
  late final GifController controller;

  @override
  void initState() {
    controller = GifController(vsync: this);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop = await isSureDialog(context, controller);
          if (shouldPop ?? false) {
            navigator.pop();
          }
        },
        child: widget.myLayout);
  }
}
