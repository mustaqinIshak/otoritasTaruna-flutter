import 'package:flutter/material.dart';
import './absen-aple-screen.dart';
import './absen-perkuliahan-screen.dart';

class AbsenScreen extends StatefulWidget {
  const AbsenScreen({super.key});

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Absen",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            )),
        backgroundColor: Color.fromARGB(255, 0, 76, 138),
        bottom: TabBar(controller: _tabController, tabs: const <Widget>[
          Tab(
            child: Text("Absen Apel"),
          ),
          Tab(
            child: Text("Absen Perkuliahan"),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          AbsenApleScreen(),
          AbsenPerkuliahanScreen(),
        ],
      ),
    );
  }
}
