part of 'balance_bloc.dart';

abstract class BalanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBalance extends BalanceEvent {
  final String userId;
  GetBalance({required this.userId});
}
