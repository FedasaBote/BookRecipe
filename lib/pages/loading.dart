import 'package:flutter/material.dart';

import 'menu.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MenuPage(),
          ),
        );
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/hat.png", width: width * 0.8),
            SizedBox(
              height: width * 0.1,
            ),
            Container(
              width: width * 0.8,
              height: width * 0.06,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.black,
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 2,
                    top: 2,
                    bottom: 2,
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: _controller.value * width * 0.785,
                            height: 20,
                            decoration: BoxDecoration(
                              color:  const Color(0xFFFAF4E1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
