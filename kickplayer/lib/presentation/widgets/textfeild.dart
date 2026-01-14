import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class InputField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final TextEditingController? controller;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onchange;

  InputField({
    required this.label,
    required this.icon,
    required this.hintText,
    required this.keyboardType,
    this.isPasswordField = false,
    this.controller,
    this.enabled = true,
    this.onTap,
    this.onchange,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField; // default based on isPasswordField
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        if (widget.label.isNotEmpty) SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(widget.icon),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: AbsorbPointer(
                      absorbing: !widget.enabled,
                      child: TextField(
                        controller: widget.controller,
                        obscureText:
                            widget.isPasswordField ? _obscureText : false,
                        keyboardType: widget.keyboardType,
                        onChanged: widget.onchange,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isPasswordField)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordInputField extends StatefulWidget {
  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password*',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: deepgrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(Icons.lock_outline),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SeachFeild extends StatelessWidget {
  final String label;
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final TextEditingController? controller;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onchange;

  SeachFeild({
    required this.label,
    required this.icon,
    required this.hintText,
    required this.keyboardType,
    this.isPasswordField = false,
    this.controller,
    this.enabled = true,
    this.onTap,
    this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        if (label.isNotEmpty) SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey, width: 0.8), // Thinner border
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Icon(icon,
                    size: 18, color: Colors.grey.shade700), // Thinner icon
                SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: AbsorbPointer(
                      absorbing: !enabled,
                      child: TextField(
                        controller: controller,
                        obscureText: isPasswordField,
                        keyboardType: keyboardType,
                        onChanged: (value) {
                          if (onchange != null) {
                            onchange!(
                                value); // Call the onchange function with the new text value
                          }
                        },
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.8, // Thinner focused border
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isPasswordField)
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.visibility_off,
                        size: 18, color: Colors.grey.shade700),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PostField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String)? onChanged;

  PostField({
    required this.label,
    required this.hintText,
    this.controller,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        if (label.isNotEmpty) SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Lightgrey, width: 0.5), // Thinner border
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: 5, // Allows 5 lines
              onChanged: onChanged,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0.8, // Thinner focused border
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
