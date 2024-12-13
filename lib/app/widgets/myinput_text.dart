import 'package:flutter/material.dart';

class MyInputText extends StatelessWidget {
  final String? label;
  final Icon? icone;
  final bool? inputSenha;
  final TextEditingController? controller;
  final int? qtdLinhas;

  const MyInputText(
      {super.key,
      this.label,
      this.icone,
      this.inputSenha = false,
      this.controller,
      this.qtdLinhas = 1})
      : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: inputSenha!,
      maxLines: qtdLinhas,
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
