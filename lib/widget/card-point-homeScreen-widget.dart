import 'package:flutter/material.dart';

class CardPointHomeScreenWidget extends StatelessWidget {
  final String name;
  final String tanggal;
  final String point;
  const CardPointHomeScreenWidget({
    super.key,
    required this.name,
    required this.tanggal,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "${name}",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      Text(tanggal),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                child: Text(
                  '$point',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
