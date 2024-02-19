
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/balance/balance.dart';
import '../../repositories/repositories.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState>
{
  BalanceBloc() : super(BalanceInitialState())
  {
    final Repositories repositories = Repositories();
    on<GetBalance>((event, emit) async {
      try{
        emit(BalanceLoading());
        final blog = await repositories.getBalance(event.userId);
        emit(BalanceSuccess(balance: blog));
        if(blog.toJson().isEmpty){
          emit(BalanceEmpty());
        }
      }catch(e){
        emit(BalanceError());
      }
    });

  }
}