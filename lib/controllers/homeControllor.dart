import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt indexValue = 0.obs;

  int get index => indexValue.value;
  set index(int v) => indexValue.value = v;

  final RxBool isMoreAvailable = true.obs;
  RxList cols = <dynamic>[].obs;
  RxList<List<dynamic>> rows = <List<dynamic>>[].obs;

  // @override
  // void onInit() {

  //   super.onInit();
  // }

  Future<void> loadFile(String mydata) async {
    // final mydata = await rootBundle.loadString("assets/baseball.csv");
    cols.clear();
    rows.clear();
    final List<List<dynamic>> csvTable = const CsvToListConverter(
      eol: "\n",
    ).convert(mydata);
    cols.assignAll(csvTable.first);
    csvTable.removeAt(0);
    rows.addAll(csvTable);
    print(csvTable);
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
      await compute(loadFile, utf8.decode(fg));
    } on PlatformException catch (e) {
      print("Unsupported operation$e");
    } catch (ex) {
      print(ex);
    }
  }
}
