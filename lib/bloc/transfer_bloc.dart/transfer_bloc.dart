import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/models/transfer/transfer.dart';
import 'package:wallet_app/models/users/users.dart';
import '../../models/balance/balance.dart';
import '../../repositories/repositories.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc() : super(TransferInitialState()) {
    final Repositories repositories = Repositories();
    on<TransferMoney>((event, emit) async {
      try {
        emit(TransferLoading());
        final blog = await repositories.transferMoney(
          event.receiver,
          event.userId,
          event.userName,
          event.amount,
        );
        emit(TransferSuccess(balance: blog));
        if (blog.toJson().isEmpty) {
          emit(TransferEmpty());
        }
      } catch (e) {
        emit(TransferError());
      }
    });

    on<GetHistoryList>((event, emit) async {
      try {
        emit(TransferLoading());
        final blog =
            await repositories.getHistory(event.userId, event.isTransfer);
        emit(GetHistorySuccess(historyList: blog));
        if (blog.isEmpty) {
          emit(TransferEmpty());
        }
      } catch (e) {
        emit(TransferError());
      }
    });
  }
}
