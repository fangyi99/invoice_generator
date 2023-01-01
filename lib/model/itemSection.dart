import 'item.dart';

import 'package:hive/hive.dart';
part 'itemSection.g.dart';

@HiveType(typeId: 2)
class ItemSection extends HiveObject{

  ItemSection({required this.type, required this.itemList});

  @HiveField(0)
  late String type;

  @HiveField(1)
  List<Item> itemList;

  Map<String, dynamic> toJSON() {
    return {
      "type": type,
      "itemList": itemList.map((e) => e.toJSON())
    };
  }
}