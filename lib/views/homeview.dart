import 'package:Decision_Tree_Generator/controllers/homeControllor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.openFileExplorer();
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
                          child: !controller.cols.isNullOrBlank
                              ? Column(
                                  children: [
                                    DataTable(
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

/*
import 'package:Decision_Tree_Generator/controllers/homeControllor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.start.value = 0;
          controller.openFileExplorer();
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
                        () {
                          return SingleChildScrollView(
                            controller: controller.scrollController,
                            child: !controller.cols.isNullOrBlank
                                ? Column(
                                    children: [
                                      DataTable(
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
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          );
                        },
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
                      child: const Text('Table'),
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

   */
