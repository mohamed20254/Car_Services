import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/core/constant/images_.dart';
import 'package:ecommerce_app/logic/cubit/langcubit.dart';
import 'package:ecommerce_app/presentation/page/services_car/winch_requset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ServiceItem> servicesar = [
      ServiceItem(
        ontap: () {
          Navigator.pushNamed(context, AppRoutes.carwifi);
        },

        title: "الصيانة المتنقلة",
        description:
            "خدمة صيانة متنقلة تصل إليك أينما كنت بمجرد ما تضغط علي طلب الخدمه يتم تحديد موقعك وتدخل بيانات المشكله خلال دقاءق يتم الوصول اليك",
        imageUrl: AppImges.carswifi,
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.winchRequest);
        },

        title: "خدمة الونش",
        description:
            " ايه هو ونش مصر?ش مصر هي شركة ناشئة جديدة في السوق المصري تقدم خدمات النقل وانقاذ السيارات المعطلة على الطريق لتلبية الطلب على هذه الخدمات من قبل الشركات والأفراد تأسست الشركة عام  2025 من قبل اثنين من رواد الأعمال الشباب لتقديم خدمات لوجستية متكاملة",
        imageUrl: AppImges.wanchmaser,
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.quickDiagnostic);
        },
        imageUrl: AppImges.scScreenshot,
        title: "الفحص السريع",
        description:
            "خدمة الفحص السريع تتيح لك التأكد من حالة مركبتك خلال دقائق، حيث يقوم فني متخصص بفحص مبدئي لأهم مكونات السيارة مثل الفرامل، الإطارات، السوائل، والإضاءة دون الحاجة لزيارة مركز صيانة. الخدمة مصممة لتوفير راحة وسرعة في التشخيص الأولي لأي مشكلة قد تواجهها السيارة.",
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.obdblutos);
        },
        imageUrl: AppImges.odp,
        title: "خدمات رقمية ذكية",
        description:
            "نظام ذكي يساعدك في متابعة حالة سيارتك تلقائياً. من خلال فحص الكمبيوتر، ستحصل على تقرير مفصل عن الأعطال. كما سيتم إرسال تنبيهات دورية حسب عدد الكيلومترات لتذكيرك بالصيانة. يمكنك أيضاً الاشتراك في خطط صيانة دورية لتوفير الجهد والوقت، حيث نقوم بزيارتك تلقائياً حسب الجدول.",
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.integratedParts);
        },
        imageUrl: AppImges.images,
        title: "خدمات مدمجة مع بيع قطع الغيار",
        description:
            "نقدم لك تجربة متكاملة لشراء قطع الغيار مع إمكانية تركيبها في نفس الوقت من خلال فنيين متخصصين. لا داعي للبحث عن فني بعد الشراء، فقط اختر القطعة وسنقوم بتركيبها لك في الموقع أو في مركز معتمد. كما نتيح لك طلب قطع غير متوفرة وسنقوم بتوفيرها لك بأسرع وقت ممكن.",
      ),
    ];
    final List<ServiceItem> servicesen = [
      ServiceItem(
        ontap: () {
          Navigator.pushNamed(context, AppRoutes.carwifi);
        },
        title: "Mobile maintenance vehicle",
        description:
            "A mobile maintenance service that reaches you wherever you are. Once you click on the service request, your location is determined and the problem information is entered. Within minutes, you will be reached.",
        imageUrl: AppImges.carswifi,
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.winchRequest);
        },
        title: "winch service",
        description:
            "What is Winch Egypt? Winch Egypt is a new startup in the Egyptian market that provides transportation and roadside recovery services to meet the demand for these services from businesses and individuals. The company was founded in 2025 by two young entrepreneurs to provide integrated logistics services.",
        imageUrl: AppImges.wanchmaser,
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.quickDiagnostic);
        },
        imageUrl: AppImges.scScreenshot,
        title: "Quick Diagnostic",
        description:
            "Our Quick Diagnostic service helps you assess your vehicle’s condition within minutes. A specialized technician will inspect key systems like brakes, fluids, tires, and lights without the need to visit a workshop. This service is ideal for a fast, on-the-spot check to ensure your car is safe and functional.",
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.obdblutos);
        },
        imageUrl: AppImges.odp,
        title: "Smart Digital Services",
        description:
            "Our smart system helps you stay updated with your car’s health. Through OBD scanning, you’ll receive detailed error reports. The system also sends you maintenance reminders based on mileage. You can even subscribe to a maintenance plan where we schedule periodic visits automatically—saving you time and hassle.",
      ),
      ServiceItem(
        ontap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.integratedParts);
        },
        imageUrl: AppImges.images,
        title: "Integrated Parts & Services",
        description:
            "We offer a seamless experience where you can buy spare parts and get them installed immediately by professional technicians. No need to search for someone to install it—just order and we’ll handle the rest, on-site or at a certified center. Can’t find the part? Request it, and we’ll deliver it to you fast.",
      ),
    ];

    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";
    List<ServiceItem> services = isenglish ? servicesen : servicesar;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isenglish ? "Services" : "الخدمات",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ServiceCard(service: services[index]);
        },
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final String description;
  final String imageUrl;
  final void Function()? ontap;
  ServiceItem({
    this.ontap,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class ServiceCard extends StatelessWidget {
  final ServiceItem service;

  const ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(service.imageUrl),
          fit: BoxFit.fill,
          // colorFilter: ColorFilter.mode(
          //   Colors.black.withOpacity(0.3),
          //   BlendMode.darken,
          // ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ServiceDetailsPage(service: service),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                service.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [],
                ),
              ),
              SizedBox(height: 6),
              Text(
                ' ${service.description.substring(0, 30)}.....',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceDetailsPage extends StatelessWidget {
  final ServiceItem service;

  const ServiceDetailsPage({required this.service});

  @override
  Widget build(BuildContext context) {
    bool isenglish = context.read<LanguageCubit>().state.languageCode == "en";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          service.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Image.asset(
                service.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    service.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(service.description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: service.ontap,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shadowColor: Colors.black,
                      elevation: 5,
                    ),
                    child: Text(
                      isenglish ? "Service request" : "طلب الخدمه",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
