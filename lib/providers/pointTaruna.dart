import 'package:flutter/material.dart';
import 'package:otoritas_taruna_client/providers/dashboard.dart';
import '../model/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';

class PointPrestasi {
  final String kegiatan;
  final String tanggal;
  final String point;

  const PointPrestasi({
    required this.kegiatan,
    required this.tanggal,
    required this.point,
  });
}

class PointPelanggaran {
  final String kegiatan;
  final String tanggal;
  final String point;

  const PointPelanggaran({
    required this.kegiatan,
    required this.point,
    required this.tanggal,
  });
}

class PointTaruna with ChangeNotifier {
  List<PointPrestasi> _pointPrestasi = [];
  List<PointPelanggaran> _pointPelanggaran = [];
  String? _jumlahPointPelanggaran;
  String? _jumlahPointPrestasi;

  List<PointPrestasi> get pointPrestasi {
    return [..._pointPrestasi];
  }

  List<PointPelanggaran> get pointPelanggaran {
    return [..._pointPelanggaran];
  }

  Future<void> fetchPointPelanggaran() async {
    // final url = Uri.parse('${Config().urlDev}pointTaruna/getPointPelanggaran');
    final url =
        Uri.parse('${Config().urlDevLive}pointTaruna/getPointPelanggaran');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        print('ini error d fecthPointPelanggaran ${responseData['error']}');
        throw HttpException(responseData['error']["name"]);
      }
      if (responseData["status"] == true) {
        final data = responseData["data"];
        print(responseData);
        print("ini totalPointPrestasi ${responseData["totalPelanggaran"]}");
        _jumlahPointPelanggaran = responseData["totalPelanggaran"].toString();
        final List<PointPelanggaran> loadedData = [];
        data.forEach((element) {
          loadedData.add(
            PointPelanggaran(
              kegiatan: element["pelanggaran"].toString(),
              tanggal: element["tanggal"].toString(),
              point: element["point"].toString(),
            ),
          );
        });
        _pointPelanggaran = loadedData;
      } else {
        _jumlahPointPelanggaran = "0";
        _pointPelanggaran = [];
      }
      notifyListeners();
      // print('ini response fetchPointPrestasi ${responseData["data"] as List}');
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchPointPrestasi() async {
    // final url = Uri.parse('${Config().urlDev}pointTaruna/getPointPrestasi');
    final url = Uri.parse('${Config().urlDevLive}pointTaruna/getPointPrestasi');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        print('ini error d fecthPointPrestasi ${responseData['error']}');
        throw HttpException(responseData['error']["name"]);
      }
      if (responseData["status"] == true) {
        final data = responseData["data"];
        print(responseData);
        print("ini totalPointPrestasi ${responseData["totalPrestasi"]}");
        _jumlahPointPrestasi = responseData["totalPrestasi"].toString();
        final List<PointPrestasi> loadedData = [];
        data.forEach((element) {
          loadedData.add(
            PointPrestasi(
              kegiatan: element["prestasi"].toString(),
              tanggal: element["tanggal"].toString(),
              point: element["point"].toString(),
            ),
          );
        });
        _pointPrestasi = loadedData;
      } else {
        _jumlahPointPrestasi = "0";
        _pointPrestasi = [];
      }
      notifyListeners();
      // print('ini response fetchPointPrestasi ${responseData["data"] as List}');
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
