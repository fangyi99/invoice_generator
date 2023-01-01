class AddOn{
  String? description;
  double? amount;

  AddOn({this.description = '', this.amount = 0});

  Map<String, dynamic> toJSON() {
    return {
      "description": description,
      "amount": amount
    };
  }
}