import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_demo/home/controller/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeScreenController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("To-Do List"),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addReview(context);
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.043),
          child: controller.isLod
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : showList(),
        ),
      ),
    );
  }
}

Widget showList() {
  return GetBuilder<HomeScreenController>(
    id: "data",
    builder: (controller) {
      return controller.getData.isEmpty
          ? const SizedBox()
          : ListView.builder(
              itemCount: controller.getData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Card(
                    color: controller.getData[index]["conform"] == true
                        ? Colors.green
                        : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                controller.getData[index]["title"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.getData[index]["subTitle"],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          controller.getData[index]["conform"] == true
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                      color: Colors.white,
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onPressed: () => controller.onDialogEdit(
                                          context, index),
                                      child: const Text("Edit"),
                                    ),
                                    MaterialButton(
                                      color: Colors.white,
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onPressed: () => controller
                                          .onClear(controller.getData[index]),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    MaterialButton(
                                      color: Colors.green,
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onPressed: () =>
                                          controller.onConform(index),
                                      child: const Text(
                                        "Conform",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    },
  );
}

addReview(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        children: [
          GetBuilder<HomeScreenController>(
            builder: (controller) {
              return SizedBox(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: controller.titleController,
                      ),
                      TextFormField(
                        controller: controller.subTitleController,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            color: Colors.green,
                            onPressed: () => controller.onSave(),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      );
    },
  );
}
