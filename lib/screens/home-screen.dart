import 'package:flutter/material.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:provider/provider.dart';
import '../widget/card-profil-taruna.dart';
import '../widget/poin-prestasi-widget.dart';
import '../widget/poin-pelanggaran-widget.dart';
import '../widget/menu-button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../model/http_exception.dart';
import '../providers/dashboard.dart';
import '../providers/navigation.dart';
import '../screens/auth-screen.dart';
import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  Profile userProfile =
      Profile(nama: null, semester: null, kelas: null, jurusan: null);
  bool _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    getDashboard();
    super.initState();
  }

  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     getDashboard();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  void _showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Terjadi Kesalahan'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
                Provider.of<Auth>(context, listen: false).logOut();
              },
              child: Text('Log Out'),
            )
          ],
        );
      },
    );
  }

  Future<void> getDashboard() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Dashboard>(context, listen: false).fetchUserProfile();
      await Provider.of<Dashboard>(context, listen: false).fetchPointPrestasi();
      await Provider.of<Dashboard>(context, listen: false)
          .fetchPointPelanggaran();
      setState(() {
        userProfile =
            Provider.of<Dashboard>(context, listen: false).userProfile;
        _isLoading = false;
      });
    } on HttpException catch (e) {
      var errorMessage = "Authentication failde";
      if (e.toString().contains('JsonWebTokenError')) {
        errorMessage = 'Tidak bisa mengidentifikasi anda, Silahkan login ulang';
      } else if (e.toString().contains('TokenExpiredError')) {
        errorMessage = 'Sesi anda telah habis, Silahkan login ulang';
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      print("ini error d pointPrestasi home ${e}");
      var errorMessage = "Could not authenticate you, please try again later";
      _showErrorMessage(errorMessage);
    }
  }

  // Future<void> getDashboardPointPelanggaran() async {
  //   try {
  //     setState(() {
  //       _isLoadingPointPelanggaran = true;
  //     });
  //     await Provider.of<Dashboard>(context, listen: false)
  //         .fetchPointPelanggaran();
  //     setState(() {
  //       _isLoadingPointPelanggaran = false;
  //     });
  //   } on HttpException catch (e) {
  //     var errorMessage = "Authentication failde";
  //     if (e.toString().contains('EMAIL_EXIST')) {
  //       errorMessage = 'This email address already in use';
  //     } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
  //       errorMessage = 'Email not foung';
  //     } else if (e.toString().contains('INVALID_EMAIL')) {
  //       errorMessage = 'This is not valid a email addres';
  //     } else if (e.toString().contains('WEAK_PASSWORD')) {
  //       errorMessage = 'This password is weak';
  //     } else if (e.toString().contains('INVALID_PASSWORD')) {
  //       errorMessage = 'Invalid password';
  //     }
  //   } catch (e) {
  //     print("ini error d pointPrestasi home ${e}");
  //     var errorMessage = "Could not authenticate you, please try again later";
  //     _showErrorMessage(errorMessage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    InputDecoration removeUnderline() {
      return const InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)));
    }

    void setNavigation(int index) {
      Provider.of<Navigation>(context, listen: false).setIndex(index);
    }

    final deviceSize = MediaQuery.of(context).size;
    final pointPrestasi =
        Provider.of<Dashboard>(context, listen: true).pointPrestasi;
    final pointPelanggaran =
        Provider.of<Dashboard>(context, listen: true).pointPelanggaran;

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 0, 76, 138),
      body: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    _isLoading
                        ? CircularProgressIndicator()
                        : CardProfilTaruna(
                            name: userProfile.nama,
                            kelas: userProfile.kelas,
                            jurusan: userProfile.jurusan,
                            semester: userProfile.semester,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MenuButton(
                            name: "Jadwal",
                            icon: Icon(
                              Icons.schedule_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            function: () {
                              setNavigation(1);
                            }),
                        MenuButton(
                          name: "Nilai",
                          icon: Icon(
                            Icons.star_half_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                          function: () {
                            setNavigation(2);
                          },
                        ),
                        MenuButton(
                          name: "Absen",
                          icon: Icon(
                            Icons.note_alt_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                          function: () {
                            setNavigation(3);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              pointPelanggaran.length == 0 && pointPrestasi.length == 0
                  ? Container(
                      // width: deviceSize.width,
                      // height: deviceSize.height,
                      child: Center(
                        child: Text("Tidak ada point pelanggaran/prestasi"),
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          PointPrestasiWidget(isLoading: _isLoading),
                          PointPelanggaranWidget(isLoading: _isLoading),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
