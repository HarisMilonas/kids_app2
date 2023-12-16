import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kids_app/componets/dialogs/complete_dialog.dart';
import 'package:kids_app/componets/dialogs/loading_dialog.dart';
import 'package:kids_app/componets/dialogs/reset_dialog.dart';
import 'package:kids_app/componets/page_router.dart';
import 'package:kids_app/controllers/calendar_controller.dart';
import 'package:kids_app/screens/calendar_page.dart';
import 'package:kids_app/styles/text_styles.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isRunning = false;
  int seconds = 0;
  late Duration timerDuration;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '00:00:00');
    timerDuration = const Duration(seconds: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startPauseTimer() {
    setState(() {
      isRunning = !isRunning;
      if (isRunning) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void resetTimer() {
    setState(() {
      _stopTimer();
      seconds = 0;
      _controller.text = '00:00:00'; // Set to initial value
    });
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      } else {
        setState(() {
          seconds++;
          _controller.text = formatDuration(Duration(seconds: seconds));
        });
      }
    });
  }

  void _stopTimer() {
    isRunning = false;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              hour > 12
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Image.asset(
                            isRunning
                                ? "images/test.gif"
                                : "images/sleeping-pony-still.png",
                            height: 180,
                            width: 180,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isRunning
                            ? const SizedBox(height: 0)
                            : const SizedBox(
                                height: 30,
                              ),
                        Center(
                          child: Image.asset(
                            isRunning
                                ? "images/bouncing-pony.gif"
                                : "images/bouncing-pony-still.png",
                            height: isRunning ? 150.0 : 120,
                            width: isRunning ? 150.0 : 120,
                          ),
                        ),
                      ],
                    ),
              Container(
                height: MediaQuery.of(context).size.height * 0.60,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.white,
                    gradient: const LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.cyanAccent])),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 40),
                      isRunning
                          ? ElevatedButton(
                              onPressed: () {
                                completeDialog(context, _saveTime);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // Adjust the radius as needed
                                ),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.deepPurpleAccent,
                                size: 50,
                              ),
                            )
                          : const SizedBox(height: 50),

                      // TextButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (_) => const DatabaseList()));
                      //     },
                      //     child: const Text("See db")),

                      //timer
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            _controller.text,
                            style: timerStyle(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  resetDialog(context, () {
                                    resetTimer();
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Icon(
                                  Icons.restart_alt,
                                  size: 45,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: startPauseTimer,
                                  child: Icon(
                                    isRunning
                                        ? Icons.pause_circle
                                        : Icons.not_started,
                                    size: 45,
                                  )),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      //flutter_staggered_animations 1.1.1
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              CustomPageRouter.fadeThroughPageRoute(
                                  const CalendarPage()));
                        },
                        child: Image.asset(
                          "images/calendar.gif",
                          height: 130.0,
                          width: 130.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTime() async {
    loadingDialog(context);
    int elapsedMinutes = (seconds / 60).floor();
    await CalendarController.createOrUpdateDay(elapsedMinutes);
    resetTimer();
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
