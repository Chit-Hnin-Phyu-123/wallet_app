
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/users/users.dart';
import '../../repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState>
{
  UserBloc() : super(UserInitialState())
  {
    final Repositories repositories = Repositories();
    on<GetUserList>((event, emit) async {
      try{
        emit(UserLoading());
        final blog = await repositories.getUsers(event.userId);
        emit(UserSuccess(userList: blog));
        if(blog.isEmpty){
          emit(UserEmpty());
        }
      }catch(e){
        emit(UserError());
      }
    });

    on<UserSignIn>((event, emit) async {
      try{
        emit(UserLoading());
        await repositories.userSignIn();
        emit(UserUploaded());
      }catch(e){
        emit(UserError());
      }
    });
  }
}