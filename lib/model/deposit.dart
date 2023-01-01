class Deposit{
  String? type, method, chequeNo, bankName;
  double? amount, progressCounter;
  DateTime? date;

  Deposit({this.type = "Down Payment", this.progressCounter = 1.0, this.amount = 0.0,
    this.date = null, this.method = "Cash", this.chequeNo = "", this.bankName = ""});

  Map<String, dynamic> toJSON() {
    return {
      "type": type,
      "method": method,
      "chequeNo": chequeNo,
      "bankName": bankName,
      "amount": amount,
      "progressCounter": progressCounter,
      "date": date
    };
  }
}