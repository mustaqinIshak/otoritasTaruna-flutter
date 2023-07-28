import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/card-point-homeScreen-widget.dart';
import '../providers/dashboard.dart';
import '../screens/pointTaruna-screen.dart';

class PointPrestasiWidget extends StatefulWidget {
  final bool isLoading;
  const PointPrestasiWidget({super.key, required this.isLoading});

  @override
  State<PointPrestasiWidget> createState() => _PointPrestasiWidgetState();
}

class _PointPrestasiWidgetState extends State<PointPrestasiWidget> {
  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<Dashboard>(context, listen: true);
    final data = dashboard.pointPrestasi;
    final totalPointPrestasi = dashboard.totalPointPrestasi.toString();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: widget.isLoading
          ? CircularProgressIndicator()
          : Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 50),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${totalPointPrestasi} Point Prestasi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  data.length > 0
                      ? Container(
                          width: double.maxFinite,
                          height: 150,
                          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                CardPointHomeScreenWidget(
                              name: data[index].kegiatan,
                              tanggal: data[index].tanggal,
                              point: data[index].point,
                            ),
                            itemCount: data.length,
                          ))
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
                                                tipe: "Prestasi")),
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
