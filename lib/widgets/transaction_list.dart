import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 20,
                ),
                // we used the sized box tocreate empty space, although it can have children
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                    // fit:BoxFit.cover fits the Image according to the surrounding container
                  ),
                )
              ],
            )
          : ListView.builder(
              // ListView is by default a column with SingleChildScroll view
              itemBuilder: (ctx, index) {
                // ctx is the context provided by flutter. index is the index no. of the item being rendered. Check itemCount after itemBuilder. index will increase till itemCount increases. itemCount is the transactions length, so builder will run only for the no.of transactions
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () => deleteTx(transactions[index].id),
                      // we used a call back function because onPressed dosent take any arguments but we had to pass id
                    ),
                  ),
                );
                //List Tile is a pre configured widget that works well with lists
                // leading is a widget that is at the beginning & CircleAvatar() is a widget that holds content and looks good
              },
              itemCount: transactions.length,
              // builder will run only till this length of transactions. AFter that the index of the builder function will not be incremented
            ),
    );
  }
}
