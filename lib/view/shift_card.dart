import 'package:flutter/material.dart';
import 'package:shifty/model/shift_display.dart';
import 'package:shifty/model/shift_group.dart';

import '../model/shift.dart';

class ShiftCard extends StatelessWidget {
  final ShiftDisplay shift;

  const ShiftCard({Key? key, required this.shift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        color: Colors.grey.shade50,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(_formatDate(shift.start)),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_formatTime(shift.start)),
                  ),
                  const SizedBox(width: 8),
                  const Text('->',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_formatTime(shift.end)),
                  ),
                  const SizedBox(width: 8),
                  if (shift is ShiftGroup) const Text("Shift group"),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: shift.type == ShiftType.unassigned
                                ? Colors.green
                                : Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            )));
  }

  static String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.day.toString().padLeft(2, '0')}";
  }

  static String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";
  }
}
