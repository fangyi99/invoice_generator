import 'package:hive/hive.dart';
part 'tnC.g.dart';

@HiveType(typeId: 4)
class TnC extends HiveObject{

  TnC({this.balancePmt = "Upon Completion", this.progressPmt = "Weekly", this.validityPrd = "2 weeks"});

  @HiveField(0)
  late String balancePmt;

  @HiveField(1)
  late String validityPrd;

  @HiveField(2)
  late String? progressPmt;

  Map<String, dynamic> toJSON() {
    return {
      "balancePmt": balancePmt,
      "validityPrd": validityPrd,
      "progressPmt": progressPmt
    };
  }
}