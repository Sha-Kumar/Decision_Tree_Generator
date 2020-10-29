import 'package:Decision_Tree_Generator/controllers/homeControllor.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          'Decision Tree Generator',
          textScaleFactor: 1.5,
        ),
        toolbarOpacity: 0.8,
      ),
      body: ValueBuilder<int>(
        initialValue: 0,
        builder: (value, updater) {
          return ListView(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  IndexedStack(
                    index: value,
                    children: [
                      Container(
                        color: Colors.tealAccent,
                        height: 500,
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(30.0),
                      ),
                      Container(
                        color: Colors.deepPurpleAccent,
                        height: 500,
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(30.0),
                        child: Obx(
                          () {
                            return SingleChildScrollView(
                              child: !controller.cols.isNullOrBlank
                                  ? DataTable(
                                      columns: controller.cols
                                          .map(
                                            (e) => DataColumn(
                                              label: Text(
                                                e.toString(),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      rows: controller.rows
                                          .map(
                                            (item) => DataRow(
                                              cells: item
                                                  .map(
                                                    (e) => DataCell(
                                                      Text(
                                                        e.toString(),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : const SizedBox.shrink(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            updater(0);
                          },
                          child: const Text('Tree'),
                        ),
                        RaisedButton(
                          onPressed: () => updater(1),
                          child: const Text('Table'),
                        )
                      ],
                    ),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () {
                  controller.openFileExplorer();
                },
                child: const Text('upload'),
              )
            ],
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:csv/csv.dart';
// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;

class TableLayout extends StatefulWidget {
  @override
  _TableLayoutState createState() => _TableLayoutState();
}

class _TableLayoutState extends State<TableLayout> {
  List<List<dynamic>> data = [];

  Future<void> loadAsset() async {
    final myData = await rootBundle.loadString("assets/baseball.csv");
    final List<List<dynamic>> csvTable = const CsvToListConverter(
      eol: "\n",
    ).convert(myData);
    data = csvTable;
    print(data[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () async {
            await loadAsset();
            // print(data[0][2]);
            setState(() {});
            print(data);
          }),
      appBar: AppBar(
        title: Text("Table Layout and CSV"),
      ),
      body: SingleChildScrollView(
          child: DataTable(
        // columns:  data.map((e) => DataColumn(label: e)).toList(),
        // ignore: prefer_const_literals_to_create_immutables
        columns: [const DataColumn(label: Text("data"))],
        rows: [
          const DataRow(
            cells: [
              DataCell(
                Text('vaydata'),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
