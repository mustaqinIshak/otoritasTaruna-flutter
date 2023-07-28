import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import '../providers/nilai.dart';
import '../model/http_exception.dart';
import '../screens/auth-screen.dart';
import '../providers/auth.dart';

class NilaiScreen extends StatefulWidget {
  const NilaiScreen({super.key});

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  int _selectedYear = DateTime.now().year;
  String _selectedSemester = "Genap";
  bool isLoading = false;
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
    fetchNilai();
  }

  void changeYear(value) {
    setState(() {
      _selectedYear = value;
    });
    fetchNilai();
  }

  void changeSemester(value) {
    setState(() {
      _selectedSemester = value;
    });
    fetchNilai();
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

  Future<void> fetchNilai() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Provider.of<Nilai>(context, listen: false)
          .fetchNilaiMatakuliahTaruna(_selectedYear, _selectedSemester);
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
    List<NilaiTaruna> nilaiTaruna = Provider.of<Nilai>(context).nilai;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 76, 138),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: deviceSize.height,
          child: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Nilai Akademik Taruna",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: isLoading
                    ? Container(
                        width: double.maxFinite,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : nilaiTaruna.length > 0
                        ? SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: _createDataTable(nilaiTaruna),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              child: Text("Belum ada nilai akademik"),
                            ),
                          ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

DataTable _createDataTable(List<NilaiTaruna> data) {
  return DataTable(
      border: TableBorder.all(
        width: 1.0,
        color: Colors.grey,
      ),
      columns: _createColumns(),
      rows: _createRows(data),
      headingRowColor: MaterialStateColor.resolveWith(
        (states) {
          return Color.fromARGB(255, 0, 76, 138);
        },
      ));
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(
      label: Text(
        "No",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "Matakuliah",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "Jenis",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "Dosen",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "Nilai",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];
}

List<DataRow> _createRows(List<NilaiTaruna> data) {
  int nomor = 0;
  return data.map((nilai) {
    nomor++;
    return DataRow(
      cells: [
        DataCell(Text("${nomor}")),
        DataCell(Text(nilai.matakuliah.toString())),
        DataCell(Text(nilai.jenis.toString())),
        DataCell(Text(nilai.dosen.toString())),
        DataCell(Text(nilai.nilai.toString())),
      ],
    );
  }).toList();
}
