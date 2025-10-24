import 'package:flutter/material.dart';
class CustomImput extends StatelessWidget {
  final IconData? icon;
  final String placeholder;
  final TextEditingController textControler;
  final TextInputType keyboarType;
  final bool ispassword;
  final FocusNode? node, nexNode;
  final int maxLength;
  final String? Function(String?)? validator;

  const CustomImput({
    super.key,
    this.icon,
    required this.placeholder,
    required this.textControler,
    this.node,
    this.nexNode,
    this.keyboarType = TextInputType.text,
    this.ispassword = false,
    this.maxLength = 150,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        maxLength: maxLength,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        focusNode: node,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(nexNode),
        cursorColor: Colors.black87,
        obscureText: ispassword,
        controller: textControler,
        keyboardType: keyboarType,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.black87, size: 20)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
           isDense: true,
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black87, width: 1),
          ),
        ),
        
        validator: validator,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }
}
