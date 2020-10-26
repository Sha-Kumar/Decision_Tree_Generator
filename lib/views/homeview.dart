// import 'dart:html';

import 'dart:io';

import 'package:Decision_Tree_Generator/controllers/homeControllor.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();
  List<List<dynamic>> data;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      FilePickerResult res = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          onFileLoading: (c) {
            print(c.index);
            // return 45;
          },
          allowedExtensions: ['csv'],
          withData: true);
      _paths = res.files;
      var fg = res.files[0].bytes;
      print(String.fromCharCodes(fg));
      // final file = await new File('${tempDir.path}/image.jpg').create();
      // var ff = File(fg, 'helo.csv');

      // cv.CsvToListConverter().convert(fgt);
      // print(res.files[0].bytes);
      // final myData = await rootBundle.loadString("assets/sales.csv");
      // List<List<dynamic>> csvTable = CsvToListConverter().convert(csv);

      // data = csvTable;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decision Tree Generator'),
        titleSpacing: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blueAccent,
              child: Text(_fileName ?? 'nil'),
            ),
          ),
          Container(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () => _openFileExplorer(),
                  child: Text("Open file picker"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
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
                        margin: EdgeInsets.all(30.0),
                      ),
                      Container(
                        color: Colors.deepPurpleAccent,
                        height: 500,
                        width: double.maxFinite,
                        margin: EdgeInsets.all(30.0),
                        child: Obx(
                          () {
                            print(controller.data.isNullOrBlank
                                ? 'l'
                                : controller?.data[0]);
                            return Text(
                              controller.data.length.toString(),
                            );
                          },
                        ),
                        // child: SingleChildScrollView(
                        //   child: Table(
                        //     columnWidths: {
                        //       0: FixedColumnWidth(100.0),
                        //       1: FixedColumnWidth(200.0),
                        //     },
                        //     border: TableBorder.all(width: 1.0),
                        //     children: controller.data.map((item) {
                        //       return TableRow(
                        //           children: item.map((row) {
                        //         return Container(
                        //           color: row.toString().contains("NA")
                        //               ? Colors.red
                        //               : Colors.green,
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text(
                        //               row.toString(),
                        //               style: TextStyle(fontSize: 20.0),
                        //             ),
                        //           ),
                        //         );
                        //       }).toList());
                        //     }).toList(),
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                  Positioned(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          child: Text('Tree'),
                          onPressed: () async {
                            updater(0);
                            controller.openFileExplorer();
                          },
                        ),
                        RaisedButton(
                          child: Text('Table'),
                          onPressed: () => updater(1),
                        )
                      ],
                    ),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () {},
                child: Text('upload'),
              )
            ],
          );
        },
      ),
    );
  }
}
