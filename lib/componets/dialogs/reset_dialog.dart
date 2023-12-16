import 'package:flutter/material.dart';
import 'package:kids_app/styles/color_style.dart';

void resetDialog(BuildContext context, void Function()? onPressed) =>
    showDialog(
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
                      Navigator.pop(context);
                    },
                    child: const Text("Όχι")),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: onPressed,
                    //  () {
                    //   resetTimer();
                    //   Navigator.pop(context);
                    // },
                    child: const Text(
                      "Ναι",
                    )),
              ],
            ));
