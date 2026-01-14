import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/constants.dart';
import 'package:actitrack/src/config/constants/palette.dart';
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/services/permissions/permissions_service.dart';
import 'package:actitrack/src/services/service_locator.dart';
import 'package:actitrack/src/state/providers/auth_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart' as anido;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'local_widgets/olive_curved_rect_painter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _pinCodetTextEditingController;
  late FocusNode _focusNode;
  late StreamController<ErrorAnimationType> _errorController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int _digitsCount = 8;
  String? _errorText;
  String? _successText;
  bool _textObsecure = true;

  requestResourcesPermissions() async {
    // check for permission
    await serviceLocator<PermissionsService>().requestCameraPermission();
    await serviceLocator<PermissionsService>().requestStoragePermission();
    await serviceLocator<PermissionsService>().requestLocationPermission();
  }

  @override
  void initState() {
    super.initState();
    _pinCodetTextEditingController = TextEditingController();
    _pinCodetTextEditingController.text = "TG";
    _focusNode = FocusNode();
    _errorController = StreamController<ErrorAnimationType>();
    requestResourcesPermissions();
  }

  @override
  void dispose() {
    _pinCodetTextEditingController.dispose();
    _focusNode.dispose();
    _errorController.close();
    super.dispose();
  }

  _onSubmit(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        _resetAll();
        final String passcode = _pinCodetTextEditingController.text.trim();
        bool res =
            await context.read<AuthProvider>().authenticateUser(passcode);
        if (_focusNode.hasFocus) _focusNode.unfocus();
        if (res) {
          Prefs.setPassCode(passcode);
          _showSuccess("Validation Réussie!");
          Future.delayed(const Duration(milliseconds: 800), () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(kHomeRoute, (route) => false);
            });
            // Navigator.of(context).pushReplacementNamed(kHomeRoute);
            context.read<AuthProvider>().isAuthenticated = true;
            Navigator.pushNamed(context, kHomeRoute);
          });
        } else {
          _showError("Code Invalide!");
        }
      }
    } catch (e) {
      MyLogger.error(e);
      _showError("Erreur Inconnue!");
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(kHomeRoute, (route) => false);
      });
      // Navigator.of(context).pushReplacementNamed(kHomeRoute);
      context.read<AuthProvider>().isAuthenticated = true;
    });
  }

  _showError(String errorText) {
    FuncHelpers.errorVibrate();
    _errorController.add(ErrorAnimationType.shake);
    setState(() => _errorText = errorText);
  }

  _clearError() {
    if (_errorText != null) {
      _errorController.add(ErrorAnimationType.clear);
      setState(() => _errorText = null);
    }
  }

  _showSuccess(String successText) {
    _clearError();
    setState(() => _successText = successText);
  }

  _resetAll() {
    _clearError();
    if (_successText != null) setState(() => _successText = null);
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: OliveCurvedRectanglePainter(
                  bgColor: const Color(0xFFF5F5F5),
                ),
                child: SizedBox(
                  height: 138.h,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Column(
              children: [
                if (!isKeyboardVisible) const Spacer(flex: 2),
                if (!isKeyboardVisible)
                  SafeArea(
                    child: Text(
                      "ActiTrack",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                          ),
                    ),
                    // child: Opacity(
                    //   opacity: 0.38,
                    //   child: Image.asset(
                    //     Assets.kPng_Logo,
                    //     height: 30.h,
                    //   ),
                    // ),
                  ),
                const Spacer(),
                Consumer<AuthProvider>(
                  builder: (context, authStateProvider, _) {
                    return SafeArea(
                      child: anido.SlideInUp(
                        child: Card(
                          margin: EdgeInsets.fromLTRB(
                              20.w, 0, 20.w, isKeyboardVisible ? 0 : 60.h),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 36.h),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Image.asset(Assets.kPng_Authentication, width: 50.w, height: 50.w),
                                  SvgPicture.asset(
                                    Assets.kSvg_Authentication,
                                    width: 50.w,
                                    height: 50.w,
                                  ),
                                  Gap(15.h),
                                  Text(
                                    "Entrez votre code d'authentification",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 17.sp,
                                        ),
                                  ),
                                  Gap((isKeyboardVisible ? 30 : 60).h),
                                  // const Spacer(),
                                  if (_errorText != null ||
                                      _successText != null)
                                    _buildFeedbackTextWidget(),
                                  PinCodeTextField(
                                    controller: _pinCodetTextEditingController,
                                    // keyboardType: TextInputType.visiblePassword,
                                    showCursor: true,
                                    blinkWhenObscuring: false,
                                    autoDisposeControllers: false,
                                    focusNode: _focusNode,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    readOnly:
                                        authStateProvider.isAuthenticating,
                                    length: _digitsCount,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    obscureText: _textObsecure,
                                    animationType: AnimationType.fade,
                                    backgroundColor: Colors.transparent,
                                    errorAnimationController: _errorController,
                                    enablePinAutofill: false,
                                    hapticFeedbackTypes:
                                        HapticFeedbackTypes.medium,
                                    useHapticFeedback: true,
                                    textStyle: TextStyle(
                                      color: _errorText != null
                                          ? kErrorColor
                                          : _successText != null
                                              ? kSuccessColor
                                              : Theme.of(context).primaryColor,
                                    ),
                                    cursorColor: Theme.of(context).primaryColor,
                                    cursorHeight: 18.h,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(6.r),
                                      fieldHeight: 40.h,
                                      fieldWidth: 28.99.w,
                                      activeFillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.05),
                                      inactiveFillColor:
                                          const Color(0xFFF5F5F5),
                                      errorBorderColor: kErrorColor,
                                      selectedColor:
                                          Theme.of(context).primaryColor,
                                      inactiveColor: _successText != null
                                          ? kSuccessColor
                                          : Theme.of(context).primaryColor,
                                      disabledColor:
                                          Theme.of(context).primaryColor,
                                      selectedFillColor: Colors.white,
                                      disabledBorderWidth: 1.w,
                                      inactiveBorderWidth: 1.w,
                                      activeBorderWidth: 1.w,
                                      selectedBorderWidth: 1.w,
                                      borderWidth: 1.w,
                                      activeColor: _successText != null
                                          ? kSuccessColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                    ),
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    // backgroundColor: Colors.blue.shade50,
                                    enableActiveFill: true,

                                    // errorAnimationController: errorController,
                                    // onCompleted: (v) {
                                    //   print("Completed");
                                    // },
                                    // onChanged: (value) {
                                    //   print(value);
                                    // setState(() {
                                    //   currentText = value;
                                    // });
                                    // },
                                    onChanged: (val) {},
                                    onTap: () {
                                      _clearError();
                                    },
                                    validator: (String? text) {
                                      if (text == null || text.isEmpty) {
                                        _showError("Code Requis!");
                                        return '';
                                      }
                                      if (text.length != _digitsCount) {
                                        _showError(
                                            "$_digitsCount caractères est le minimum");
                                        return '';
                                      }
                                      return null;
                                    },
                                    // beforeTextPaste: (text) {
                                    //   print("Allowing to paste $text");
                                    //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    //   return true;
                                    // },
                                    appContext: context,
                                  ),
                                  Text(
                                    "Saisissez le code à 8 caractères qui vous a été remis par votre superviseur",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.6299999952316284),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  Gap(10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                        label: Text(
                                          _textObsecure
                                              ? "afficher le code"
                                              : "masquer le code",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        icon: Icon(
                                          _textObsecure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 16.sp,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _textObsecure = !_textObsecure;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Gap((isKeyboardVisible ? 30 : 90).h),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed:
                                          /*(authStateProvider.isAuthenticating ||
                                                  _successText != null)
                                              ? null
                                              :*/
                                          () => _onSubmit(context),
                                      child: Text(
                                        (authStateProvider.isAuthenticating ||
                                                _successText != null)
                                            ? "Validation en cours..."
                                            : "Commencer",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackTextWidget() {
    bool isError = _errorText != null;
    bool isSuccess = _successText != null;
    return anido.ElasticIn(
      duration: Duration(milliseconds: 350),
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSuccess) SvgPicture.asset(Assets.kSvg_Success, width: 15.w),
            if (isError) SvgPicture.asset(Assets.kSvg_Error, width: 15.w),
            Gap(4.w),
            Text(
              isSuccess
                  ? _successText!
                  : isError
                      ? _errorText!
                      : '',
              style: TextStyle(
                color: isError
                    ? kErrorColor
                    : isSuccess
                        ? kSuccessColor
                        : null,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
