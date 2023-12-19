import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final Size size;
  final VoidCallback onPressed;
  final double thickness;
  const CustomButton({
    super.key,
    required this.text,
    required this.size,
    required this.onPressed,
    this.thickness = 4,
    this.fontSize = 20,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double blurYOffset = 5;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          blurYOffset = 0;
        });
      },
      onTapUp: (_) {
        setState(() {
          blurYOffset = 5;
        });
      },
      onTap: () async {
        widget.onPressed();
      },
      child: Transform.translate(
        offset: Offset(0, -blurYOffset),
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: widget.thickness),
              color: Colors.white,
              borderRadius: BorderRadius.circular(width * 0.075),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, blurYOffset),
                )
              ]),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
