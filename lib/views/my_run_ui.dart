// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_s6752d10012/models/run.dart';
import 'package:flutter_app_s6752d10012/views/insert_run_ui.dart';
import 'package:flutter_app_s6752d10012/views/up_del_run_ui.dart';

class MyRunUI extends StatefulWidget {
  const MyRunUI({super.key});

  @override
  State<MyRunUI> createState() => _MyRunUIState();
}

class _MyRunUIState extends State<MyRunUI> {
  late Future<List<Run>> myRuns;

  @override
  void initState() {
    super.initState();
    myRuns = fetchMyRuns(); // กำหนดค่า myRuns เมื่อเริ่มต้น
  }

  Future<List<Run>> fetchMyRuns() async {
    try {
      final response = await Dio().get('http://172.17.36.50:124/api/run');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['result'] as List<dynamic>;
        return data.map((json) => Run.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load runs');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load runs: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 213, 253),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'การวิ่งของฉัน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/running.png',
              width: 250,
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Run>>(
              future: myRuns,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Run> runs = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: runs.length,
                      itemBuilder: (context, index) {
                        Run run = runs[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpDelRunUi(
                                  runId: run.runId,
                                  runLocation: run.runLocation,
                                  runDistance: run.runDistance,
                                  runTime: run.runTime,
                                ),
                              ),
                            ).then(
                              (value) {
                                setState(() {
                                  myRuns = fetchMyRuns();
                                });
                              },
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          title: Text('สถานที่วิ่ง: ' + run.runLocation!),
                          subtitle: Text(
                            'ระยะทางวิ่ง: ' +
                                run.runDistance!.toString() +
                                ' km',
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.purple),
                          tileColor:
                              index % 2 == 0 ? Colors.white : Colors.grey[200],
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('No runs found.');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 241, 160, 255),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertRunUI(),
            ),
          ).then(
            (value) => setState(() {
              myRuns = fetchMyRuns();
            }),
          );
        },
        label: Text(
          'เพิ่มการวื่ง',
        ),
        icon: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
