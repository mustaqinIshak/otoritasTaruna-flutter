import 'package:flutter/material.dart';
import '../model/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';

class NilaiTaruna {
  final String? matakuliah;
  final String? jenis;
  final String? dosen;
  final String? nilai;

  NilaiTaruna(
      {required this.matakuliah,
      required this.jenis,
      required this.dosen,
      required this.nilai});
}

class Nilai with ChangeNotifier {
  List<NilaiTaruna> _nilai = [];

  List<NilaiTaruna> get nilai {
    return [..._nilai];
  }

  Future<void> fetchNilaiMatakuliahTaruna(int tahun, String semester) async {
    // final url = Uri.parse('${Config().urlDev}nilaiMataKuliahTaruna/getNilaiMatakuliah');
    final url = Uri.parse(
        '${Config().urlDevLive}nilaiMataKuliahTaruna/getNilaiMatakuliah');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      print("${userData}");
      final response = await http.post(url,
          headers: Config().header(userData["token"]),
          body: jsonEncode({
            "tahun": tahun,
            "semester": semester == "Ganjil" ? 1 : 2,
          }));
      final responseData = json.decode(response.body);
      print("ini response di nilai taruna ${responseData}");
      if (response.statusCode >= 400) {
        print('ini d error fetchAbsenAple ${responseData}');
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == true) {
        final List<NilaiTaruna> loadedData = [];
        final data = responseData["data"] as List;
        data.forEach((element) {
          loadedData.add(
            NilaiTaruna(
                matakuliah: element["matakuliah"],
                jenis: element["matakuliahJenis"],
                dosen: element["dosen"],
                nilai: element["nilai"] == null ? "-" : element["nilai"]),
          );
        });
        _nilai = loadedData;
      } else {
        _nilai = [];
      }
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
