import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Buttons.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class UserInfoScreen extends StatefulWidget {
  final Function(String) phoneNumber;
  final Function(String) address;
  final Function(String) teamName;

  UserInfoScreen(
      {required this.phoneNumber,
      required this.address,
      required this.teamName});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  String _selectedTeamName = '';

  // List of available team options for the dialog
  final List<String> _teamOptions = [
    'Moroccan Amateur League 1',
    'Moroccan Amateur League 2',
    'Moroccan Amateur League 3',
    'Botola Second Division',
    'None of Above'
  ];

  /// Function to show the dialog and select a team
  Future<void> _showTeamNameDialog() async {
    String selectedTeam = _selectedTeamName; // Store selected team

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // White background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // 5 border radius
          ),
          title: Text(
            'Choose your current league',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 350, // Set a fixed width for the dialog content
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _teamOptions.map((team) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1), // Reduced space between options
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Ensure checkbox is on the right
                          children: [
                            Text(
                              team,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ), // Team, name
                            Transform.scale(
                              scale: 1.2, // Make checkbox slightly bigger
                              child: Checkbox(
                                shape: CircleBorder(), // Circle-shaped checkbox
                                value: selectedTeam ==
                                    team, // If the team is selected, the checkbox is checked
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedTeam = value!
                                        ? team
                                        : selectedTeam; // Update selected team
                                  });
                                },
                                checkColor:
                                    Colors.white, // White check mark color
                                activeColor: Colors
                                    .blue, // Blue color for the checkbox when checked
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          actions: [
            Container(
              width: double.infinity, // Full width
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTeamName =
                        selectedTeam; // Update the selected team
                    _teamNameController.text =
                        selectedTeam; // Set to input field
                    widget.teamName(selectedTeam); // Send team name to parent
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainblue, // Blue background for the button
                  foregroundColor: Colors.white, // White text color
                  minimumSize:
                      Size(double.infinity, 50), // Full width, height 50
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5), // Rounded corners with radius 5
                  ),
                ),
                child: Text('Confirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // Make the body scrollable
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 0),
                width: screenWidth * 0.8,
                child: H2TITLE('Complete Information'),
              ),
            ),
            SizedBox(height: 25),
            Expanded(
                child: Center(
                    // Center everything in the body
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  Text("Phone Number",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Enter phone number",
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    initialCountryCode: 'MA',
                    onChanged: (phone) {
                      print("Phone Number: ${phone.completeNumber}");
                      widget.phoneNumber(
                          phone.completeNumber); // Send phone number to parent
                    },
                  ),
                  GestureDetector(
                    onTap: _openMap,
                    child: InputField(
                      label: "Address",
                      icon: Icons.location_on,
                      hintText: "Enter your address",
                      keyboardType: TextInputType.text,
                      controller: _addressController,
                      enabled:
                          false, // Désactivé pour forcer l'utilisation de la carte
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showTeamNameDialog, // Show dialog when tapped
                    child: InputField(
                      label: "League division",
                      icon: Icons.group,
                      hintText: "Enter League division",
                      keyboardType: TextInputType.text,
                      controller: _teamNameController,
                      enabled: false,
                      onTap: _showTeamNameDialog,
                    ),
                  ),
                  SizedBox(height: 40),
                ]))),
          ],
        ),
      ),
    );
  }

  /// Open the map and allow location selection
  Future<void> _openMap() async {
    LatLng selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          headerText: (adress) {
            setState(() {
              _addressController.text = adress;
              widget.address(adress);
            });
          },
        ),
      ),
    );

    if (selectedLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );

      if (placemarks.isNotEmpty) {
        String address = "${placemarks[0].street}, ${placemarks[0].locality}";
        setState(() {
          _addressController.text = address;
        });
        widget.address(address); // Send the address to the parent
      }
    }
  }
}

class MapScreen extends StatefulWidget {
  final Function(String) headerText; // Added string parameter for the header

  // Constructor to accept the header text
  MapScreen({required this.headerText});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedLocation = LatLng(33.5731, -7.5898); // Default to Casablanca
  String _address = "Sélectionnez un emplacement"; // Default address message

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  // Check for location permission and get the current location
  Future<void> _checkPermissionAndGetLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Handle the case where the permission is denied permanently
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission de localisation refusée définitivement.'),
      ));
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      _getAddressFromCoordinates(position.latitude, position.longitude);
    } else {
      // If permission is denied, show a message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission de localisation requise.'),
      ));
    }
  }

  // Get the address from latitude and longitude
  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.name}, ${place.locality}, ${place.country}";
      });
      widget.headerText(_address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Your adress"), // Use the headerText parameter
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selectedLocation, // Corrected
                initialZoom: 12,
                minZoom: 5,
                onTap: (_, LatLng latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                    _getAddressFromCoordinates(
                        latLng.latitude, latLng.longitude);
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: CustomButton(
        text: 'Confirmer',
        color: Colors.blue, // Your custom color
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
