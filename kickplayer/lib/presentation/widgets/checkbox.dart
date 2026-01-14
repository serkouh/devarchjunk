import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class CustomCheckbox extends StatefulWidget {
  final Function(bool) onChanged;

  const CustomCheckbox({Key? key, required this.onChanged}) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged(_isChecked); // Send value to parent
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _isChecked ? mainblue : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: mainblue,
            width: 1,
          ),
        ),
        child: Center(
          child: _isChecked
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                )
              : null,
        ),
      ),
    );
  }
}
