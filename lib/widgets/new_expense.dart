import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _newExpenseState();
}

class _newExpenseState extends State<NewExpense> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: () {},
              maxLength: 50,
              decoration: InputDecoration(
                label: Text('Title'),
              ),
            ),
          ],
        ));
  }
}
