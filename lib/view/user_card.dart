import 'package:flutter/material.dart';

import '../model/user.dart';

class UserCard extends StatelessWidget {
  const UserCard(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Courier ID: ${user.id}',
              style: const TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            Row(children: [
              Expanded(
                  child: Text(user.name,
                      style: Theme.of(context).textTheme.headline4)),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(user.group.toString()),
              ),
            ]),
            const SizedBox(height: 16.0),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone}'),
            const SizedBox(height: 8.0),
            const Text('0.0 hours worked last week')
          ],
        ));
  }
}
