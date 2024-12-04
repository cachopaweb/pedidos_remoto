import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  final Color cor;
  final IconData icone;
  final Function onClick;
  final Size size;

  const Botao({
    Key? key,
    required this.cor,
    required this.icone,
    required this.onClick,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick as void Function()?,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cor,
        ),
        child: Icon(
          icone,
          color: Colors.white,
        ),
      ),
    );
  }
}
