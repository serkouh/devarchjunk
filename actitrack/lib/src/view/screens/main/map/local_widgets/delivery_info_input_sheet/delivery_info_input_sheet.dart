import 'dart:convert';
import 'dart:io';

import 'package:actitrack/src/models/distribution_object.dart';
import 'package:actitrack/src/services/api/tasks_service.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:actitrack/src/models/target_location.dart';
import 'package:actitrack/src/services/permissions/permissions_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/state/providers/map/map_state_provider.dart';
import 'package:actitrack/src/state/providers/tasks/ongoing_task_provider.dart';
import 'package:actitrack/src/state/providers/tasks/tasks_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'client_form.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DeliveryInfoInputSheet extends StatefulWidget {
  final DistributionObject distributionObject;
  final String tasklocationid;
  const DeliveryInfoInputSheet(
      {super.key,
      required this.distributionObject,
      required this.tasklocationid});

  @override
  State<DeliveryInfoInputSheet> createState() => _DeliveryInfoInputSheetState();
}

class _DeliveryInfoInputSheetState extends State<DeliveryInfoInputSheet> {
  late TextEditingController _deliveredFlyersCountController;
  File? _flyerImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    MyLogger.info(widget.distributionObject);
    _deliveredFlyersCountController = TextEditingController();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.distributionObject.clientName == 1) {
      _controllers['client_name'] = TextEditingController();
    }
    if (widget.distributionObject.productName == 1) {
      _controllers['product_name'] = TextEditingController();
    }
    if (widget.distributionObject.phoneNumber == 1) {
      _controllers['phone_number'] = TextEditingController();
    }
    if (widget.distributionObject.sexe == 1) {
      _controllers['sexe'] = TextEditingController();
    }
    if (widget.distributionObject.email == 1) {
      _controllers['email'] = TextEditingController();
    }
    if (widget.distributionObject.city == 1) {
      _controllers['city'] = TextEditingController();
    }
    if (widget.distributionObject.age == 1) {
      _controllers['age'] = TextEditingController();
    }
    if (widget.distributionObject.note == 1) {
      _controllers['note'] = TextEditingController();
    }
  }

  void _resetAll() {
    setState(() {
      _deliveredFlyersCountController.clear();
      _flyerImage = null;
      _isSubmitting = false;

      _controllers.forEach((key, controller) {
        controller.clear();
      });
    });
  }

  @override
  void dispose() {
    _deliveredFlyersCountController.dispose();
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<bool> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _flyerImage = File(image.path);
        });
        return true;
      } else {
        throw 'No image picked (null)';
      }
    } catch (e) {
      print('Error picking image: ${e.toString()}');
    }
    return false;
  }

  Widget _buildTextField(String label, String key, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OngoingTaskProvider ongoingTaskProvider =
        Provider.of<OngoingTaskProvider>(context);

    return _buildInputFields(context, ongoingTaskProvider);
  }

  Widget _buildInputFields(
      BuildContext context, OngoingTaskProvider ongoingTaskProvider) {
    return Container(
        height:
            MediaQuery.of(context).size.height * 0.7, // 70% of screen height
        width: MediaQuery.of(context).size.width, // 100% of screen width
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 23.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enregistrez une livraison de Flyer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 31),
                  Container(
                    height: 141,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        splashColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _pickImage();
                        },
                        child: _flyerImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _flyerImage!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).primaryColor,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      "Prenez une photo de l'article du flyer que vous êtes sur le point de livrer",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    'Nombre de flyers livrés ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 80,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'Entrez le nombre de flyers livrés',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: TextFormField(
                                controller: _deliveredFlyersCountController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: '00',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Valider',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      textAlign: TextAlign.center,
                      readOnly: true,
                      controller: _deliveredFlyersCountController,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.edit,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: '00',
                        hintStyle: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          fontSize: 20,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildDynamicFormFields(),
                  const SizedBox(height: 30),
                  Text(
                    'Tableau actuel : ' +
                        widget.distributionObject.distributed.toString() +
                        " / " +
                        widget.distributionObject.quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width / 2 - 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // Removes default padding
                            ),
                            onPressed: () async {
                              Navigator.pop(
                                context,
                              );
                            },
                            child: Text(
                              "Annuler",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width / 2 - 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // Removes default padding
                            ),
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    if (_formKey.currentState?.validate() ??
                                        false && _flyerImage != null) {
                                      setState(() {
                                        _isSubmitting = true;
                                      });
                                      final bool res =
                                          await _submitDeliveryInfo();
                                      if (res) {
                                        //_resetAll();
                                        // Navigator.pop(context, res);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to save delivery information')),
                                        );
                                      }
                                      setState(() {
                                        _isSubmitting = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please fill out all fields')),
                                      );
                                    }
                                  },
                            child: Text(
                              _isSubmitting
                                  ? "Téléchargement en cours..."
                                  : 'Sauvegarder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildDynamicFormFields() {
    List<Widget> formFields = [];

    if (widget.distributionObject.clientName == 1) {
      formFields.add(
          _buildTextField('Client Name', 'client_name', TextInputType.text));
    }
    if (widget.distributionObject.productName == 1) {
      formFields.add(
          _buildTextField('Product Name', 'product_name', TextInputType.text));
    }
    if (widget.distributionObject.phoneNumber == 1) {
      formFields.add(
          _buildTextField('Phone Number', 'phone_number', TextInputType.phone));
    }
    if (widget.distributionObject.sexe == 1) {
      formFields.add(_buildTextField('Sexe', 'sexe', TextInputType.text));
    }
    if (widget.distributionObject.email == 1) {
      formFields
          .add(_buildTextField('Email', 'email', TextInputType.emailAddress));
    }
    if (widget.distributionObject.city == 1) {
      formFields
          .add(_buildTextField('City', 'city', TextInputType.streetAddress));
    }
    if (widget.distributionObject.age == 1) {
      formFields.add(_buildTextField('Age', 'age', TextInputType.number));
    }
    if (widget.distributionObject.note == 1) {
      formFields.add(_buildTextField('Note', 'note', TextInputType.text));
    }

    return Center(
      child: Column(
        children: [
          ...formFields,
          Gap(60.h),
        ],
      ),
    );
  }

  Future _submitDeliveryInfo() async {
    final url = Uri.parse('$baseUrl/animateur/task/${widget.tasklocationid}');
    final url2 = Uri.parse(
        '$baseUrl/animateur/task/tasklocation/${widget.tasklocationid}/start');
    final url3 = Uri.parse(
        '$baseUrl/animateur/task/tasklocation/${widget.tasklocationid}/complete');
    if (_flyerImage == null || _deliveredFlyersCountController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Remplir tout les champs",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }
    print("************************************************");
    print(widget.distributionObject.distributed);
    print(widget.distributionObject.quantity);
    if (widget.distributionObject.distributed >=
        widget.distributionObject.quantity) {
      Fluttertoast.showToast(
        msg: "vouz avez fini la tahce",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }
    String? token = Prefs.getUserAccessToken();
    List<int> imageBytes = await _flyerImage!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(_deliveredFlyersCountController.text);
    final Map<String, dynamic> body = {
      "distribution_proof": "data:image/jpeg;base64," + base64Image,
      "distribution_object_id": widget.distributionObject.id,
      "quantity": _deliveredFlyersCountController.text,
      "client_name": _controllers['client_name']?.text ?? "",
      "sexe": _controllers['sexe']?.text ?? "",
      "city": _controllers['city']?.text ?? "",
      "age": _controllers['age']?.text ?? "",
      "note": _controllers['note']?.text ?? "",
      "product_name": _controllers['product_name']?.text ?? "",
      "email": _controllers['email']?.text ?? "",
      "phone_number": _controllers['phone_number']?.text ?? "",
      "latitude": position.latitude,
      "longitude": position.longitude,
    };
    print(body);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _isSubmitting = false;
        });
        Fluttertoast.showToast(
          msg: "bien distribué",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        //  _resetAll();
        final OngoingTaskProvider ongoingTaskProvider =
            Provider.of<OngoingTaskProvider>(context, listen: false);
        print("zzzzzzzzzzz");

        print(widget.distributionObject.distributed);
        print(_deliveredFlyersCountController.text);
        ongoingTaskProvider.changedistribution(
            int.parse(_deliveredFlyersCountController.text));

// Notify listeners to update all UIs

        if (widget.distributionObject.distributed == 0) {
          await http.post(
            url2,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            // body: json.encode(body),
          );
        } else if (widget.distributionObject.distributed +
                double.parse(_deliveredFlyersCountController.text) >
            widget.distributionObject.quantity) {
          await http.post(
            url3,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            // body: json.encode(body),
          );
        }
        widget.distributionObject.distributed +=
            int.parse(_deliveredFlyersCountController.text);
        setState(() {});
        return true;
      } else {
        Fluttertoast.showToast(
          msg: response.body.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          _isSubmitting = false;
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      print('Error: $e');
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw e;
    }
  }
}




















