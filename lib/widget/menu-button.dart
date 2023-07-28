import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String name;
  final Icon icon;
  final Function function;
  const MenuButton(
      {super.key,
      required this.name,
      required this.icon,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return function();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 23, 130, 219),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Text(name,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
