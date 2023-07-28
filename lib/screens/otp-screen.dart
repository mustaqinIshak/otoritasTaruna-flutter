// import 'dart:async';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:otoritas_taruna_client/screens/home-screen.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth.dart';
// import '../model/http_exception.dart';

// class OtpScreen extends StatefulWidget {
//   static const routeName = '/otp';

//   final String? mobileNo;
//   final String? otpHash;
//   const OtpScreen({this.mobileNo, this.otpHash});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   String _otpCode = "";
//   final int _otpCodeLength = 4;
//   bool isApiCallProccess = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: VerifyOtpCard(),
//     );
//   }
// }

// class VerifyOtpCard extends StatefulWidget {
//   const VerifyOtpCard({super.key});

//   @override
//   State<VerifyOtpCard> createState() => _VerifyOtpCardState();
// }

// class _VerifyOtpCardState extends State<VerifyOtpCard> {
//   var onTapRecognizer;
//   TextEditingController textEditingController = TextEditingController();
//   StreamController<ErrorAnimationType>? errorController;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final formKey = GlobalKey<FormState>();
//   String? errorName = "";
//   bool hasError = false;
//   String currentText = "";
//   int timerStart = 60;
//   bool wait = true;
//   Timer? _timer;

//   void startTimer() {
//     const onsec = Duration(seconds: 1);
//     _timer = Timer.periodic(onsec, (timer) {
//       if (timerStart == 0) {
//         setState(() {
//           timer.cancel();
//           wait = false;
//         });
//       } else {
//         setState(() {
//           timerStart--;
//         });
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     onTapRecognizer = TapGestureRecognizer()
//       ..onTap = () {
//         Navigator.pop(context);
//       };
//     errorController = StreamController<ErrorAnimationType>();
//     startTimer();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void stopTimer() {
//     _timer?.cancel();
//     setState(() {
//       timerStart = 0;
//     });
//   }
//   // @override
//   // void dispose() {
//   //   // TODO: implement dispose
//   //   errorController!.close();
//   //   super.dispose();
//   // }

//   Future<void> verifyOtp() async {
//     try {
//       setState(() {
//         errorName = "";
//         hasError = false;
//       });
//       print(currentText);
//       await Provider.of<Auth>(context, listen: false)
//           .getToken(currentText, timerStart);
//       stopTimer();
//       if (Provider.of<Auth>(context, listen: false).isAuth) {
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (builder) => OtpScreen()));
//       }
//     } on HttpException catch (e) {
//       setState(() {
//         textEditingController.clear();
//         hasError = true;
//         errorName = e.toString();
//       });
//     } catch (e) {
//       setState(() {
//         textEditingController.clear();
//         hasError = true;
//       });
//       print('ini error d halaman otp screen ${e}');
//     }
//   }

//   Future<void> getOtp() async {
//     try {
//       print("get OTP ulang");
//       setState(() {
//         errorName = "";
//         hasError = false;
//         timerStart = 60;
//         wait = true;
//       });
//       startTimer();
//       await Provider.of<Auth>(context, listen: false).getReloadOtp();
//     } on HttpException catch (e) {
//       // var errorMessage = "Authentication failde";
//       // if (e.toString().contains('EMAIL_EXIST')) {
//       //   errorMessage = 'This email address already in use';
//       // } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
//       //   errorMessage = 'Email not foung';
//       // } else if (e.toString().contains('INVALID_EMAIL')) {
//       //   errorMessage = 'This is not valid a email addres';
//       // } else if (e.toString().contains('WEAK_PASSWORD')) {
//       //   errorMessage = 'This password is weak';
//       // } else if (e.toString().contains('INVALID_PASSWORD')) {
//       //   errorMessage = 'Invalid password';
//       // }

//       setState(() {
//         textEditingController.clear();
//         hasError = true;
//         errorName = e.toString();
//       });
//     } catch (e) {
//       setState(() {
//         textEditingController.clear();
//         hasError = true;
//       });
//       print('ini error d halaman otp screen ${e}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     Future<void> _submitOtp() async {}
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 50.0, top: 100),
//       child: Column(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 20,
//                   ),
//                   child: Text(
//                     "Kode OTP",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text('Periksa pesan masuk anda lewat Whatsapp!'),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                   child: PinCodeTextField(
//                     appContext: context,
//                     length: 4,
//                     // enableActiveFill: true,
//                     errorAnimationController: errorController,
//                     onChanged: (value) {
//                       setState(() {
//                         currentText = value;
//                       });
//                     },
//                     // onCompleted: (_) => verifyOtp(),
//                     //
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(5),
//                       fieldHeight: 50,
//                       fieldWidth: 40,
//                       activeFillColor: Colors.white,
//                     ),
//                     controller: textEditingController,
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Text(
//               hasError ? errorName.toString() : "",
//               style: TextStyle(
//                   color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50.0),
//             child: Column(children: [
//               Text('Tidak mendapatkan pesan masuk ?'),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: deviceSize.width * 0.75,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     padding: MaterialStateProperty.all(
//                       EdgeInsets.all(10),
//                     ),
//                     backgroundColor: MaterialStateColor.resolveWith(
//                         (states) => Theme.of(context).primaryColor),
//                   ),
//                   // onPressed: wait ? null : () => getOtp(),
//                   onPressed: () => verifyOtp(),
//                   child: Text(
//                     'Kirim ulang OTP',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text('Waktu mengirim dalam ${timerStart} detik'),
//               SizedBox(
//                 height: 15,
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pushReplacementNamed('/auth');
//                 },
//                 child: Text('kembali',
//                     style: TextStyle(color: Theme.of(context).primaryColor)),
//                 style: ButtonStyle(
//                   padding: MaterialStateProperty.all(
//                     EdgeInsets.all(0),
//                   ),
//                 ),
//               )
//             ]),
//           )
//         ],
//       ),
//     );
//   }
// }
