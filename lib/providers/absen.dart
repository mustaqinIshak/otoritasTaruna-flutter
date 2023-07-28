import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/http_exception.dart';
import 'dart:convert';

class AbsenAple {
  final String hari;
  final String absen;

  const AbsenAple({
    required this.hari,
    required this.absen,
  });
}

class AbsenKuliah {
  final String matakuliah;
  final List<Map> data;

  const AbsenKuliah({
    required this.matakuliah,
    required this.data,
  });
}

class Absen with ChangeNotifier {
  List<AbsenAple> _itemAbsenAple = [];
  List<AbsenKuliah> _itemAbsenKuliah = [
    // AbsenKuliah(
    //   matakuliah: "BAHASA INGGRIS MARITIM",
    //   data: [
    //     {
    //       "tanggal": "2020-10-08T17:00:00.000Z",
    //       "nomor": 4558,
    //       "matakuliah": "BAHASA INGGRIS MARITIM",
    //       "pertemuan": 1,
    //       "status": "H",
    //       "semester": 1
    //     },
    //     {
    //       "tanggal": "2020-10-15T17:00:00.000Z",
    //       "nomor": 4558,
    //       "matakuliah": "BAHASA INGGRIS MARITIM",
    //       "pertemuan": 2,
    //       "status": "H",
    //       "semester": 1
    //     },
    //     {
    //       "tanggal": "2020-10-22T17:00:00.000Z",
    //       "nomor": 4558,
    //       "matakuliah": "BAHASA INGGRIS MARITIM",
    //       "pertemuan": 14,
    //       "status": "H",
    //       "semester": 1
    //     },
    //   ],
    // )
  ];
  late String _perwiraKompi = "belum ada";

  List<AbsenAple> get itemAbsenAple {
    return [..._itemAbsenAple];
  }

  List<AbsenKuliah> get itemAbsenKuliah {
    return [..._itemAbsenKuliah];
  }

  String get perwiraKompi {
    return _perwiraKompi;
  }

  Future<void> fetchAbsenAple(DateTime tanggal) async {
    // final url = Uri.parse('${Config().urlDev}absensiAple/getAbsensiAple');
    final url = Uri.parse('${Config().urlDevLive}absensiAple/getAbsensiAple');
    try {
      final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
      final String formated = formatTanggal.format(tanggal);
      print(formated);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      print(userData);
      final response = await http.post(url,
          headers: Config().header(userData["token"]),
          body: jsonEncode({"tanggal": formated as String}));
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode >= 400) {
        print('ini d error fetchAbsenAple ${responseData}');
        throw HttpException(responseData["message"]);
      }
      final List<AbsenAple> loadedData = [];
      final data = responseData["data"];
      data.keys.forEach((element) => element != "perwiraKompi"
          ? loadedData.add(AbsenAple(hari: element, absen: data[element]))
          : null);
      print(loadedData);
      _itemAbsenAple = loadedData;
      _perwiraKompi = data["perwiraKompi"];
      notifyListeners();
    } catch (e) {
      print('ini d error fetchAbsenAple ${e}');
      throw e;
    }
  }

  Future<void> fetchAbsenKuliah(int tahun, String semester) async {
    // final url = Uri.parse('${Config().urlDev}absenKuliah/getAbsensKuliah');
    final url = Uri.parse('${Config().urlDevLive}absenKuliah/getAbsensKuliah');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      print(userData);
      final response = await http.post(url,
          headers: Config().header(userData["token"]),
          body: json.encode({
            "tahun": tahun,
            "semester": semester == "Ganjil" ? 1 : 2,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode >= 400) {
        print('ini d error fetchAbsenKuliah ${responseData}');
        throw HttpException(responseData["message"]);
      }

      if (responseData["status"] == true) {
        final List<AbsenKuliah> loadedData = [];
        final data = responseData["data"];
        data.forEach((element) {
          // print(element["data"].runtimeType);

          List<dynamic> dynamicList =
              element["data"]; // Your original List<dynamic>
          List<Map<dynamic, dynamic>> mapList = dynamicList.map((item) {
            return item as Map<dynamic, dynamic>;
          }).toList();
          loadedData.add(AbsenKuliah(
            matakuliah: element["matakuliah"],
            // data: mapList as List<Map<dynamic, dynamic>>)
            data: mapList,
          ));
        });
        _itemAbsenKuliah = loadedData;
      } else {
        _itemAbsenKuliah = [];
      }

      notifyListeners();
    } catch (e) {
      print('ini d error fetchAbsenKuliah ${e}');
      throw e;
    }
  }
}
