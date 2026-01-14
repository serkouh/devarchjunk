import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;

  const ClientForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.addressController,
    required this.phoneController,
  }) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _buildTextField(widget.nameController, 'Nom du client', validator: _validateName),
          _buildTextField(widget.addressController, 'Adresse du client', validator: _validateAddress),
          _buildTextField(widget.phoneController, 'Téléphone du client', keyboardType: TextInputType.phone, validator: _validatePhone),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
          ),
        ),
        validator: validator,
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer le nom du client';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer l\'adresse du client';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer le numéro de téléphone du client';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }
    return null;
  }
}
