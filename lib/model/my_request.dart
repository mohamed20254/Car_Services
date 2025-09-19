import 'package:hive/hive.dart';

part 'my_request.g.dart';

@HiveType(typeId: 5)
class MyRequest {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String paymenten;
  @HiveField(2)
  final String decen;
  @HiveField(3)
  final String price;
  @HiveField(4)
  final String paymentar;
  @HiveField(5)
  final String decar;
  MyRequest(
    this.name,
    this.paymenten,
    this.decen,
    this.price,
    this.paymentar,
    this.decar,
  );
}
