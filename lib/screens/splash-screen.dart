import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/auth-screen.dart';
import '../providers/auth.dart';
import '../screens/navigation-screen.dart';
import '../providers/auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   //remove android navigation bottom bar
  //   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  //   Timer(Duration(seconds: 2), () {
  //     Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
  //       if (value) {
  //         navigationNext(const NavigationScreen());
  //       } else {
  //         navigationNext(const AuthScreen());
  //       }
  //     });
  //   });
  //   super.initState();
  // }

  // void navigationNext(Widget next) {
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => next),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    //   return Scaffold(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     body: Center(
    //       child: Container(
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Container(
    //               child: Image(
    //                 image: AssetImage('assets/images/logo.png'),
    //                 width: 50,
    //               ),
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(left: 10),
    //               child: Text('Navicampus',
    //                   style: TextStyle(
    //                     fontFamily: 'Poppins',
    //                     fontWeight: FontWeight.w900,
    //                     fontSize: 30,
    //                     color: Colors.white,
    //                   )),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
  }
}
