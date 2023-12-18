 import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:HappyTeeth/styles/color_style.dart';

Future<bool?> isSureDialog(BuildContext context, GifController controller ) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ωχ!',
                  style: TextStyle(
                      color: customDialogPink(), fontWeight: FontWeight.bold)),
               Gif(
                width: 80,
                height: 80,
                  controller: controller,
                  autostart: Autostart.once,
                  placeholder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  image: const AssetImage('images/angry-pony.gif')
                ),
            ],
          ),
          content: Text(
            'Αν πας πίσω το χρονόμετρο θα μηδενιστεί.\nΟλοκλήρωσε πρώτα αν έβγαλες το μασελάκι σου και μετά κλείσε την εφαρμογή.\n',
            style: TextStyle(
                fontSize: 16,
                color: customDialogPink(),
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Θα φύγω'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              // widget.stopTimerCallback,
              child: const Text('θα παραμείνω'),
            ),
          ],
        );
      },
    );
    return confirm;
  }