import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../model/http_exception.dart';
import '../providers/auth.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../screens/navigation-screen.dart';

enum AuthMode { phoneNumber, otpValidation }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      // margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 50,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Navicampus',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    // flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String phoneNumber = '';
  bool enableButton = true;
  bool isApiCallProcess = false;
  String? errorName = "";
  String errorOtp = "";
  bool hasError = false;
  String currentText = "";
  int timerStart = 60;
  bool wait = true;
  Timer? _timer;
  AuthMode _authMode = AuthMode.phoneNumber;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumber = '';
  }

  // final _nomorHandphoneController = TextEditingController();
  var _isLoading = false;

  void _showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Maaf sepertinya ada masalah!'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Okay"),
            )
          ],
        );
      },
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    _timer = Timer.periodic(onsec, (timer) {
      if (timerStart == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          timerStart--;
        });
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
      enableButton = false;
      errorName = "";
    });
    try {
      if (_authMode == AuthMode.phoneNumber) {
        await Provider.of<Auth>(context, listen: false).getOtp(phoneNumber);
        if (Provider.of<Auth>(context, listen: false).isOtp) {
          _authMode = AuthMode.otpValidation;
          startTimer();
        }
      } else {
        await Provider.of<Auth>(context, listen: false)
            .getToken(timerStart.toString(), currentText);
        final bool? loginStatus =
            Provider.of<Auth>(context, listen: false).loginSuccess;
        if (loginStatus == true) {
          Navigator.of(context)
              .pushReplacementNamed(NavigationScreen.routeName);
        }
      }
    } on HttpException catch (e) {
      // var errorMessage = "Authentication failde";
      // if (e.toString().contains('EMAIL_EXIST')) {
      //   errorMessage = 'This email address already in use';
      // } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = 'Email not foung';
      // } else if (e.toString().contains('INVALID_EMAIL')) {
      //   errorMessage = 'This is not valid a email addres';
      // } else if (e.toString().contains('WEAK_PASSWORD')) {
      //   errorMessage = 'This password is weak';
      // } else if (e.toString().contains('INVALID_PASSWORD')) {
      //   errorMessage = 'Invalid password';
      // }

      setState(() {
        textEditingController.clear();
        hasError = true;
        errorName = e.toString();
      });
    } catch (e) {
      print('ini error d halaman auth screen ${e}');
      setState(() {
        textEditingController.clear();
        hasError = true;
        errorName = e.toString();
      });
    }
    setState(() {
      _isLoading = false;
      enableButton = true;
    });
  }

  Future<void> getOtp() async {
    try {
      print("get OTP ulang");
      setState(() {
        errorName = "";
        hasError = false;
        timerStart = 60;
        wait = true;
      });
      startTimer();
      await Provider.of<Auth>(context, listen: false).getReloadOtp();
    } on HttpException catch (e) {
      // var errorMessage = "Authentication failde";
      // if (e.toString().contains('EMAIL_EXIST')) {
      //   errorMessage = 'This email address already in use';
      // } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = 'Email not foung';
      // } else if (e.toString().contains('INVALID_EMAIL')) {
      //   errorMessage = 'This is not valid a email addres';
      // } else if (e.toString().contains('WEAK_PASSWORD')) {
      //   errorMessage = 'This password is weak';
      // } else if (e.toString().contains('INVALID_PASSWORD')) {
      //   errorMessage = 'Invalid password';
      // }

      setState(() {
        textEditingController.clear();
        hasError = true;
        errorName = e.toString();
      });
    } catch (e) {
      setState(() {
        textEditingController.clear();
        hasError = true;
      });
      print('ini error d halaman otp screen ${e}');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return _authMode == AuthMode.phoneNumber
        ? Container(
            height: 320,
            constraints: BoxConstraints(minHeight: 320),
            width: deviceSize.width * 0.75,
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nomor Handphone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Anda harus mengisi nomor handphone';
                        } else if (value.toString().length < 8) {
                          return 'Nomor Handphone maksimal 8 angka';
                        } else {
                          enableButton = true;
                        }
                      },
                      onSaved: (newValue) {
                        phoneNumber = newValue!;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Text(
                        hasError ? errorName.toString() : "",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      width: deviceSize.width * 0.75,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(10),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                        ),
                        onPressed: enableButton ? _submit : null,
                        child: _isLoading
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ))
                            : Text(
                                'Masuk',
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ),
                    Row(
                      children: [
                        Text("Lupa Password ?"),
                        TextButton(
                          onPressed: () {},
                          child: Text('kli disini',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.all(0),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: deviceSize.width * 0.3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.all(10),
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                            ),
                            onPressed: _submit,
                            child: new Icon(MdiIcons.google),
                          ),
                        ),
                        Container(
                          width: deviceSize.width * 0.3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.all(10),
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                            ),
                            onPressed: _submit,
                            child: new Icon(MdiIcons.facebook),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ))
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              "Kode OTP",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Periksa pesan masuk anda lewat Whatsapp!'),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              // enableActiveFill: true,
                              errorAnimationController: errorController,
                              onChanged: (value) {
                                setState(() {
                                  currentText = value;
                                });
                              },
                              onCompleted: (_) => _submit(),
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                              ),
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              hasError ? errorName.toString() : "",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Column(children: [
                        Text('Tidak mendapatkan pesan masuk ?'),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: deviceSize.width * 0.75,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.all(10),
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                            ),
                            onPressed: wait ? null : () => getOtp(),
                            // onPressed: () => _submit(),
                            child: Text(
                              'Kirim ulang OTP',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Waktu mengirim dalam ${timerStart} detik'),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/auth');
                          },
                          child: Text('kembali',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.all(0),
                            ),
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
