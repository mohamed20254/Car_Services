import 'package:flutter/material.dart';

class CustomTextfield2 extends StatefulWidget {
  final String? Function(String?)? validator;
  final bool ispassword;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget label;
  final Widget? suffix;
  final Widget prefix;
  const CustomTextfield2({
    super.key,
    this.ispassword = false,
    required this.controller,
    this.keyboardType,
    required this.label,
    this.suffix,
    required this.prefix,
    this.validator,
  });

  @override
  State<CustomTextfield2> createState() => _CustomTextfield2State();
}

class _CustomTextfield2State extends State<CustomTextfield2> {
  bool _obscurtext = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      validator: widget.validator,
      obscureText: _obscurtext && widget.ispassword,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        label: widget.label,
        suffixIcon:
            widget.ispassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurtext = !_obscurtext;
                    });
                  },
                  icon: Icon(
                    _obscurtext ? Icons.visibility_off : Icons.visibility,
                  ),
                  color: isdark ? Colors.white54 : Colors.black45,
                )
                : null,
        prefixIcon: widget.prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: isdark ? Colors.white54 : Colors.black45,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isdark ? Colors.white38 : Colors.black38,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
