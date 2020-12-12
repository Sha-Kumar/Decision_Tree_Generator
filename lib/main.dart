import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decision Tree Generator',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await controller.loadFile();
          final List<List<String>> rr = [];
          for (final List item in controller.rows) {
            final List<String> list = List.from(item);
            rr.add(list);
          }

          // print("here new one");
          // print(rr);
          // print("here plase cross");
          // print(hh);
        },
        label: const Text('Upload'),
        hoverElevation: 20.0,
        icon: const Icon(Icons.upload_rounded),
      ),
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          'Decision Tree Generator',
          textScaleFactor: 1.5,
        ),
        toolbarOpacity: 0.8,
      ),
      body: ListView(
        children: [
          RaisedButton(
            onPressed: () {
              print(subtables(controller.aRows, 2));
              // buildTree(controller.aRows, controller.aHeaders);
            },
            child: const Text('hell'),
          )
        ],
      ),
      // body: ListView(
      //   children: [
      //     Stack(
      //       alignment: AlignmentDirectional.topCenter,
      //       children: [
      //         Obx(
      //           () => IndexedStack(
      //             index: controller.index,
      //             children: [
      //               Container(
      //                 color: Colors.tealAccent,
      //                 height: 500,
      //                 width: double.maxFinite,
      //                 margin: const EdgeInsets.all(30.0),
      //               ),
      //               Container(
      //                 color: Colors.deepPurpleAccent,
      //                 height: 500,
      //                 width: double.maxFinite,
      //                 margin: const EdgeInsets.all(30.0),
      //                 child: Obx(
      //                   () => SingleChildScrollView(
      //                     child: !controller.headers.isNullOrBlank
      //                         ? Column(
      //                             children: [
      //                               DataTable(
      //                                 columns: controller.headers
      //                                     .map(
      //                                       (e) => DataColumn(
      //                                         label: Text(
      //                                           e.toString(),
      //                                         ),
      //                                       ),
      //                                     )
      //                                     .toList(),
      //                                 rows: controller.rows
      //                                     .map(
      //                                       (item) => DataRow(
      //                                         cells: item
      //                                             .map(
      //                                               (e) => DataCell(
      //                                                 Text(
      //                                                   e.toString(),
      //                                                 ),
      //                                               ),
      //                                             )
      //                                             .toList(),
      //                                       ),
      //                                     )
      //                                     .toList(),
      //                               ),
      //                             ],
      //                           )
      //                         : const SizedBox.shrink(),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(bottom: 9.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               OutlineButton(
      //                 borderSide: const BorderSide(color: Colors.blue),
      //                 shape: const StadiumBorder(),
      //                 onPressed: () {
      //                   controller.index = 0;
      //                 },
      //                 child: const Text('Tree'),
      //               ),
      //               const SizedBox(
      //                 width: 5,
      //               ),
      //               OutlineButton(
      //                 borderSide: const BorderSide(color: Colors.blue),
      //                 shape: const StadiumBorder(),
      //                 onPressed: () {
      //                   controller.index = 1;
      //                 },
      //                 child: const Text('Data Table'),
      //               )
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}

class Node {
  String attribute;
  List<Pair> children;
  String answer;
  Node(
    this.attribute, {
    this.children,
    this.answer,
  });
}

//log calculation.
double logBase(num x, num base) => log(x) / log(base);

//calculating the entropy of the target attribute of the main/sub table.
double entropy(List<String> data) {
  final List attribute = data.toSet().toList();
  final List<double> counts = List.filled(attribute.length, 0);
  double sum = 0;

  if (attribute.isEmpty) {
    return 0;
  }
  for (var i = 0; i < attribute.length; i++) {
    for (final item in data) {
      if (attribute[i] == item) {
        counts[i]++;
      }
    }
    counts[i] = counts[i] / data.length;
  }
  for (final double item in counts) {
    sum += -1 * item * logBase(item, 2);
  }
  return sum;
}

ReturnSubTables subtables(List<List<String>> data, int col,
    {bool delete = false}) {
  final Map<String, List<List<String>>> map = {};
  final List<String> colData = [];
  // data.forEach((e) => colData.add(e[col]));
  for (final e in data) {
    colData.add(e[col]);
  }
  print(colData);

  final List<String> attr = colData.toSet().toList();
  final List<int> counts = List.filled(attr.length, 0);
  final int r = data.length, c = data[0].length;
  print(c);
  for (int x = 0; x < attr.length; x++) {
    for (int y = 0; y < r; y++) {
      if (data[y][col] == attr[x]) {
        counts[x]++;
      }
    }
  }

  for (int x = 0; x < attr.length; x++) {
    map[attr[x]] = List.filled(
      c,
      List.filled(c, ''),
    );
    int pos = 0;
    for (int y = 0; y < r; y++) {
      if (data[y][col] == attr[x]) {
        if (delete) {
          data.elementAt(y).removeAt(col);
        }
        map[attr[x]][pos] = data[y];
        pos++;
      }
    }
  }
  return ReturnSubTables([], map);
}

