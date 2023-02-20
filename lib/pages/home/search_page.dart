import 'package:flutter/material.dart';
import 'package:shifty/controller/shift_controller.dart';
import 'package:shifty/model/shift.dart';
import 'package:shifty/model/user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DateTime _searchStart = DateTime.now();
  DateTime _searchEnd = _calculateNextWeekend();
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: _searchStart,
                  firstDate: DateTime.now(),
                  lastDate: _calculateNextWeekend(),
                ).then((value) =>
                    setState(() => {if (value != null) _searchStart = value})),
                child: Text(_formatDate(_searchStart)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: _searchEnd,
                  firstDate: DateTime.now().add(const Duration(minutes: 1)),
                  lastDate: _calculateNextWeekend(),
                ).then((value) =>
                    setState(() => {if (value != null) _searchEnd = value})),
                child: Text(_formatDate(_searchEnd)),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => setState(() => _showResults = true),
          child: const Text('Search'),
        ),
        const SizedBox(height: 20),
        if (_showResults)
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (Shift.searchResults.isNotEmpty) {
                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 10.0,
                      children: buildShiftView(),
                    ),
                  );
                }
                return const Text('No results');
              } else if (snapshot.hasError) {
                return const Text('Error');
              }
              return const LinearProgressIndicator(minHeight: 15);
            },
            future: User.instance!.searchShifts(_searchStart, _searchEnd),
          ),
      ],
    );
  }

  static DateTime _calculateNextWeekend() {
    final now = DateTime.now();
    final nextSunday = now.add(Duration(days: 14 - now.weekday));
    return DateTime(
        nextSunday.year, nextSunday.month, nextSunday.day, 23, 59, 59);
  }

  static String _formatDate(DateTime date) {
    return '${date.year}. '
        '${date.month.toString().padLeft(2, '0')}. '
        '${date.day.toString().padLeft(2, '0')}. '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
