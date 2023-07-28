import 'package:flutter/material.dart';

class CardAbsenAple extends StatelessWidget {
  final String jam;
  final String absen;
  const CardAbsenAple({
    super.key,
    required this.jam,
    required this.absen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Card(
        color: absen == "H"
            ? Colors.green
            : absen == "S" || absen == "A"
                ? Color.fromARGB(255, 224, 73, 42)
                : Color.fromARGB(255, 0, 76, 138),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jam,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                absen,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
