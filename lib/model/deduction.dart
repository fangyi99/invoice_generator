import 'omission.dart';

class Deduction{
  String? type;
  double? amount;
  List<Omission>? omissions;

  Deduction({this.type = "Discount Given", this.amount = 0.00, this.omissions});

  Map<String, dynamic> toJSON() {
    return {
      "type": type,
      "amount": amount,
      "omissions": omissions?.map((e) => e.toJSON()),
    };
  }
}