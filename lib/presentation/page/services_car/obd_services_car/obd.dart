import 'dart:async';
import 'dart:convert';
import 'package:ecommerce_app/core/constant/app_lotti.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/presentation/page/services_car/obd_services_car/obdd_data_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: OBDHomePage(),
      // OBDDataPage(
      //   device: BluetoothDevice(remoteId: DeviceIdentifier(AppLotti.extand)),
      // ),
    );
  }
}

class OBDHomePage extends StatefulWidget {
  const OBDHomePage({super.key});

  @override
  State<OBDHomePage> createState() => _OBDHomePageState();
}

class _OBDHomePageState extends State<OBDHomePage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  bool isScanning = false;

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    scanForDevices();
  }

  Future<void> ensureBluetoothIsOn() async {
    final isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      throw Exception("الرجاء تشغيل البلوتوث قبل البدء بالمسح.");
    }
  }

  Future<void> scanForDevices() async {
    try {
      await ensureBluetoothIsOn();
      devicesList.clear();
      setState(() => isScanning = true);

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          final name = r.device.name.toLowerCase();
          if ((name.contains("obd") ||
                  name.contains("elm") ||
                  name.contains("v-link")) &&
              !devicesList.any((d) => d.id == r.device.id)) {
            setState(() => devicesList.add(r.device));
          }
        }
      });

      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();
      setState(() => isScanning = false);
    } catch (e) {
      showSnack("❌ خطأ أثناء المسح: $e");
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      // ✅ إيقاف البحث قبل الاتصال
      await FlutterBluePlus.stopScan();
      await Future.delayed(const Duration(milliseconds: 500)); // تأخير بسيط

      setState(() {
        connectedDevice = null;
      });

      // ✅ محاولة الاتصال الأساسية
      await device.connect(autoConnect: false);
      setState(() {
        connectedDevice = device;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ تم الاتصال بـ ${device.name}")));

      // ✅ انتقل لصفحة قراءة البيانات
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OBDDataPage(device: device)),
      );
    } catch (e) {
      // ✅ في حالة الخطأ 133
      if (e.toString().contains("android-code: 133")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ فشل الاتصال (كود 133)، سيتم إعادة المحاولة..."),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        try {
          await device.connect(autoConnect: false);
          setState(() {
            connectedDevice = device;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ تمت إعادة الاتصال بـ ${device.name}")),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OBDDataPage(device: device),
            ),
          );
        } catch (e2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ فشل الاتصال مرة أخرى: $e2")),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ فشل الاتصال: $e")));
      }
    }
  }

  void showSnack(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> sendOBDCommand(String command, String label) async {
    if (connectedDevice == null) return showSnack("❗ لم يتم الاتصال بأي جهاز");

    try {
      List<BluetoothService> services =
          await connectedDevice!.discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          final canWrite =
              c.properties.write || c.properties.writeWithoutResponse;
          final canRead = c.properties.read;
          final canNotify = c.properties.notify;

          if (canWrite) {
            await c.write(utf8.encode("$command\r"));
          }

          if (canNotify) {
            await c.setNotifyValue(true);
            c.value.listen((value) {
              String response = utf8.decode(value);
              showSnack("$label: $response");
            });
            return;
          }

          if (canRead) {
            final value = await c.read();
            String response = utf8.decode(value);
            showSnack("$label: $response");
            return;
          }
        }
      }
    } catch (e) {
      showSnack("❌ خطأ في $label: $e");
    }
  }

  Widget buildDeviceItem(BluetoothDevice device) {
    return Card(
      child: ListTile(
        title: Text(
          device.name.isNotEmpty ? device.name : device.id.toString(),
        ),
        subtitle: Text(device.id.toString()),
        trailing: const Icon(Icons.bluetooth_connected),
        onTap: () => connectToDevice(device),
      ),
    );
  }

  Widget buildOBDAnimation(bool isenglis) {
    return Column(
      children: [
        Lottie.asset(AppLotti.odb, width: 150, repeat: true),
        const SizedBox(height: 10),
        Text(
          connectedDevice != null
              ? "🔗 متصل بـ ${connectedDevice!.name}"
              : isenglis
              ? "🔍 Searching for OBD devices..."
              : "🔍 جارِ البحث عن أجهزة OBD...",
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget buildOBDButtons() {
    if (connectedDevice == null) return const SizedBox.shrink();

    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.speed),
          label: const Text("قراءة RPM"),
          onPressed: () => sendOBDCommand("010C", "📈 RPM"),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.cleaning_services),
          label: const Text("مسح الأعطال"),
          onPressed: () => sendOBDCommand("04", "🧹 تم المسح"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";
    return Scaffold(
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (context) => OBDDataPage(
                    device: BluetoothDevice(
                      remoteId: DeviceIdentifier(AppLotti.extand),
                    ),
                  ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 12, 5, 222),
                Colors.blueAccent,
              ],
            ),
          ),
          width: 100,
          height: 40,

          alignment: Alignment.center,
          child: Text(
            isenglish ? "Demo mode" : "الوضع التجريب",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          isenglish ? 'OBD Bluetooth Connector' : "خدمات رقمية ذكية",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildOBDAnimation(isenglish),
            const SizedBox(height: 20),
            buildOBDButtons(),
            const SizedBox(height: 20),
            isScanning
                ? const SpinKitFadingCircle(color: Colors.indigo, size: 50)
                : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: scanForDevices,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label:
                      isenglish
                          ? const Text(
                            "Search for devices",
                            style: TextStyle(color: Colors.white),
                          )
                          : const Text(
                            "بحث عن أجهزة OBD",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: devicesList.map(buildDeviceItem).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
