import 'dart:math';

import 'package:flutter/material.dart';

extension ListExtension<T> on List<T> {
  T choice() => this[Random().nextInt(length)];
}

Future<DateTime> showDateTimePicker(BuildContext context, DateTime initialDate,
    DateTime firstDate, DateTime lastDate) async {
  // showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate);
  // showTimePicker(context: context, initialTime: initialTime);

  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (date == null) return initialDate;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );
  if (time == null) return initialDate;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
