import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt indexValue = 0.obs;

  RxInt start = 0.obs;
  int limit = 200;
  int get index => indexValue.value;
  set index(int v) => indexValue.value = v;
  ScrollController scrollController;
  final RxBool isMoreAvailable = true.obs;
  RxList cols = <dynamic>[].obs;
  RxList<List<dynamic>> rows = <List<dynamic>>[].obs;
  List<List<dynamic>> rowss = <List<dynamic>>[];

  @override
  void onInit() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels >
            // 90% scroll
            0.6 * scrollController.position.maxScrollExtent) {
          loadMore();
          print('ini');
        }
      });
    super.onInit();
  }

  Future<void> loadFile(String mydata) async {
    // final mydata = await rootBundle.loadString("assets/baseball.csv");
    final List<List<dynamic>> csvTable = const CsvToListConverter(
      eol: "\n",
    ).convert(mydata);
    cols.value = csvTable.first;
    csvTable.removeAt(0);
    rowss = csvTable;
    rows.addAll(
      rowss.sublist(start.value, limit),
    );
    start.value += limit + 1;
    // print(csvTable);
  }

  void loadMore() {
    if (isMoreAvailable.value) {
      int val = start.value + limit;
      if (rowss.length <= val) {
        val = rowss.length;
        isMoreAvailable.value = false;
      }
      rows.addAll(
        rowss.sublist(start.value, val),
      );
      start += limit + 1;
    }
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
      loadFile(ascii.decode(fg));
    } on PlatformException catch (e) {
      print("Unsupported operation$e");
    } catch (ex) {
      print(ex);
    }
  }
}

/*
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt indexValue = 0.obs;

  RxInt start = 0.obs;
  int limit = 200;
  int get index => indexValue.value;
  set index(int v) => indexValue.value = v;
  ScrollController scrollController;
  final RxBool isMoreAvailable = true.obs;
  RxList cols = <dynamic>[].obs;
  RxList<List<dynamic>> rows = <List<dynamic>>[].obs;
  List<List<dynamic>> rowss = <List<dynamic>>[];

  @override
  void onInit() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels >
            // 90% scroll
            0.6 * scrollController.position.maxScrollExtent) {
          loadMore();
          print('ini');
        }
      });
    super.onInit();
  }

  Future<void> loadFile(String mydata) async {
    // final mydata = await rootBundle.loadString("assets/baseball.csv");
    final List<List<dynamic>> csvTable = const CsvToListConverter(
      eol: "\n",
    ).convert(mydata);
    cols.value = csvTable.first;
    csvTable.removeAt(0);
    rowss = csvTable;
    rows.addAll(
      rowss.sublist(start.value, limit),
    );
    start.value += limit + 1;
    // print(csvTable);
  }

  void loadMore() {
    if (isMoreAvailable.value) {
      int val = start.value + limit;
      if (rowss.length <= val) {
        val = rowss.length;
        isMoreAvailable.value = false;
      }
      rows.addAll(
        rowss.sublist(start.value, val),
      );
      start += limit + 1;
    }
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
      loadFile(ascii.decode(fg));
    } on PlatformException catch (e) {
      print("Unsupported operation$e");
    } catch (ex) {
      print(ex);
    }
  }
}

   */
