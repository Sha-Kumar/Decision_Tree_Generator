import 'package:flutter/material.dart';
import 'package:Decision_Tree_Generator/decisionTree/id3.dart' as n;
import 'package:get/get.dart';
import 'controllers/homeControllor.dart';
import 'views/views.dart';

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
          print(rr.runtimeType);
          final List<String> hh = [];
          for (final item in controller.headers) {
            hh.add(item as String);
          }

          // print("here new one");
          // print(rr);
          // print("here plase cross");
          // print(hh);
          final n.Node node = n.buildTree(rr, hh);
          n.printTree(node, 0);
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
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Obx(
                () => IndexedStack(
                  index: controller.index,
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
                        () => SingleChildScrollView(
                          child: !controller.headers.isNullOrBlank
                              ? Column(
                                  children: [
                                    DataTable(
                                      columns: controller.headers
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
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      borderSide: const BorderSide(color: Colors.blue),
                      shape: const StadiumBorder(),
                      onPressed: () {
                        controller.index = 0;
                      },
                      child: const Text('Tree'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    OutlineButton(
                      borderSide: const BorderSide(color: Colors.blue),
                      shape: const StadiumBorder(),
                      onPressed: () {
                        controller.index = 1;
                      },
                      child: const Text('Data Table'),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
