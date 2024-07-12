import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObsecureText;
  final String? obsecureCharacter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObsecureText = false,
    this.obsecureCharacter = "*",
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.070,
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.elliptical(16.0, 16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(135, 218, 218, 218),
            spreadRadius: 1.0,
            blurRadius: 4,
            offset: Offset(1, 3),
          ),
          BoxShadow(
            color: Color.fromARGB(135, 218, 218, 218),
            spreadRadius: 1.0,
            blurRadius: 4,
            offset: Offset(3, 1),
          ),
        ],
      ),
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        controller: controller,
        obscureText: isObsecureText!,
        obscuringCharacter: obsecureCharacter!,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.04, //15.0
            left: MediaQuery.of(context).size.width * 0.04, //12.0
            bottom: MediaQuery.of(context).size.width * 0.04, //10.0
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.075,
            maxWidth: MediaQuery.of(context).size.width * 0.70,
          ),
          //filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12.0),
          // ),
        ),
      ),
    );
  }
}
