
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet_app/notification_services/notification_service.dart';
import '../models/balance/balance.dart';
import '../models/users/users.dart';
import '../models/transfer/transfer.dart';
import '../services/sqlite_database/db_config.dart';
import '../services/sqlite_database/db_services.dart';

part 'repositories.g.dart';

abstract class Repositories {
  factory Repositories() = _Repositories;

  @GET('')
  Future<List<Users>> getUsers(
    @Body() String userId
  );

  @POST('')
  Future<UserCredential> userSignIn();

  @GET('')
  Future<Balance> getBalance(
    @Body() String userId
  );

  @GET('')
  Future<Balance> transferMoney(
    @Body() Users receiverId, String userId, String userName, int amount
  );

  @GET('')
  Future<List<Transfer>> getHistory(
    @Body() String currentUserId, bool isTransfer
  );
}
