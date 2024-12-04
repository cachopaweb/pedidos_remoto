import 'package:flutter/material.dart';

class MyInputText extends StatelessWidget {
  final String? label;
  final Icon? icone;
  final bool? inputSenha;
  final TextEditingController? controller;

  const MyInputText({
    super.key,
    this.label,
    this.icone,
    this.inputSenha,
    this.controller,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: inputSenha!,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        suffix: icone,
      ),
    );
  }
}
