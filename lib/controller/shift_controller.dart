import 'package:flutter/material.dart';

import '../model/shift.dart';
import '../model/shift_display.dart';
import '../model/shift_group.dart';
import '../model/zone.dart';
import '../view/zone_group_card.dart';

List<Widget> buildShiftView() {
  final shiftGroups = <ShiftDisplay>[];
  var shifts = Shift.searchResults;
  for (var i = 0; i < shifts.length; i++) {
    final shift = shifts[i];
    final group = shifts.where((s) => s.identicalDisplayData(shift));
    if (group.length > 1) {
      shiftGroups.add(ShiftGroup(group.toList()));
      shifts.removeWhere((s) => s.identicalDisplayData(shift));
      i--;
      continue;
    }
    shiftGroups.add(shift);
  }

  final zoneSet = shiftGroups.map((s) => s.zone).toSet();
  final zones = zoneSet.toList()..sort((a, b) => a.index.compareTo(b.index));
  final zoneGroups = <Zone, Iterable<ShiftDisplay>>{
    for (var zone in zones) zone: shiftGroups.where((s) => s.zone == zone)
  };

  return <Widget>[
    for (var entry in zoneGroups.entries)
      ZoneGroupCard(
        zone: entry.key,
        shifts: entry.value.toList(),
      )
  ];
}