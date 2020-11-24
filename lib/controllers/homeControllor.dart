import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt indexValue = 0.obs;

  int get index => indexValue.value;
  set index(int v) => indexValue.value = v;

  final RxBool isMoreAvailable = true.obs;
  RxList<dynamic> headers = <dynamic>[].obs;
  RxList<List<dynamic>> rows = <List<dynamic>>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  void getFileForAlgorithm() {}

  Node node;

  Future<void> loadFile({String mydata}) async {
    final mydata = await rootBundle.loadString("assets/baseball.csv");
    headers.clear();
    rows.clear();
    final List<List> csvTable = const CsvToListConverter(
      eol: "\n",
    ).convert(mydata);

    headers.assignAll(csvTable.first);
    csvTable.removeAt(0);
    rows.addAll(csvTable);
    // print("here new one");
    // print(headers);
    // print("here plase cross");
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
