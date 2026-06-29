import 'package:flutter/material.dart';

class ShowInfoImage extends StatelessWidget {
  const ShowInfoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                    image: AssetImage("assets/images/info.jpeg"))
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_circle_left, size: 30, color: Colors.greenAccent,),

              ),
            )
          ],
        ),
      ),
    );
  }
}
