import 'package:ecommerce_app/core/constant/link_services.dart';
import 'package:ecommerce_app/helper/api.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/presentation/page/services_car/Maintenan_car/follow-up_request.dart';
import 'package:ecommerce_app/presentation/widget/auth/costum_textform.dart';
import 'package:ecommerce_app/presentation/widget/lotti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

// ========== شاشة البداية ==========
class WelcomePage extends StatelessWidget {
  final List<Map<String, dynamic>> branches = [
    {'name': 'فرع الجيزة', 'location': LatLng(30.0332, 31.2357)},
    {'name': 'فرع الإسكندرية', 'location': LatLng(31.2156, 29.9553)},
    {'name': 'فرع المنوفية', 'location': LatLng(30.7443, 31.0326)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    state == Locale("en")
                        ? Expanded(
                          child: Text(
                            "Welcome to Mobile  Maintenance Service",
                            style: GoogleFonts.aBeeZee(
                              textStyle: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        )
                        : Expanded(
                          child: Text(
                            "أهلاً بك في خدمة الصيانة المتنقلة",
                            style: GoogleFonts.aBeeZee(
                              textStyle: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                  ],
                ),
                Lottiee(),

                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MaintenancePage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.build),
                        label:
                            state == Locale("en")
                                ? Text(
                                  "Locate and request service",
                                  style: TextStyle(fontSize: 15),
                                )
                                : Text(
                                  "حدد موقعك واطلب صيانة",
                                  style: TextStyle(fontSize: 15),
                                ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            3,
                            83,
                            195,
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          try {
                            Position position =
                                await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high,
                                );
                            LatLng userLocation = LatLng(
                              position.latitude,
                              position.longitude,
                            );

                            double minDistance = double.infinity;
                            LatLng closest = branches[0]['location'];
                            for (var branch in branches) {
                              double d = Geolocator.distanceBetween(
                                userLocation.latitude,
                                userLocation.longitude,
                                branch['location'].latitude,
                                branch['location'].longitude,
                              );
                              if (d < minDistance) {
                                minDistance = d;
                                closest = branch['location'];
                              }
                            }

                            final Uri url = Uri.parse(
                              'https://www.google.com/maps/dir/?api=1&destination=${closest.latitude},${closest.longitude}&travelmode=driving',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'لا يمكن فتح Google Maps';
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("تعذر تحديد الموقع")),
                            );
                          }
                        },
                        icon: Icon(Icons.directions, color: Colors.white),
                        label:
                            state == Locale("en")
                                ? Text(
                                  "Go to the nearest branch ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  "اذهب إلى أقرب فرع",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ========== صفحة الخريطة ==========
class MaintenancePage extends StatefulWidget {
  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  LatLng _currentLocation = LatLng(0.0, 0.0);
  bool _locationObtained = false;
  late MapController _mapController;

  final List<Map<String, dynamic>> branches = [
    {'name': 'فرع الجيزة', 'location': LatLng(30.0332, 31.2357)},
    {'name': 'فرع الإسكندرية', 'location': LatLng(31.2156, 29.9553)},
    {'name': 'فرع المنوفية', 'location': LatLng(30.7443, 31.0326)},
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) await Geolocator.openLocationSettings();

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى تفعيل صلاحية الموقع للاستمرار")),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationObtained = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء تحديد الموقع")));
    }
  }

  Map<String, dynamic> _getClosestBranchWithData() {
    double minDistance = double.infinity;
    Map<String, dynamic> closest = branches[0];
    for (var branch in branches) {
      double d = Geolocator.distanceBetween(
        _currentLocation.latitude,
        _currentLocation.longitude,
        branch['location'].latitude,
        branch['location'].longitude,
      );
      if (d < minDistance) {
        minDistance = d;
        closest = branch;
      }
    }
    return closest;
  }

  @override
  Widget build(BuildContext context) {
    final closestBranch = _getClosestBranchWithData();

    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:
                state == Locale("en")
                    ? Text("Map of the nearest branch")
                    : Text('خريطة أقرب فرع'),
          ),
          body:
              _locationObtained
                  ? FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation,
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          Marker(
                            point: closestBranch['location'],
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.car_repair,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  : Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.build),
            label:
                state == Locale("en")
                    ? Text("Maintenance request")
                    : Text("طلب صيانة"),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder:
                    (context) => RequestForm(currentLocation: _currentLocation),
              );
            },
          ),
        );
      },
    );
  }
}

// ========== نموذج الطلب ==========
class RequestForm extends StatefulWidget {
  final LatLng currentLocation;

  const RequestForm({required this.currentLocation});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _problem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  state == Locale("en")
                      ? Text(
                        "Maintenance request",
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                      : Text(
                        "طلب صيانة",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                  CostemTextFiled(
                    controller: _name, //context.read<AuthCubit>().password,
                    obscureText: false,
                    validator: (v) => v!.isEmpty ? "Enter Name" : null,
                    hint: state == Locale("en") ? 'name ' : "الاسم",
                    label: state == Locale("en") ? 'name' : "الاسم",
                  ),
                  CostemTextFiled(
                    controller: _phone, //context.read<AuthCubit>().password,
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? "Enter phone" : null,
                    hint: state == Locale("en") ? 'phone' : "الهاتف",
                    label: state == Locale("en") ? 'phone' : "الهاتف",
                  ),
                  CostemTextFiled(
                    controller: _problem, //context.read<AuthCubit>().password,
                    obscureText: false,
                    validator: (v) => v!.isEmpty ? "Enter broblem" : null,
                    hint: state == Locale("en") ? 'broblem' : "المشكلة",
                    label: state == Locale("en") ? 'broblem' : "المشكلة",
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child:
                        state == Locale("en")
                            ? Text("Send Request")
                            : Text("إرسال الطلب"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var response = await ApiMethod().post(
                          url: LinkServices.sendrequst,
                          data: {
                            "name": _name.text,
                            "phone": _phone.text,
                            "problem": _problem.text,
                            "location":
                                "📍 الموقع: ${widget.currentLocation.latitude}, ${widget.currentLocation.longitude}",
                            "state": "Under review",
                          },
                        );
                        if (response['status'] == "sucsses") {
                          QuickAlert.show(
                            // ignore: use_build_context_synchronously
                            context: context,
                            //   widget: Lottie.asset(Apploti.Sendmail),
                            type: QuickAlertType.success,
                            text: 'Your request has been sent',
                            barrierDismissible: false,
                            title: 'succeed',
                            confirmBtnText: "Follow-up request",
                            onConfirmBtnTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => FilteredByPhonePage(
                                        phoneToFilter: _phone.text,
                                      ),
                                ),
                              );
                            },
                          );
                        } else {
                          // ignore: avoid_print
                          print('Erorrrrrrrrrrrrrrrrrrrrr');
                        }

                        print("✔️ الاسم: ${_name.text}");
                        print("📞 الهاتف: ${_phone.text}");
                        print("🛠️ المشكلة: ${_problem.text}");
                        print(
                          "📍 الموقع: ${widget.currentLocation.latitude}, ${widget.currentLocation.longitude}",
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