// class DeliveryInfoInputSheet extends StatefulWidget {
//   const DeliveryInfoInputSheet({super.key});

//   @override
//   State<DeliveryInfoInputSheet> createState() => _DeliveryInfoInputSheetState();
// }

// class _DeliveryInfoInputSheetState extends State<DeliveryInfoInputSheet> {
//   late TextEditingController _deliveredFlyersCountController;
//   File? _flyerImage;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _clientNameController = TextEditingController();
//   final TextEditingController _clientAddressController = TextEditingController();
//   final TextEditingController _clientPhoneController = TextEditingController();
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     _deliveredFlyersCountController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _deliveredFlyersCountController.dispose();
//     super.dispose();
//   }

//   Future<bool> _pickImage() async {
//     try {
//       final bool cameraAccessGranted = await serviceLocator<PermissionsService>().requestCameraPermission();
//       if (cameraAccessGranted) {
//         final ImagePicker _picker = ImagePicker();
//         final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//         if (image != null) {
//           setState(() {
//             _flyerImage = File(image.path);
//           });
//           return true;
//         } else {
//           throw 'No image picked (null)';
//         }
//       }
//     } catch (e) {
//       MyLogger.error('Error picking image: ${e.toString()}');
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildInputFields(context);
//   }

//   Widget _buildInputFields(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 23.h),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Enregistrez une livraison de Flyer',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Gap(31.h),
//             Container(
//               height: 141.h,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20.r),
//                 border: DashedBorder.fromBorderSide(
//                   dashLength: 15.sp,
//                   side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//                 ),
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(20.r),
//                 child: InkWell(
//                   splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//                   highlightColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20.r),
//                   onTap: () {
//                     HapticFeedback.lightImpact();
//                     _pickImage();
//                   },
//                   child: _flyerImage != null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(20.r),
//                           child: Image(
//                             image: FileImage(_flyerImage!),
//                             fit: BoxFit.cover,
//                             alignment: Alignment.center,
//                           ),
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.camera_alt,
//                               color: Theme.of(context).primaryColor,
//                               size: 40.sp,
//                             ),
//                             Gap(10.h),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20.w),
//                               child: Text(
//                                 "Prenez une photo de l'article du flyer que vous êtes sur le point de livrer",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontSize: 15.sp,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//             ),
//             Gap(35.h),
//             Text(
//               'Nombre de flyers livrés',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Gap(10.h),
//             SizedBox(
//               width: 80.w,
//               height: 45.h,
//               child: TextField(
//                 keyboardType: TextInputType.number,
//                 onTap: () {
//                   HapticFeedback.lightImpact();
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         title: Text(
//                           'Entrez le nombre de flyers livrés',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         content: TextField(
//                           controller: _deliveredFlyersCountController,
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 20.sp,
//                             fontFamily: 'Lato',
//                             fontWeight: FontWeight.w600,
//                           ),
//                           decoration: InputDecoration(
//                             hintText: '00',
//                             hintStyle: TextStyle(
//                               color: Theme.of(context).primaryColor.withOpacity(0.4),
//                               fontSize: 20.sp,
//                               fontFamily: 'Lato',
//                               fontWeight: FontWeight.w600,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                               borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                               borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                               borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
//                             ),
//                           ),
//                         ),
//                         actionsAlignment: MainAxisAlignment.center,
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text(
//                               'Valider',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 textAlign: TextAlign.center,
//                 readOnly: true,
//                 controller: _deliveredFlyersCountController,
//                 style: TextStyle(
//                   color: Theme.of(context).primaryColor,
//                   fontSize: 20.sp,
//                   fontFamily: 'Lato',
//                   fontWeight: FontWeight.w600,
//                 ),
//                 decoration: InputDecoration(
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     size: 14.sp,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   hintText: '00',
//                   hintStyle: TextStyle(
//                     color: Theme.of(context).primaryColor.withOpacity(0.4),
//                     fontSize: 20.sp,
//                     fontFamily: 'Lato',
//                     fontWeight: FontWeight.w600,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
//                   ),
//                 ),
//               ),
//             ),
//             Gap(30.h),
//             _buildClientForm(),
//             Gap(60.h),
//             SizedBox(
//               height: 45.h,
//               width: MediaQuery.of(context).size.width,
//               child: ElevatedButton(
//                 onPressed: _isSubmitting
//                     ? null
//                     : () async {
//                         //submit delivery info
//                         if (_deliveredFlyersCountController.text.isNotEmpty && _flyerImage != null) {
//                           final TargetLocation? location = context.read<MapViewStateProvider>().selectedTargetLocation;
//                           if (location == null) {
//                             FuncHelpers.showToastNotification(title: 'Veuillez sélectionner une adresse de livraison', notiType: ToastificationType.warning);
//                             return;
//                           }
//                           setState(() {
//                             _isSubmitting = true;
//                           });
//                           Map<String, dynamic> deliveryData = {
//                             'flyerImage': _flyerImage,
//                             'deliveredFlyersCount': _deliveredFlyersCountController.text,
//                           };
//                           final bool res = await context.read<OngoingTaskProvider>().markDeliveryAsDone(location, deliveryData);

//                           MyLogger.info('Task marked as done: $res');
//                           if (res) {
//                             context.read<MapViewStateProvider>().markTargetLocationAsCompleted(location);
//                             if (context.read<OngoingTaskProvider>().currentTask!.isCompleted) {
//                               context.read<TasksProvider>().markTaskAsCompleted(context.read<OngoingTaskProvider>().currentTask!);
//                             }
//                           }
//                           setState(() {
//                             _isSubmitting = false;
//                           });
//                           Navigator.pop(context, res);
//                         } else {
//                           FuncHelpers.showToastNotification(title: 'Veuillez remplir tous les champs', notiType: ToastificationType.warning);
//                         }
//                       },
//                 child: Text(
//                   _isSubmitting ? "Téléchargement en cours..." : 'sauvegarder',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildClientForm() {
//     return Column(
//       children: [
//         Text(
//           'Ajouter les informations du client',
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         Gap(20.h),
//         ClientForm(
//           formKey: _formKey,
//           nameController: _clientNameController,
//           addressController: _clientAddressController,
//           phoneController: _clientPhoneController,
//         ),
//       ],
//     );
//   }
// }
