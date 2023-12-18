import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:HappyTeeth/componets/back_button.dart';
import 'package:HappyTeeth/componets/snackbars.dart';
import 'package:HappyTeeth/controllers/calendar_controller.dart';
import 'package:HappyTeeth/models/calendar.dart';
import 'package:HappyTeeth/styles/text_styles.dart';

class EditDayPage extends StatefulWidget {
  const EditDayPage({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  final Calendar selectedDay;

  @override
  State<EditDayPage> createState() => _EditDayPageState();
}

class _EditDayPageState extends State<EditDayPage> {
  bool readOnly = true;
  String duration = '';
  String date = '';
  Map<String, dynamic> hours = {};
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllersList = [];
  String dayTitle = '';

  @override
  void initState() {
    duration = widget.selectedDay.duration ?? '0';
    hours = widget.selectedDay.details ?? {};
    date = widget.selectedDay.date;
    dayTitle = DateFormat('yMMMMEEEEd').format(DateTime.parse(date));

    _addControllers();

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // to remove the cursor everytime the user taps outside a textField!
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: CustomBack(onTap: () => Navigator.pop(context)),
        body: Center(
          child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.orangeAccent,
                  gradient: const LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.cyanAccent])),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: Text(
                      dayTitle,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 252, 248, 253),
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    )),
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: columnRows(),
                        ),
                      ),
                    ),
                    sumbitButton()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  List<Widget> columnRows() {
    List<Widget> items = [];

    items.add(const SizedBox(height: 50));
    items.add(const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
            width: 70, height: 70, image: AssetImage('images/banana-pony.gif')),
        Image(
            width: 70, height: 70, image: AssetImage('images/banana-pony.gif'))
      ],
    ));

    items.add(const SizedBox(height: 15));

    items.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Σημερινές ώρες",
            style: TextStyle(
                color: Color.fromARGB(255, 252, 248, 253),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 60),
          InkWell(
            onTap: () => _addHours(),
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.deepPurpleAccent,
              ),
            ),
          )
        ],
      ),
    ));
    items.add(const SizedBox(height: 15));

    if (hours.isNotEmpty) {
      // List<String> keys = hours.keys.toList();

      // Iterate through the map, taking two maps at a time
      for (int i = 0; i < controllersList.length; i += 2) {
        TextEditingController controllerKeyStart = controllersList[i];
        TextEditingController? controllerKeyEnd =
            (i + 1 < controllersList.length) ? controllersList[i + 1] : null;

        var row = hoursRow(controllerKeyStart, controllerKeyEnd);

        items.add(row);
        items.add(const SizedBox(height: 15));
      }
    }
    double total = 0;
    if (duration != '0') {
      total = double.tryParse(duration)! / 60;
    }
    items.add(const SizedBox(height: 20));
    items.add(totalWidget(total));
    items.add(const SizedBox(height: 50));

    // items.add(sumbitButton());

    return items;
  }

  Center sumbitButton() {
    return Center(
      child: ElevatedButton(
          onPressed: updateDay,
          child: Text(
            "Save",
            style: editPageStyle(),
          )),
    );
  }

  void updateDay() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    Map<String, dynamic> newHours = {};
    int newDuration = 0;

    for (int i = 0; i < controllersList.length; i += 2) {
      DateTime startTime = DateFormat('HH:mm').parse(controllersList[i].text);
      DateTime endTime = DateFormat('HH:mm').parse(controllersList[i + 1].text);

      // newHours.isNotEmpty
      //     ?
      newHours.addAll({
        DateFormat('HH:mm').format(startTime): "start",
        DateFormat('HH:mm').format(endTime): "end"
      });
      // : newHours = {
      //     DateFormat('HH:mm').format(startTime): "start",
      //     DateFormat('HH:mm').format(endTime): "end"
      //   };

      // Calculate the duration using Duration constructor
      Duration twentyFourduration;
      if (endTime.isAfter(startTime)) {
        twentyFourduration = endTime.difference(startTime);
      } else {
        // If the end time is earlier than the start time (crossing midnight)
        twentyFourduration = Duration(
          hours: 24 - startTime.hour + endTime.hour,
          minutes: endTime.minute - startTime.minute,
        );
      }

      // Accumulate the durations in minutes
      newDuration += twentyFourduration.inMinutes;
    }

    widget.selectedDay.details = newHours;
    widget.selectedDay.duration = newDuration.toString();

    await CalendarController.updateDay(widget.selectedDay);
    setState(() {
      hours = newHours;
      duration = newDuration.toString();
    });

    String message = "Μπράβο!\nΟι νέες ώρες προστέθηκαν με επιτυχια!";
    if (mounted) {
      CustomSnackBar.successMessage(context, message, () {});
    }
  }

  Column totalWidget(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          // "Total Hours Today",
          "Σύνολο",

          style: TextStyle(
              color: Color.fromARGB(255, 252, 248, 253),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  total.toStringAsFixed(1),
                  style: editPageStyle(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget hoursRow(TextEditingController startController,
      TextEditingController? endController) {
    return Dismissible(
      background: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ],
      ),
      key: GlobalObjectKey(
          {startController.text: "start", endController!.text: "end"}),
      onDismissed: (direction) {
        if (hours.containsKey(startController.text) &&
            hours.containsKey(endController.text)) {
          setState(() {
            hours.removeWhere((key, value) => key == startController.text);
            hours.removeWhere((key, value) => key == endController.text);
            _addControllers();
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              width: 80,
              child: hoursTextFieldStart(startController, endController),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "-",
            style: TextStyle(
                color: Color.fromARGB(255, 252, 248, 253),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              width: 80,
              child: hoursTextFieldEnd(endController, startController),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField hoursTextFieldEnd(TextEditingController? endController,
      TextEditingController startController) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      textAlign: TextAlign.center,
      style: editPageStyle(),
      controller: endController,
      validator: (value) {
        final RegExp timeExp = RegExp(r'^(0?[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$');
        if (value == null ||
            value.isEmpty ||
            value.trim().isEmpty ||
            startController.text.trim().isEmpty) {
          String message = "Ουπς!\nΞέχασες να βάλεις κάποια ώρα!";
          CustomSnackBar.errorMessage(context, message);
          return '';
        }
        if (!timeExp.hasMatch(value.trim()) ||
            !timeExp.hasMatch(startController.text)) {
          String message =
              'Ουπς!\nΔεν κατάλαβα την ώρα.\nΔες ενα παράδειγμα: 12:35 ή 22:10.';
          CustomSnackBar.errorMessage(context, message);
          return '';
        }

        // Split the strings into hours and minutes
        List<String> valueParts = endController!.text.split(":");
        List<String> startParts = startController.text.split(":");

        // Convert hours and minutes to integers and compare
        int endHours = int.parse(valueParts[0]);
        int endMinutes = int.parse(valueParts[1]);
        int startHours = int.parse(startParts[0]);
        int startMinutes = int.parse(startParts[1]);

        if (endHours == startHours && endMinutes == startMinutes) {
          String message = "Ουπς!\nΈβαλες ίδιες ακριβώς ώρες!";
          CustomSnackBar.errorMessage(context, message);
          return '';
        }
        if (startHours > endHours ||
            (startHours == endHours && startMinutes > endMinutes)) {
          String message =
              "Ουπς!\nΣε μία μέρα μπορείς να βάλεις μέχρι τις 23:59 και η ώρα που έβγαλες το μασελάκι να είναι μετά την ώρα που το φόρεσες!";
          CustomSnackBar.errorMessage(context, message);
          return '';
        }

        return null;
      },
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }

  void _addControllers() {
    controllersList = [];
    if (hours.isNotEmpty) {
      hours.forEach((key, value) {
        controllersList.add(TextEditingController(text: key));
      });
    }
  }

  TextFormField hoursTextFieldStart(TextEditingController? startController,
      TextEditingController endController) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      textAlign: TextAlign.center,
      style: editPageStyle(),
      controller: startController,
      validator: (value) {
        final RegExp timeExp = RegExp(r'^(0?[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$');
        if (value == null ||
            value.isEmpty ||
            value.trim().isEmpty ||
            endController.text.trim().isEmpty) {
          String message = "Ουπς!\nΞέχασες να βάλεις κάποια ώρα!";
          CustomSnackBar.errorMessage(context, message);
          return '';
        }
        if (!timeExp.hasMatch(value.trim()) ||
            !timeExp.hasMatch(startController!.text)) {
          String message =
              'Ουπς!\nΔεν κατάλαβα την ώρα.\nΔες ενα παράδειγμα: 12:35 ή 22:10.';
          CustomSnackBar.errorMessage(context, message);
          return '';
        }
        // Split the strings into hours and minutes
        List<String> valueParts = startController.text.split(":");
        List<String> startParts = endController.text.split(":");

        // Convert hours and minutes to integers and compare
        int startHours = int.parse(valueParts[0]);
        int startMinutes = int.parse(valueParts[1]);
        int endHours = int.parse(startParts[0]);
        int endMinutes = int.parse(startParts[1]);

        if (startHours == endHours && startMinutes == endMinutes) {
          // we dont use snackbar here because the other controller will display it anyway
          return '';
        }

        if (endHours < startHours ||
            (endHours == startHours && endMinutes < startMinutes)) {
          return '';
        }

        return null;
      },
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }

  void _addHours() {
    setState(() {
      hours.addAll({"99:98": "start", "99:99": "end"});
      _addControllers();
    });
  }
}
