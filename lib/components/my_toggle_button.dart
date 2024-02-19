import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool val);

class MyToggleButton extends StatefulWidget {
  final BoolCallback isTransfer;
  const MyToggleButton({Key? key, required this.isTransfer}) : super(key: key);

  @override
  State<MyToggleButton> createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  double width = 200.0;
  double height = 40.0;
  double transferAlign = -1;
  double receiveAlign = 1;
  Color selectedColor = Colors.white;
  Color normalColor = Colors.black54;

  double xAlign = -1;
  Color transferColor = Colors.white;
  Color receiveColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = transferAlign;
                transferColor = selectedColor;

                receiveColor = normalColor;

                widget.isTransfer(true);
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Transfer',
                  style: TextStyle(
                    color: transferColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = receiveAlign;
                receiveColor = selectedColor;

                transferColor = normalColor;

                widget.isTransfer(false);
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Receive',
                  style: TextStyle(
                    color: receiveColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
