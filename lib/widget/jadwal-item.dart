import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jadwal.dart' as JadwalMatakuliah;
import '../providers/jadwal.dart';

class JadwalItem extends StatefulWidget {
  final String name;
  JadwalItem({
    super.key,
    required this.name,
  });

  @override
  State<JadwalItem> createState() => _JadwalItemState();
}

class _JadwalItemState extends State<JadwalItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    List matakuliah =
        Provider.of<Jadwal>(context).jadwalMatakuliah(widget.name);
    return matakuliah.length > 0
        ? Card(
            child: Column(children: [
              ListTile(
                title: Text(widget.name),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              if (_expanded && matakuliah != null)
                Container(
                    height: 180,
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      itemCount: matakuliah.length,
                      itemBuilder: (context, index) {
                        JadwalmataKuliah instanceMatakuliah = matakuliah[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${instanceMatakuliah.namaMatakuliah}",
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                      Text("${instanceMatakuliah.dosen}"),
                                      Text("${instanceMatakuliah.kelas}"),
                                    ],
                                  ),
                                ),
                              ),
                              Text("${instanceMatakuliah.jam}"),
                            ],
                          ),
                        );
                      },
                    ))
            ]),
          )
        : Container();
  }
}
