import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/card-point-homeScreen-widget.dart';
import '../providers/dashboard.dart';
import '../screens/pointTaruna-screen.dart';

class PointPelanggaranWidget extends StatefulWidget {
  final bool isLoading;
  const PointPelanggaranWidget({super.key, required this.isLoading});

  @override
  State<PointPelanggaranWidget> createState() => _PointPelanggaranWidgetState();
}

class _PointPelanggaranWidgetState extends State<PointPelanggaranWidget> {
  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<Dashboard>(context, listen: true);
    final data = dashboard.pointPelanggaran;
    final totalPointPelanggaran = dashboard.totalPointPelanggaran.toString();
    return Padding(
      padding: EdgeInsets.all(10),
      child: widget.isLoading
          ? CircularProgressIndicator()
          : Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.dangerous, color: Colors.red, size: 50),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${totalPointPelanggaran} Point Pelanggaran",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  data.length > 0
                      ? Container(
                          width: double.maxFinite,
                          height: 150,
                          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                CardPointHomeScreenWidget(
                              name: data[index].pelanggaran,
                              tanggal: data[index].tanggal,
                              point: data[index].point,
                            ),
                            itemCount: data.length,
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  data.length > 0
                      ? Container(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const PointTarunaScreen(
                                                tipe: "Pelanggaran")),
                                  );
                                },
                                child: Text("Lihat semua prestasi"),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
    );
  }
}
