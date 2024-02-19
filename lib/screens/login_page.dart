// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/bloc/user_bloc/user_bloc.dart';
import 'package:wallet_app/screens/home_page.dart';
import 'package:wallet_app/screens/sign_in_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserBloc userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyScreen = SignInPage(
      onpressedFunction: () async {
        userBloc.add(
          UserSignIn(),
        );
      },
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocProvider(
                create: (_) => userBloc,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return Stack(
                        children: [
                          bodyScreen,
                          Container(
                            color: Colors.black.withOpacity(0.1),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      );
                    } else if (state is UserUploaded) {
                      return const HomePage();
                    } else if (state is UserError) {
                      return const Center(
                        child: Text("Loading Error"),
                      );
                    }
                    return bodyScreen;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
