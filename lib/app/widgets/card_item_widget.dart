import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final Widget child;
  const CardItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(2.0, 2.0),
            blurRadius: 4,
          )
        ],
      ),
      margin: const EdgeInsets.all(10),
      child: child,
    );
  }
}
