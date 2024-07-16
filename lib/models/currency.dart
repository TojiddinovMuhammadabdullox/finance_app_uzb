class Currency {
  final String code;
  final double rate;

  Currency({required this.code, required this.rate});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['Ccy'],
      rate: double.parse(json['Rate']),
    );
  }
}
