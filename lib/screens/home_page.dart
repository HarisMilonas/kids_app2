import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:HappyTeeth/componets/page_router.dart';
import 'package:HappyTeeth/screens/timer_page.dart';

import 'package:HappyTeeth/styles/text_styles.dart';

import 'package:intl/date_symbol_data_local.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FadeInLeft(
                child: const Image(
                  image: AssetImage('images/flying-tooth.gif'),
                  width: 75,
                  height: 75,
                ),
              ),
              Spin(
                child: const Image(
                  image: AssetImage('images/flying-tooth.gif'),
                  width: 75,
                  height: 75,
                ),
              ),
              FadeInRight(
                duration: const Duration(milliseconds: 1000),
                child: const Image(
                  image: AssetImage('images/flying-tooth.gif'),
                  width: 75,
                  height: 75,
                ),
              )
            ],
          ),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  from: 100,
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                          // "LaLizas ",
                          'Γεια σου και πάλι\n      Name!',
                          textStyle: headerStyles()),
                      TyperAnimatedText(
                          // "This is ",
                          'Ήρθε μήπως η ώρα\nνα φορέσουμε το\n  μασελάκι μας;',
                          textStyle: headerStyles()),
                      TyperAnimatedText(
                          // "Lets go",
                          'Φύγαμε!',
                          textStyle: headerStyles()),
                    ],
                    onFinished: () {
                      Navigator.of(context).push(
                          CustomPageRouter.fadeThroughPageRoute(
                              const TimerPage()));
                    },
                    onTap: () {
                      Navigator.of(context).push(
                          CustomPageRouter.fadeThroughPageRoute(
                              const TimerPage()));
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShakeY(
                from: 20,
                child: const Image(
                  image: AssetImage('images/flying-tooth.gif'),
                  width: 75,
                  height: 75,
                ),
              ),
              ShakeY(
                from: 20,
                child: const Image(
                  image: AssetImage('images/flying-tooth.gif'),
                  width: 75,
                  height: 75,
                ),
              ),
            ],
          ),
          const Expanded(
              child: Image(image: AssetImage("images/background2.png")))
        ],
      ),
    ));
  }
}
