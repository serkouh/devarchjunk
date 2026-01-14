import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solair/archive/Constent.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController Telephoneontroller = TextEditingController();
  late SharedPreferences _prefs;
  String selectedLanguage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'Assets/5124556-Photoroom.png-Photoroom.png',
            fit: BoxFit.fitHeight,
            width: double.infinity,
            height: 150.0,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: size * 0.9,
                    child: Center(
                      child: AutoSizeText(
                        'Contactez-nous',
                        maxLines: 1,
                        minFontSize: 16,
                        style: TextStyle(
                          color: Color(0xFF005187),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    width: size * 0.9,
                    child: Center(
                      child: AutoSizeText(
                        'Nous sommes à votre écoute 24h/24 et 7j/7',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStyledTextField(
                      TextInputType.text, 'Nom', nameController,
                      validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildStyledTextField(
                      TextInputType.phone, 'Téléphone', Telephoneontroller,
                      validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre numéro de téléphone';
                    }
                    if (value.length <= 10) {
                      return 'Le numéro de téléphone doit comporter plus de 10 chiffres';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildStyledTextField(
                      TextInputType.text, 'Message', messageController,
                      maxLines: 4, validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre message';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  isLoading
                      ? CircularProgressIndicator()
                      : _buildStyledButton('Envoyer', onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            sendmessage();
                          }
                        }),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFF005187),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle('Informations de contact'),
                      const SizedBox(height: 24),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(
                                  0xFF005187), // Set the border color to blue
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(left: 4, right: 16),
                          child: _buildContactInfoTile(
                              Icons.phone, '+212 6 45 11 21 46')),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(
                                  0xFF005187), // Set the border color to blue
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(left: 4, right: 16),
                          child: _buildContactInfoTile(Icons.email,
                              'contact.support@nexus-tech-solution.com')),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(
                                  0xFF005187), // Set the border color to blue
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(left: 4, right: 16),
                          child: _buildContactInfoTile(Icons.home,
                              "382, Angle Av, imam Ghazali & Rue Youssoufia Res , Takafoul , 4eme etage , N 26 - Tanger")),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField(TextInputType keyboard, String labelText,
      TextEditingController controller,
      {int? maxLines, String? Function(String?)? validator}) {
    return TextFormField(
      cursorColor: darkblue,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        focusColor: darkblue,
        hintStyle: TextStyle(color: darkblue),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              width: 1.5,
              color: darkblue), // Set blue color for the active borders
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildStyledButton(String label, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF005187), // Set the button color to blue
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF005187), // Set the text color to blue
        ),
      ),
    );
  }

  Widget _buildContactInfoTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xFF005187), // Set the icon color to blue
      ),
      title: Text(text),
    );
  }

  void sendmessage() async {
    String name = nameController.text;
    String msg = messageController.text;
    String telephone = Telephoneontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedEmail = prefs.getString('email') ?? '';

    CollectionReference messagesRef =
        FirebaseFirestore.instance.collection('messages');

    try {
      await messagesRef.add({
        'name': name,
        'email': savedEmail,
        'message': msg,
        'date': DateTime.now(),
        'phone': telephone,
      });

      setState(() {
        isLoading = false;
      });
      ElegantNotification.success(
        animationDuration: const Duration(milliseconds: 600),
        width: 360,
        position: Alignment.bottomCenter,
        animation: AnimationType.fromBottom,
        title: const Text('Message bien envoyé'),
        description:
            const Text('Nous répondrons aussi rapidement que possible'),
        onDismiss: () {},
      ).show(context);
      Navigator.pop(context);

      nameController.clear();
      messageController.clear();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
