import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  // TextEditingController() is a class provided  by flutter
  final _amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(
      // using this widget. we are able to access "addTx" which we get in the statefulwidget above
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
    // upon submission the bottom modal sheet closes automatically
  }

  void _presentDatePicker() {
    showDatePicker(
      // showDatePicker is built in flutter function. It returns a 'future' which is trigerred when the person chooses the date
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // until the user picks a date or cancels the code runs below then{}
      if (pickedDate == null) {
        // null means if user pressed cancel
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // we used  crossAxisAlignment.end to button to the right side
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
              // the '_' inabove line indicates that we get an argument but we don't care about it. We did it because it accepts strings.
              // onSubmitted and then calling submitData means even if we press submit button (tick button), then the tranaction will be saved
              // since we have an anonymous function that's why we use () with function call
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              //keyboardType: TextInputType.number. It allows the user to only add number as input
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    // Text() goes to right using Expanded. Although we could also have used flexfit:tight
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor),
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
