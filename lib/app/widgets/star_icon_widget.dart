import 'package:flutter/material.dart';

class StarIconWidget extends StatelessWidget {
  const StarIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 25,
      child: Icon(
        Icons.star,
        color: Colors.blue,
      ),
    );
  }
}
