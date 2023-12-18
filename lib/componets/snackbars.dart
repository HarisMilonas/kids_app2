import 'package:flutter/material.dart';

class CustomSnackBar {
  static successMessage(
      BuildContext context, String message, void Function()? onTap) {
    ScaffoldMessenger.of(context).clearSnackBars();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Image(
                  width: 70,
                  height: 70,
                  image: AssetImage('images/banana-pony.gif'))
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 236, 176, 254),
        elevation: 3,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static errorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    FocusManager.instance.primaryFocus?.unfocus();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        content: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 179, 89, 88),
        elevation: 3,
        duration: const Duration(seconds: 15),
      ),
    );
  }
}
