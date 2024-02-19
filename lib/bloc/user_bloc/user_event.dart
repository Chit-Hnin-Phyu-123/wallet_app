part of 'user_bloc.dart';

abstract class UserEvent extends Equatable
{
  @override
  List<Object> get props => [];
}

class GetUserList extends UserEvent
{
  final String userId;
  GetUserList({required this.userId});
}

class UserSignIn extends UserEvent
{
  UserSignIn();
}