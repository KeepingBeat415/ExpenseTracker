import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _newExpenseState();
}

class _newExpenseState extends State<NewExpense> {
  // Optional 1 for in store user input info
  // String _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  //Optional 2 for in store user input info
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  //delete memory for previous input
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    //call back -> Future Object
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    // start from here, the only the when pickedDate available
    //print(pickedDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    //check which platform
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered...'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okey'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okey'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseDate() {
    //tryParse('Hello) => null, tryParse('1.12') => 1.12
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      return _showDialog();
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //UI elements that might be overlapping certain parts of the UI
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    //fit with available space
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          //onChanged: _saveTitleInput,
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    //onChanged: _saveTitleInput,
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  //this value map to onChanged(value)
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            //print(value);
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      Expanded(
                        child: Row(
                          //layout in the horizon
                          mainAxisAlignment: MainAxisAlignment.end,
                          //layout in the vertical
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No Date Selected'
                                // '!' force formatter.format will no be NULL
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          //layout in the horizon
                          mainAxisAlignment: MainAxisAlignment.end,
                          //layout in the vertical
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No Date Selected'
                                // '!' force formatter.format will no be NULL
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            //call to parent context
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: _submitExpenseDate,
                          // () {
                          //   //print(_enteredTitle);
                          //   // print(
                          //   //     '${_titleController.text} -- ${_amountController.text} ');
                          // },
                          child: const Text('Save Expense')),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  //this value map to onChanged(value)
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            //print(value);
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            //call to parent context
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: _submitExpenseDate,
                          // () {
                          //   //print(_enteredTitle);
                          //   // print(
                          //   //     '${_titleController.text} -- ${_amountController.text} ');
                          // },
                          child: const Text('Save Expense')),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
