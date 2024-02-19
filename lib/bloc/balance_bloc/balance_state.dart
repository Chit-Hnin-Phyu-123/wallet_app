part of 'balance_bloc.dart';

abstract class BalanceState extends Equatable
{
  @override
  List<Object> get props => [];
}

class BalanceInitialState extends BalanceState
{
  //
}

class BalanceLoading extends BalanceState
{
  //
}

class BalanceSuccess extends BalanceState
{
  final Balance balance;
  BalanceSuccess({required this.balance});
}

class BalanceEmpty extends BalanceState
{
  //
}

class BalanceUploading extends BalanceState
{
  //
}

class BalanceUploaded extends BalanceState
{
  //
}

class BalanceError extends BalanceState
{
  //
}