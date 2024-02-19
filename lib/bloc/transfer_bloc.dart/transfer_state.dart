part of 'transfer_bloc.dart';

abstract class TransferState extends Equatable
{
  @override
  List<Object> get props => [];
}

class TransferInitialState extends TransferState
{
  //
}

class TransferLoading extends TransferState
{
  //
}

class TransferSuccess extends TransferState
{
  final Balance balance;
  TransferSuccess({required this.balance});
}

class GetHistorySuccess extends TransferState
{
  final List<Transfer> historyList;
  GetHistorySuccess({required this.historyList});
}

class TransferEmpty extends TransferState
{
  //
}

class TransferUploading extends TransferState
{
  //
}

class TransferUploaded extends TransferState
{
  //
}

class TransferError extends TransferState
{
  //
}