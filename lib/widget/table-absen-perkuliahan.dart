import 'package:flutter/material.dart';
import '../providers/absen.dart';

class TableAbsenPerkuliahan extends StatefulWidget {
  final List<AbsenKuliah>? absen;
  const TableAbsenPerkuliahan({required this.absen, super.key});

  @override
  State<TableAbsenPerkuliahan> createState() => _TableAbsenPerkuliahanState();
}

class _TableAbsenPerkuliahanState extends State<TableAbsenPerkuliahan> {
  final int jumlahHari = 10;
  @override
  Widget build(BuildContext context) {
    return _createDataTable(widget.absen);
  }
}

DataTable _createDataTable(List<AbsenKuliah>? data) {
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
    // for (var i = 0; i < jumlahHari; i++)
    DataColumn(
      label: Text(
        "1",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "2",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "3",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "4",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "5",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "6",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "7",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "8",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "9",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "10",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "11",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "12",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "13",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "14",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "15",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "16",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "17",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "18",
        style: TextStyle(color: Colors.white),
      ),
    ),
    DataColumn(
      label: Text(
        "%",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];
}

double calculatePercentage(int present, int total) {
  if (total == 0) {
    return 0.0;
  }
  print("${present} / ${total} = ${present / total}");
  double percentage = (present / total) * 100;
  return percentage;
}

List<DataRow> _createRows(List<AbsenKuliah>? data) {
  int nomor = 0;
  return data!.map((item) {
    nomor++;
    int index = 0;
    bool checkValue(List<Map> data, int i) {
      // print(i);
      bool flag = false;
      for (int j = 0; j < data.length; j++) {
        // print('${i} - ${data[j]["pertemuan"]}');
        if (i == data[j]["pertemuan"]) {
          index = j;
          flag = true;
          break;
        }
      }
      // print(flag);
      return flag;
    }

    Widget colorAbsen(String item) {
      if (item == "H") {
        return Text(
          item,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
        );
      } else if (item == "A") {
        return Text(
          item,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        );
      } else {
        return Text(
          item,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
        );
      }
    }

    return DataRow(
      cells: [
        DataCell(Text("${nomor}")),
        DataCell(Text(item.matakuliah)),
        for (int i = 0; i < 18; i++)
          if (checkValue(item.data, i + 1))
            DataCell(colorAbsen(item.data[index]["status"] as String))
          else
            DataCell(Text("-")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        // DataCell(Text("no")),
        DataCell(Text(
            "${calculatePercentage(item.data.length, 18).toStringAsFixed(2)}")),
      ],
    );
  }).toList();
}
