import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/auth-screen.dart';
import './screens/splash-screen.dart';
import './providers/dashboard.dart';
import './screens/nilai-screen.dart';
import './providers/auth.dart';
import './providers/jadwal.dart';
import './screens/navigation-screen.dart';
import './providers/nilai.dart';
import './providers/absen.dart';
import './screens/absen-screen.dart';
import './providers/navigation.dart';
import './providers/pointTaruna.dart';
import './providers/profile.dart';
import './screens/pointTaruna-screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Navigation(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Dashboard(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Jadwal(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Nilai(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Absen(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PointTaruna(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileUser(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            primaryColor: const Color.fromARGB(255, 0, 76, 138),
            // useMaterial3: true,
          ),
          home:
              // SplashScreen(),
              authData.isAuth
                  ? NavigationScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                      // : OtpScreen(),
                    ),
          routes: {
            // OtpScreen.routeName: (ctx) => OtpScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            NavigationScreen.routeName: (ctx) => NavigationScreen(),
            // HomeScreen.routeName: (ctx) => HomeScreen(),
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
