class Omission{
  String description;
  double amount;

  Omission({this.description = "", this.amount = 0.00});

  @override
  Map<String, dynamic> toJSON() {
    return {
      "description": description,
      "amount": amount
    };
  }
}