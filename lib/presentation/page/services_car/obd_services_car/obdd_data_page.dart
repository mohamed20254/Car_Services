import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class OBDDataPage extends StatefulWidget {
  final BluetoothDevice device;

  const OBDDataPage({super.key, required this.device});

  @override
  State<OBDDataPage> createState() => _OBDDataPageState();
}

class _OBDDataPageState extends State<OBDDataPage> {
  bool get english => true;
  BluetoothCharacteristic? targetChar;
  bool isSimulation = true; // ← خليه true للتجريب، و false للبلوتوث الحقيقي
  int rpmValue = 0;
  int speed = 0;
  int coolantTemp = 0;
  String status = "جاري الإعداد...";

  List<FlSpot> rpmSpots = [];
  Timer? chartTimer;
  double chartX = 0;

  @override
  @override
  void initState() {
    super.initState();
    if (isSimulation) {
      startFakeData();
    } else {
      discoverAndPrepare();
      chartTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          rpmSpots.add(FlSpot(chartX, rpmValue.toDouble()));
          chartX += 1;
          if (rpmSpots.length > 30) rpmSpots.removeAt(0);
        });
      });
    }
  }

  void startFakeData() {
    chartTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        rpmValue = 600 + (2000 + (2000 * (chartX % 5) / 5)).toInt(); // متغير
        speed = (20 + chartX * 3).toInt() % 120;
        coolantTemp = 70 + (chartX % 10).toInt();
        rpmSpots.add(FlSpot(chartX, rpmValue.toDouble()));
        chartX += 1;
        if (rpmSpots.length > 30) rpmSpots.removeAt(0);
        status = english ? "Demo mode is enabled" : "🧪 وضع التجريب مفعل";
      });
    });
  }

  @override
  void dispose() {
    chartTimer?.cancel();
    super.dispose();
  }

  Future<void> discoverAndPrepare() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      for (var service in services) {
        for (var char in service.characteristics) {
          if (char.properties.write && char.properties.notify) {
            await char.setNotifyValue(true);
            char.value.listen(onDataReceived);
            setState(() {
              targetChar = char;
              status = "✅ جاهز";
            });
            return;
          }
        }
      }
      setState(() => status = "❌ لم يتم العثور على الخصائص المناسبة");
    } catch (e) {
      setState(() => status = "❌ خطأ: $e");
    }
  }

  void onDataReceived(List<int> data) {
    String hex =
        data
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
    if (hex.startsWith("410C")) {
      int A = data[2];
      int B = data[3];
      rpmValue = ((A * 256) + B) ~/ 4;
    } else if (hex.startsWith("410D")) {
      speed = data[2];
    } else if (hex.startsWith("4105")) {
      coolantTemp = data[2] - 40;
    }
    setState(() {});
  }

  void sendCommand(String cmd) async {
    if (targetChar == null) return;
    List<int> bytes = utf8.encode("$cmd\r");
    await targetChar!.write(bytes);
    setState(() => status = "📤 إرسال: $cmd");
  }

  Widget buildMetric(String label, String value, IconData icon, Color color) {
    return SizedBox(
      height: 70,
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, color: color, size: 24),
          title: Text(label, style: const TextStyle(fontSize: 18)),
          subtitle: Text(value, style: const TextStyle(fontSize: 15)),
        ),
      ),
    );
  }

  Widget buildRPMChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 8000,
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: rpmSpots,
              isCurved: true,
              barWidth: 3,

              color: Colors.indigo,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";

    return Scaffold(
      appBar: AppBar(title: Text(isenglish ? "📊  Data OBD" : "📊 بيانات OBD")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              isenglish ? "status: $status" : "الحالة: $status",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            buildMetric("RPM", "$rpmValue RPM", Icons.speed, Colors.orange),
            buildMetric(
              isenglish ? "speed" : "السرعة",
              isenglish ? "$speed km/h" : "$speed كم/س",
              Icons.directions_car,
              Colors.green,
            ),
            buildMetric(
              isenglish ? "the heat" : "الحرارة",
              "$coolantTemp °C",
              Icons.thermostat,
              Colors.red,
            ),

            const SizedBox(height: 20),
            Text(
              isenglish ? "RPM graph" : "رسم بياني للـ RPM",
              style: TextStyle(fontSize: 18),
            ),
            buildRPMChart(),

            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () => sendCommand("010C"),
                  icon: const Icon(Icons.speed, color: Colors.white),
                  label: Text(
                    isenglish ? "Read RPM" : "قراءة RPM",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () => sendCommand("010D"),
                  icon: const Icon(Icons.directions_car, color: Colors.white),
                  label: Text(
                    isenglish ? "read speed" : "قراءة السرعة",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () => sendCommand("0105"),
                  icon: const Icon(Icons.thermostat, color: Colors.white),
                  label: Text(
                    isenglish ? "engine temperature" : "حرارة المحرك",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => sendCommand("04"),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    isenglish ? "debug scan" : "مسح الأعطال",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
