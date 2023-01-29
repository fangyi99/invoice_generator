import 'package:hive/hive.dart';
part 'transport.g.dart';

@HiveType(typeId: 3)
class Transport extends HiveObject{

  Transport({this.type = "Two Way", this.amount = 0, this.otherType = ""});

  @HiveField(0)
  late String type;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late String? otherType;

  Map<String, dynamic> toJSON() {
    return {
      "type": type,
      "amount": amount,
      "otherType": otherType,
    };
  }
}