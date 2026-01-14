import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solair/archive/Constent.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomSelector extends StatefulWidget {
  final String type;
  final String me;

  CustomSelector({required this.type, required this.me});

  @override
  _CustomSelectorState createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPhoneNumber = '';
  final _formKey = GlobalKey<FormState>();
  String imageAsset = 'Assets/whatsapp-line-logo-icon-2048x2048-059kk1vz.png';

  @override
  void initState() {
    super.initState();
    if (widget.type == '1') {
      imageAsset =
          'Assets/Screenshot 2024-03-03 211848-Photoroom.png-Photoroom.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          0.7, // Set height to 0.7 screen height
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageAsset,
                  width: 20,
                  height: 20,
                  color: darkblue,
                ),
                SizedBox(width: 10), // Adjust spacing between icon and text
                Text(
                  'Nous contacter',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: darkblue,
                  ),
                ),
              ],
            ),
            Divider(
              color: darkblue,
              thickness: 1,
              height: 20,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDateTimeSelector(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  value: _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : null,
                ),
                SizedBox(height: 20),
                buildDateTimeSelector(
                  icon: Icons.access_time,
                  label: 'Heure',
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null && pickedTime != _selectedTime) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                  value: _selectedTime != null
                      ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                      : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _selectedPhoneNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez votre numéro';
                    }
                    if (value.length <= 9) {
                      return 'Au moins 10 chiffres';
                    }
                    return null;
                  },
                  decoration: primaryInputDecoration(
                    prefixIcon: Icons.phone,
                    hintText: 'Numéro de téléphone',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center align the buttons
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey, // Change button text color here
                  ),
                ),
              ),
              SizedBox(width: 10), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.type == '0') {
                      _launchWhatsApp(
                        _selectedPhoneNumber,
                        formatDateTime(
                          _selectedDate ?? DateTime.now(),
                          _selectedTime ?? TimeOfDay.now(),
                        ),
                      );
                    } else {
                      _sendEmail(
                        _selectedPhoneNumber,
                        formatDateTime(
                          _selectedDate ?? DateTime.now(),
                          _selectedTime ?? TimeOfDay.now(),
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Confirmer',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Change button text color here
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      darkblue), // Change button background color here
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _launchWhatsApp(String phone, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? 'YourName';

    String phoneNumber = "0645112146";

    String message =
        "Bonjour, je suis $userName. J'aimerais prendre un rendez-vous pour une consultation concernant un projet de développement informatique à la date $date. Mon numéro de téléphone est $phone.";
    if (widget.me == '1') {
      message =
          "Bonjour d3solaire, je suis $userName. J'aimerais prendre rendez-vous pour une consultation concernant une installation solaire à la date $date. Mon numéro de téléphone est $phone.";
    }
    String url = "https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}";

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print("Error launching WhatsApp: $e");
    }
  }

  _sendEmail(String phone, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? 'YourName';

    String message =
        "Bonjour, je suis $userName. J'aimerais prendre un rendez-vous pour une consultation concernant un projet de développement informatique à la date $date. Mon numéro de téléphone est $phone.";
    if (widget.me == '1') {
      message =
          "Bonjour d3solaire, je suis $userName. J'aimerais prendre rendez-vous pour une consultation concernant une installation solaire à la date $date. Mon numéro de téléphone est $phone.";
    }
    String emailAddress = "contact.support@nexus-tech-solution.com";
    String emailUrl =
        "mailto:$emailAddress?body=${Uri.encodeComponent(message)}";

    try {
      await launchUrl(Uri.parse(emailUrl));
    } catch (e) {
      print("Error launching email client: $e");
    }
  }

  String formatDateTime(DateTime date, TimeOfDay time) {
    String formattedDate = '${date.day}/${date.month}/${date.year}';
    String formattedTime = '${time.hour}:${time.minute}';
    return '$formattedDate - $formattedTime';
  }

  Widget buildDateTimeSelector({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required String? value,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Set background color to grey
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(children: [
            Icon(icon, color: darkblue),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value ?? 'Sélectionner $label',
                style: TextStyle(
                  fontSize: 16.0,
                  // fontWeight: FontWeight.bold,
                  color: value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ])),
    );
  }
}
