import 'package:flutter/material.dart';
import 'package:HappyTeeth/db/db_helper.dart';
import 'package:HappyTeeth/models/calendar.dart';

class CalendarController extends Calendar {
  CalendarController({required super.date});

  // this fetched the calendar
  static Future<List<Calendar>> getAll() async {
    try {
      var db = await SQLHelper.db();

      List<Map<String, Object?>> rows = await db.query(
        'calendar',
        orderBy: 'date ASC',
      );

      return rows.map((row) => Calendar.fromMap(row)).toList();
    } catch (error) {
      //oops message
      debugPrint(error.toString());
      return [];
    }
  }

  static Future<void> updateDay(Calendar item) async {
    try {
      var db = await SQLHelper.db();

      await db.update('calendar', item.toMap(), where: 'id = ?', whereArgs: [
        item.id,
      ]);
      debugPrint("Record Updated Succesfully!");
    } catch (error) {
      debugPrint(error.toString());
    }
  }

   static Future<Calendar?> getSingleDay(String date) async {
    try {
      var db = await SQLHelper.db();

      var results =
          await db.query("calendar", where: "date = ?", whereArgs: [date]);

      Calendar dbDate = Calendar.fromMap(results.first);

      return dbDate;

    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}
