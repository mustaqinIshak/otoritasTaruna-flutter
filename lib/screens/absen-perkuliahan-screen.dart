import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/table-absen-perkuliahan.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../providers/absen.dart';
import '../model/http_exception.dart';
import '../providers/auth.dart';
import '../screens/auth-screen.dart';

class AbsenPerkuliahanScreen extends StatefulWidget {
  const AbsenPerkuliahanScreen({super.key});

  @override
  State<AbsenPerkuliahanScreen> createState() => _AbsenPerkuliahanScreenState();
}

class _AbsenPerkuliahanScreenState extends State<AbsenPerkuliahanScreen> {
  bool _isLoading = false;
  int _selectedYear = DateTime.now().year;
  String _selectedSemester = "Genap";
  int tahunMulai = 2013;
  List listyears = Iterable<int>.generate((DateTime.now().year) + 1)
      .skip(2013)
      .toList()
      .reversed
      .toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAbsenKuliah();
  }

  void changeYear(value) {
    setState(() {
      _selectedYear = value;
    });
    fetchAbsenKuliah();
  }

  void changeSemester(value) {
    setState(() {
      _selectedSemester = value;
    });
    fetchAbsenKuliah();
  }

  void _showErrorMessage(String errorMessage) {
    final logOut = Provider.of<Auth>(context).logOut;
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

  Future<void> fetchAbsenKuliah() async {
    try {
      print("jalan absen Kuliah");
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Absen>(context, listen: false).fetchAbsenKuliah(
        _selectedYear,
        _selectedSemester,
      );
      setState(() {
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
      print("ini error d absen Perkuliahan screen ${e}");
      var errorMessage = "Could not authenticate you, please try again later";
      _showErrorMessage(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<AbsenKuliah> item =
        Provider.of<Absen>(context, listen: true).itemAbsenKuliah;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25),
        width: double.infinity,
        height: double.maxFinite,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
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
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 20,
                // ),
                Expanded(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? Container(
                    width: double.maxFinite,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : item.length > 0
                    ? Expanded(
                        child: Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: TableAbsenPerkuliahan(absen: item),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          child: Text("Absen Akademik Tidak Ditemukan"),
                        ),
                      ),
          ],
        ),
      ),
    ));
  }
}
