import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      // 7 here is for 7 days of week
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
        // in variable wekDay we calculate the current day of week like yesterday etc
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      // if the recentTransaction has day, month, year matching then we add the amount to totalSum
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        // 0,1 means wednseday will show W and so on
        'amount': totalSum,
      };
      // DateFOrmat.E() gives the shortnames for days of week
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
      // we are adding to 0.0 as initial value and calculating sum
    });
    // fold allows us to change a list to another type
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        // if we just need a container to add padding then we can name it padding but still we have to specify padding as done below
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              // we use flexible widget so that the chart size dosent change upon adding expenses
              // if we write flex: 2 then it this container takes 2 out of total segments of screen. Default is 1
              fit: FlexFit.tight,
              // we use fit so that child size dosent grow and uses only its size. FlexFit.tight means take all the space available
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
