import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList data = [].obs;

  Future<void> loadFile(mydata) async {
    // final mydata = await rootBundle.loadString("assets/baseball.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(mydata);
    data.value = csvTable;
    // print(data[0]);
  }

  Future<void> openFileExplorer() async {
    try {
      FilePickerResult res = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          onFileLoading: (c) {
            print(c.index);
          },
          allowedExtensions: ['csv'],
          withData: true);
      var fg = res.files[0].bytes;
      // print(String.fromCharCodes(fg));
      loadFile(ascii.decode(fg));
      // print(utf8.decode(fg));
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
  }
}
