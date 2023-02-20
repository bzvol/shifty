import 'package:flutter/material.dart';
import 'package:shifty/util.dart';

import '../model/shift_display.dart';
import '../model/zone.dart';
import 'shift_card.dart';

class ZoneGroupCard extends StatelessWidget {
  final Zone zone;
  final Iterable<ShiftDisplay> shifts;

  const ZoneGroupCard({Key? key, required this.zone, required this.shifts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ZoneGroupPage(zone: zone, shifts: shifts.toList()))),
      child: Card(
        color: Colors.primaries.choice(),
        // elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(zone.displayName,
              style: const TextStyle(color: Colors.white, fontSize: 24)),
        ),
      ),
    );
  }
}

class ZoneGroupPage extends StatelessWidget {
  final Zone zone;
  final List<ShiftDisplay> shifts;

  const ZoneGroupPage({Key? key, required this.zone, required this.shifts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shifts in ${zone.displayName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ShiftCard(shift: shifts[index]),
          ),
          itemCount: shifts.length,
        ),
      ),
    );
  }
}
