import 'package:flutter/material.dart';

class CardProfilTaruna extends StatelessWidget {
  final String? name;
  final String? kelas;
  final String? jurusan;
  final String? semester;
  const CardProfilTaruna({
    super.key,
    required this.name,
    required this.kelas,
    required this.jurusan,
    required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 15),
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo, ${name}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,

                      // color: Colors.white,
                    ),
                    softWrap: false,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "kelas ${kelas}, ${jurusan}",
                    style: TextStyle(
                      fontSize: 15,
                      // color: Colors.white,
                    ),
                  ),
                  Text("Semester ${semester}",
                      style: TextStyle(
                        fontSize: 15,
                        // color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
