part of 'transfer_bloc.dart';

abstract class TransferEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TransferMoney extends TransferEvent {
  final String userId;
  final String userName;
  final Users receiver;
  final int amount;
  TransferMoney({
    required this.userId,
    required this.userName,
    required this.receiver,
    required this.amount,
  });
}

class GetHistoryList extends TransferEvent {
  final String userId;
  final bool isTransfer;
  GetHistoryList({
    required this.userId,
    required this.isTransfer,
  });
}
