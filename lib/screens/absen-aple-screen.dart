import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/card-absen-aple.dart';
import '../providers/absen.dart';
import '../model/http_exception.dart';
import '../providers/auth.dart';
import '../screens/auth-screen.dart';

class AbsenApleScreen extends StatefulWidget {
  const AbsenApleScreen({super.key});

  @override
  State<AbsenApleScreen> createState() => _AbsenApleScreenState();
}

class _AbsenApleScreenState extends State<AbsenApleScreen> {
  bool _isInit = true;
  DateTime? date = DateTime.now();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      fetchAbsenAple().then(
        (_) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    _isInit = false;
    super.didChangeDependencies();
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

  Future<void> fetchAbsenAple() async {
    try {
      print("jalan absen aple");
      await Provider.of<Absen>(context, listen: false).fetchAbsenAple(date!);
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
    final perwiraKompi =
        Provider.of<Absen>(context, listen: true).perwiraKompi.toString();
    final List<AbsenAple> data =
        Provider.of<Absen>(context, listen: true).itemAbsenAple;
    List<Widget> absenApleWidget = [];
    for (int i = 0; i < data.length; i++) {
      absenApleWidget.add(CardAbsenAple(
          jam: data[i].hari as String, absen: data[i].absen as String));
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25.0),
          width: double.infinity,
          height: double.maxFinite,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                alignment: Alignment.topLeft,
                child: Text(
                  "Tanggal",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              Container(
                width: double.maxFinite,
                child: OutlinedButton(
                  style: ButtonStyle(),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date!,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    setState(() {
                      date = newDate;
                      fetchAbsenAple();
                    });
                  },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${date!.day}/${date!.month}/${date!.year}",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 76, 138),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Nama perwira kompi: ${perwiraKompi}'),
                            SizedBox(
                              height: 20,
                            ),
                            for (int i = 0; i < data.length; i++) ...[
                              CardAbsenAple(
                                  jam: data[i].hari as String,
                                  absen: data[i].absen as String)
                            ]

                            //Colom card absen aple
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