class ReturnSubTables {
  Map<String, List<List<String>>> map;
  List<String> attr;
  ReturnSubTables(this.attr, this.map);
}

List<String> lastColumn(List<List<String>> data) {
  final List<String> lastCols = [];
  for (final i in data) {
    lastCols.add(i.last);
  }
  return lastCols;
}

double computeGain(List<List<String>> data, int col) {
  final ReturnSubTables returnSubTables = subtables(data, col);
  final List<String> attr = returnSubTables.attr;
  final Map<String, List<List<String>>> map = returnSubTables.map;
  final int totalSize = data.length;
  final List<double> entropies = List.filled(attr.length, 0.0);
  final List<double> ratio = List.filled(attr.length, 0.0);

  double totalEntropy = entropy(lastColumn(data));
  for (int x = 0; x < attr.length; x++) {
    ratio[x] = (map[attr[x]].length) / (totalSize * 1.0);
    entropies[x] = entropy(lastColumn(map[attr[x]]));
    totalEntropy = totalEntropy - ratio[x] * entropies[x];
  }

  return totalEntropy;
}

void printTree(Node node, int level) {
  if (node.answer.isNotEmpty) {
    final List<String> l = List.filled(level, "  ");
    print(l.join() + node.answer);
    return;
  }
  List<String> l = List.filled(level, "  ");
  print(l.join() + node.attribute);
  l.clear();
  for (final Pair val in node.children) {
    l = List.filled(level + 1, "  ");
    print(l.join() + val.val);
    printTree(val.node, level + 2);
  }
}

Node buildTree(List<List<String>> data, List<String> features) {
  final List lastCol = lastColumn(data);
  if (lastCol.toSet().length == 1) {
    final Node node = Node('');
    node.answer = lastCol.first as String;
    return node;
  }
  final int n = data.first.length - 1;
  final List<double> gains = List.filled(n, 0.0);
  for (var i = 0; i < n; i++) {
    gains[i] = computeGain(data, i);
  }
  final double splitValue = gains.fold(0, max);
  final splitIndex = gains.indexOf(splitValue);
  final Node node = Node(features[splitIndex]);
  final List<String> fea = List.of(
    features.getRange(0, splitIndex - 1),
  )..addAll(
      features.getRange(splitIndex + 1, features.length),
    );
  final ReturnSubTables returnSubTables =
      subtables(data, splitIndex, delete: true);
  final List<String> attr = returnSubTables.attr;
  final Map<String, List<List<String>>> map = returnSubTables.map;
  for (var i = 0; i < attr.length; i++) {
    final Node child = buildTree(map[attr[i]], fea);
    node.children.add(
      Pair(attr[i], child),
    );
  }
  return node;
}

void classify(
  Node node,
) {}

class Pair {
  final String val;
  final Node node;

  Pair(this.val, this.node);
}

class HomeController extends GetxController {
  final RxInt indexValue = 0.obs;

  int get index => indexValue.value;
  set index(int v) => indexValue.value = v;

  final RxBool isMoreAvailable = true.obs;
  RxList<String> headers = <String>[].obs;
  RxList<List<String>> rows = <List<String>>[].obs;

  List<String> aHeaders = [];
  List<List<String>> aRows = [[]];

  @override
  void onInit() {
    ever(headers, (val) => aHeaders = val as List<String>);
    ever(rows, (val) => aRows = val as List<List<String>>);
    super.onInit();
  }

  void getFileForAlgorithm() {}

  Node node;

  Future<void> loadFile({String mydata}) async {
    final mydata = await rootBundle.loadString("assets/baseball.csv");
    headers.clear();
    rows.clear();
    final List<List> csvTable = const CsvToListConverter(
      eol: "\n",
      shouldParseNumbers: true,
    ).convert(mydata);
    final List<List<String>> csvValues = [];
    for (final items in csvTable) {
      csvValues.add(items.cast<String>().toList());
    }
    headers.assignAll(csvValues.first);
    csvValues.removeAt(0);
    rows.addAll(csvValues);
    // print("here new one");
    // print(aHeaders);
    // print("here plase cross");
    // print(aRows);
    // print(rows);
  }

  Future<void> openFileExplorer() async {
    try {
      final FilePickerResult res = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          onFileLoading: (c) {
            print(c.index);
          },
          allowedExtensions: ['csv'],
          withData: true);
      final fg = res.files[0].bytes;
      // await compute(loadFile, utf8.decode(fg));
    } on PlatformException catch (e) {
      print("Unsupported operation$e");
    } catch (ex) {
      print(ex);
    }
  }
}
