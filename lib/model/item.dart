class Item{
  String description, methodStm;
  double? amount;

  Item({this.description = '', this.amount = 0, this.methodStm = ''});

  Map<String, dynamic> toJson() => {
    'description': description,
    'amount': amount,
    'mthdStm': methodStm,
  };
}