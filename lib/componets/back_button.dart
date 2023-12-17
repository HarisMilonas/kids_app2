import 'package:flutter/material.dart';

class CustomBack extends StatefulWidget {
  final void Function()? onTap;

  const CustomBack({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBack> createState() => _CustomBackState();
}

class _CustomBackState extends State<CustomBack> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          color: Colors.transparent,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Image.asset(
              "images/back-arrow.gif",
              height: 25,
              width: 35,
            ),
          ),
        ),
      ],
    );
  }
}
