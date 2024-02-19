part of 'user_bloc.dart';

abstract class UserState extends Equatable
{
  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState
{
  //
}

class UserLoading extends UserState
{
  //
}

class UserSuccess extends UserState
{
  final List<Users> userList;
  UserSuccess({required this.userList});
}

class UserEmpty extends UserState
{
  //
}

class UserUploading extends UserState
{
  //
}

class UserUploaded extends UserState
{
  //
}

class UserError extends UserState
{
  //
}