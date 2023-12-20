import 'package:flutter/material.dart';
import 'package:HappyTeeth/styles/color_style.dart';

Future<bool?> resetDialog(
    BuildContext context ) async {
  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Ουπς!",
              style: TextStyle(
                  color: customDialogPink(), fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Αν πατησεις 'Ναι' θα μηδενίσεις το χρονόμετρο.\nΣυνέχεια;",
                  style: TextStyle(
                      fontSize: 18,
                      color: customDialogPink(),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Όχι")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed:   () {
                    Navigator.of(context).pop(true);
                  },
                 
                  child: const Text(
                    "Ναι",
                  )),
            ],
          ));
}
