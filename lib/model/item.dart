import 'package:hive/hive.dart';
part 'item.g.dart';

@HiveType(typeId: 3)
class Item extends HiveObject{

  Item({this.description = '', this.amount = 0, this.methodStm = ''});

  @HiveField(0)
  late String description;

  @HiveField(1)
  late String methodStm;

  @HiveField(2)
  late double? amount;

  Map<String, dynamic> toJSON() {
    return {
      "description": description,
      "methodStm": methodStm,
      "amount": amount
    };
  }
}