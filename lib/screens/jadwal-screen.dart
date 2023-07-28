import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../providers/jadwal.dart';
import '../widget/jadwal-item.dart';
import '../providers/auth.dart';
import '../model/http_exception.dart';
import '../screens/auth-screen.dart';

class Jadwalscreen extends StatefulWidget {
  const Jadwalscreen({super.key});

  @override
  State<Jadwalscreen> createState() => _JadwalscreenState();
}

class _JadwalscreenState extends State<Jadwalscreen> {
  int _selectedYear = DateTime.now().year;
  // int periode =  _selectedYear - 1;
  int? previousSelectedYear;
  String _selectedSemester = "Genap";
  String? previousSelectedSemester;
  int tahunMulai = 2013;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJadwalPerkuliahan();
  }

  void changeYear(value) {
    setState(() {
      _selectedYear = value;
    });
    getJadwalPerkuliahan();
  }

  void changeSemester(value) {
    setState(() {
      _selectedSemester = value;
    });
    getJadwalPerkuliahan();
  }

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

  List listyears = Iterable<int>.generate((DateTime.now().year) + 1)
      .skip(2013)
      .toList()
      .reversed
      .toList();

  Future<void> getJadwalPerkuliahan() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Jadwal>(context, listen: false)
          .fetchJadwalPerkuliahan(_selectedYear, _selectedSemester);
      setState(() {
        isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final hariJadwal = Provider.of<Jadwal>(context).hari;
    final item =
        Provider.of<Jadwal>(context, listen: true).listJadwalMatakuliah;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 76, 138),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getJadwalPerkuliahan,
          child: SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Text(
                          "Tahun Ajaran ${_selectedYear - 1}/${_selectedYear}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Semester ${_selectedSemester}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    child: DropdownSearch(
                                      items: listyears,
                                      popupProps: const PopupProps.dialog(
                                        constraints: BoxConstraints.expand(
                                          height: 200,
                                          width: 500,
                                        ),
                                      ),
                                      selectedItem: _selectedYear,
                                      onChanged: (value) {
                                        changeYear(value);
                                      },
                                      enabled: isLoading ? false : true,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    child: DropdownSearch(
                                      items: ["Ganjil", "Genap"],
                                      selectedItem: _selectedSemester,
                                      popupProps: const PopupProps.dialog(
                                        constraints: BoxConstraints.expand(
                                          height: 200,
                                          width: 500,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        changeSemester(value);
                                      },
                                      enabled: isLoading ? false : true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      color: Colors.white,
                      child: isLoading
                          ? Container(
                              width: double.maxFinite,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : item.length > 0
                              ? ListView.builder(
                                  itemCount: hariJadwal.length,
                                  itemBuilder: (ctx, i) {
                                    return JadwalItem(name: hariJadwal[i]);
                                  },
                                )
                              : Center(
                                  child: Container(
                                    child: Text("Tidak ada jadwal"),
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
  }
}
