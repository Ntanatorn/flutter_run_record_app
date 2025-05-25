// ignore_for_file: sort_child_properties_last, unused_element, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_s6752d10012/models/run.dart';

class InsertRunUI extends StatefulWidget {
  const InsertRunUI({super.key});

  @override
  State<InsertRunUI> createState() => _InsertRunUIState();
}

class _InsertRunUIState extends State<InsertRunUI> {
  TextEditingController runLocationCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();
  TextEditingController runTimeCtrl = TextEditingController();

  Future<void> _showWarningDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResultDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ผลการทำงาน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 213, 253),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'เพิ่มการวิ่งของฉัน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 40.0,
          right: 40.0,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60.0,
              ),
              Image.asset(
                'assets/images/running.png',
                width: 200.0,
              ),
              SizedBox(
                height: 60.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'สถานที่วิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runLocationCtrl,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกสถานที่วิ่ง',
                  border: OutlineInputBorder(),
                  filled: true, // ต้องเปิดใช้งานเพื่อให้ fillColor มีผล
                  fillColor: Colors.white, // สีพื้นหลังของ TextField
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ระยะทางที่วิ่ง (กิโลเมตร)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runDistanceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกระยะทางที่วิ่ง',
                  border: OutlineInputBorder(),
                  filled: true, // ต้องเปิดใช้งานเพื่อให้ fillColor มีผล
                  fillColor: Colors.white, // สีพื้นหลังของ TextField
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'เวลาที่ใช้ในการวิ่ง (นาที)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runTimeCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกเวลาที่ใช้ในการวิ่ง',
                  border: OutlineInputBorder(),
                  filled: true, // ต้องเปิดใช้งานเพื่อให้ fillColor มีผล
                  fillColor: Colors.white, // สีพื้นหลังของ TextField
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (runLocationCtrl.text.isEmpty) {
                    _showWarningDialog('กรุณากรอกสถานที่วิ่งด้วย ฮ๊าฟ');
                  } else if (runDistanceCtrl.text.isEmpty) {
                    _showWarningDialog('กรุณากรอกระยะทางที่วิ่งด้วย ฮ๊าฟ');
                  } else if (runTimeCtrl.text.isEmpty) {
                    _showWarningDialog(
                        'กรุณากรอกระยะเวลาที่ใช้ในการวิ่งด้วย ฮ๊าฟ');
                  } else {
                    // ส่งข้อมูลไปที่ฐานข้อมูลผ่าน API
                    Run run = Run(
                      runLocation: runLocationCtrl.text,
                      runDistance: double.parse(runDistanceCtrl.text),
                      runTime: int.parse(runTimeCtrl.text),
                    );

                    final result = await Dio().post(
                      'http://172.17.36.50:124/api/run',
                      data: run.toJson(),
                    );
                    if (result.statusCode == 201) {
                      await _showResultDialog('บันทึกการวิ่งสําเร็จ').then((Value) {
                        Navigator.pop(context);           
                      });
                    } else {
                      await _showWarningDialog('บันทึกการวิ่งไม่สําเร็จ');
                    }
                  }
                },
                child: Text(
                  'บันทึกการวิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
