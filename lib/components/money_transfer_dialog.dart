import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/bloc/transfer_bloc.dart/transfer_bloc.dart';
import 'package:wallet_app/screens/home_page.dart';

import '../models/users/users.dart';

class MoneyTransferDialog extends StatefulWidget {
  final Users user;
  final String currentUserId;
  final String currentUserName;
  const MoneyTransferDialog({
    Key? key,
    required this.user,
    required this.currentUserId,
    required this.currentUserName,
  }) : super(key: key);

  @override
  State<MoneyTransferDialog> createState() => _MoneyTransferDialogState();
}

class _MoneyTransferDialogState extends State<MoneyTransferDialog> {
  final TextEditingController _amountController = TextEditingController();

  TransferBloc transfer = TransferBloc();

  @override
  Widget build(BuildContext context) {
    Widget dialogWidget = AlertDialog(
      title: Text('Transfer to ${widget.user.name}'),
      content: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Amount'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () {
            // Navigator.of(context).pop();
            transfer.add(
              TransferMoney(
                userId: widget.currentUserId,
                userName: widget.currentUserName,
                receiver: widget.user,
                amount: int.parse(_amountController.text),
              ),
            );
          },
          child: const Text('Transfer'),
        ),
      ],
    );
    return BlocProvider(
      create: (_) => transfer,
      child: BlocBuilder<TransferBloc, TransferState>(
        builder: (context, state) {
          if (state is TransferLoading) {
            return Container(
              color: Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is TransferSuccess) {
            return const HomePage();
          } else if (state is TransferError) {
            return const Center(
              child: Text("Loading Error"),
            );
          }
          return dialogWidget;
        },
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
