import 'package:flutter/material.dart';
import 'package:wallet_app/components/mybutton.dart';
import 'package:wallet_app/components/mytextfield.dart';

class SignInPage extends StatefulWidget {
  final Function onpressedFunction;
  const SignInPage({
    Key? key,
    required this.onpressedFunction
  }) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 150),
          const Text(
            'Sign in using',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RawMaterialButton(
                onPressed: () => widget.onpressedFunction(),
                elevation: 3,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                shape: const CircleBorder(),
                child: Image.asset(
                  'assets/google.png',
                  width: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 3,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                shape: const CircleBorder(),
                child: Image.asset(
                  'assets/facebook.png',
                  width: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 3,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                shape: const CircleBorder(),
                child: Image.asset(
                  'assets/github.png',
                  width: 30,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 1,
                  color: Colors.black,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 1,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                MyTextField(controller: emailCtrl, labelText: 'Email'),
                const SizedBox(height: 20),
                MyTextField(controller: passwordCtrl, labelText: 'Password'),
                const SizedBox(height: 30),
                const MyButton(buttonText: 'Sign In'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
