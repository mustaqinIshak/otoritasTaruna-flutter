import 'package:flutter/material.dart';
import '../model/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';

class Prestasi {
  final String kegiatan;
  final String tanggal;
  final String point;

  const Prestasi({
    required this.kegiatan,
    required this.tanggal,
    required this.point,
  });
}

class Pelanggaran {
  final String pelanggaran;
  final String tanggal;
  final String point;

  const Pelanggaran({
    required this.pelanggaran,
    required this.point,
    required this.tanggal,
  });
}

class Profile {
  String? nama;
  String? semester;
  String? kelas;
  String? jurusan;

  Profile({
    required this.nama,
    required this.semester,
    required this.kelas,
    required this.jurusan,
  });

  // String get namaProfile {
  //   return nama;
  // }

  // String get semesterProfile {
  //   return semester;
  // }

  // String get kelasProfile {
  //   return kelas;
  // }

  // String get jurusanProfile {
  //   return jurusan;
  // }
}

class Dashboard with ChangeNotifier {
  List<Prestasi> _pointPrestasi = [];
  List<Pelanggaran> _pointPelanggaran = [];
  int? _totalPointPelanggaran = 0;
  int? _totalPointPrestasi = 0;
  late Profile _userProfile;

  List<Prestasi> get pointPrestasi {
    return [..._pointPrestasi];
  }

  List<Pelanggaran> get pointPelanggaran {
    return [..._pointPelanggaran];
  }

  Profile get userProfile {
    return _userProfile;
  }

  int? get totalPointPrestasi {
    return _totalPointPrestasi;
  }

  int? get totalPointPelanggaran {
    return _totalPointPelanggaran;
  }

  Future<void> fetchUserProfile() async {
    // final url = Uri.parse('${Config().urlDev}dashboard/getProfileUser');
    final url = Uri.parse('${Config().urlDevLive}dashboard/getProfileUser');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      print("token ${userData["token"]}");
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
      );
      final responseData = json.decode(response.body);
      print("ini responseData userProfile ${responseData}");
      if (response.statusCode >= 400) {
        print('ini error 400 d fecthUserProfile ${responseData}');
        throw HttpException(responseData['error']["name"]);
      }
      final data = responseData["data"] as Map<String, dynamic>;

      _userProfile = Profile(
          nama: data["nama"],
          semester: data["semester"].toString(),
          kelas: data["kelas"],
          jurusan: data["jurusan"]);
      notifyListeners();
      // print(
      //     'ini response fetchPointPrestasi ${responseData["data"] as Map<String, dynamic>}');
    } catch (e) {
      print('ini d error fetchUserProfile ${e}');
      throw e;
    }
  }

  Future<void> fetchPointPrestasi() async {
    // final url = Uri.parse('${Config().urlDev}dashboard/getPointPrestasi');
    final url = Uri.parse('${Config().urlDevLive}dashboard/getPointPrestasi');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode >= 400) {
        print('ini error d fecthPrestasi ${responseData['error']}');
        throw HttpException(responseData['error']["name"]);
      }
      final data = responseData["data"];
      print("ini responseData Prestasi point ${responseData}");
      print("ini totalPointPrestasi ${responseData["totalPrestasi"]}");
      _totalPointPrestasi = responseData["totalPrestasi"] != null
          ? responseData["totalPrestasi"]
          : 0;
      final List<Prestasi> loadedData = [];
      data.forEach((element) {
        loadedData.add(
          Prestasi(
            kegiatan: element["prestasi"],
            tanggal: element["tanggal"],
            point: element["point"],
          ),
        );
      });
      _pointPrestasi = loadedData;
      notifyListeners();
      // print('ini response fetchPointPrestasi ${responseData["data"] as List}');
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchPointPelanggaran() async {
    // final url = Uri.parse('${Config().urlDev}dashboard/getPointPelanggaran');
    final url =
        Uri.parse('${Config().urlDevLive}dashboard/getPointPelanggaran');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        print(responseData['error']);
        throw HttpException(responseData['error']["name"]);
      }
      final data = responseData["data"];
      _totalPointPelanggaran = responseData["totalPelanggaran"] != null
          ? responseData["totalPelanggaran"]
          : 0;
      final List<Pelanggaran> loadedData = [];
      data.forEach((element) {
        loadedData.add(
          Pelanggaran(
            pelanggaran: element["pelanggaran"],
            point: element["point"],
            tanggal: element["tanggal"],
          ),
        );
      });
      _pointPelanggaran = loadedData;
      notifyListeners();
      print(
          'ini response fetchPointPelanggaran ${responseData["data"] as List}');
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
