import '../model/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';

class JadwalmataKuliah {
  String hari;
  String jam;
  String namaMatakuliah;
  String dosen;
  String kelas;

  JadwalmataKuliah({
    required this.hari,
    required this.jam,
    required this.namaMatakuliah,
    required this.dosen,
    required this.kelas,
  });
}

class Jadwal with ChangeNotifier {
  List<String> _hari = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu"
  ];

  List<JadwalmataKuliah> _jadwalMatakuliah = [];

  List get listJadwalMatakuliah {
    return [..._jadwalMatakuliah];
  }

  List<String> get hari {
    return [..._hari];
  }

  List jadwalMatakuliah(String hari) {
    return _jadwalMatakuliah.where((element) => element.hari == hari).toList();
  }

  Future<void> fetchJadwalPerkuliahan(int tahun, String semester) async {
    // final url = Uri.parse('${Config().urlDev}jadwalPerkuliahan/getJadwal');
    final url = Uri.parse('${Config().urlDevLive}jadwalPerkuliahan/getJadwal');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      final response = await http.post(url,
          headers: Config().header(userData["token"]),
          body: jsonEncode({
            "tahun": tahun,
            "semester": semester == "Ganjil" ? 1 : 2,
          }));
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        print('ini d error fetchAbsenAple ${responseData}');
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == true) {
        final List<JadwalmataKuliah> loadedData = [];
        final data = responseData["data"] as List;
        data.forEach((element) {
          loadedData.add(
            JadwalmataKuliah(
              hari: element["hari"],
              jam: "${element["jamMulai"]} - ${element["jamSelesai"]}",
              namaMatakuliah: element["matakuliah"],
              dosen: element["dosen"],
              kelas: element["kelas"].toString(),
            ),
          );
        });
        _jadwalMatakuliah = loadedData;
      } else {
        _jadwalMatakuliah = [];
      }
      print(responseData["status"]);
      print(responseData["data"]);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
