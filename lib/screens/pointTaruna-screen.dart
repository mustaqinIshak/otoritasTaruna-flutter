import 'package:flutter/material.dart';
import 'package:otoritas_taruna_client/providers/dashboard.dart';
import '../widget/card-point-homeScreen-widget.dart';
import 'package:provider/provider.dart';
import '../providers/pointTaruna.dart';
import '../model/http_exception.dart';
import '../screens/auth-screen.dart';
import '../providers/auth.dart';

class PointTarunaScreen extends StatefulWidget {
  static const routeName = '/pointTaruna';
  final String tipe;
  const PointTarunaScreen({super.key, required this.tipe});

  @override
  State<PointTarunaScreen> createState() => _PointTarunaScreenState();
}

class _PointTarunaScreenState extends State<PointTarunaScreen> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.tipe);
    fetchPointTaruna();
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

  Future<void> fetchPointTaruna() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.tipe == "Prestasi") {
        await Provider.of<PointTaruna>(context, listen: false)
            .fetchPointPrestasi();
      } else {
        await Provider.of<PointTaruna>(context, listen: false)
            .fetchPointPelanggaran();
      }
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
    List<PointPrestasi> prestasi =
        Provider.of<PointTaruna>(context, listen: false).pointPrestasi;
    List<PointPelanggaran> pelanggaran =
        Provider.of<PointTaruna>(context, listen: false).pointPelanggaran;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Point ${widget.tipe}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 76, 138),
      ),
      body: isLoading
          ? Container(
              width: double.maxFinite,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: widget.tipe == "Prestasi"
                    ? Column(
                        children: [
                          for (var i = 0; i < prestasi.length; i++)
                            CardPointHomeScreenWidget(
                              name: prestasi[i].kegiatan,
                              tanggal: prestasi[i].tanggal,
                              point: prestasi[i].point,
                            ),
                        ],
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < pelanggaran.length; i++)
                            CardPointHomeScreenWidget(
                              name: pelanggaran[i].kegiatan,
                              tanggal: pelanggaran[i].tanggal,
                              point: pelanggaran[i].point,
                            ),
                        ],
                      ),
              ),
            ),
    );
  }
}
