import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class CurrencyRepository {
  final String apiUrl = "https://cbu.uz/uz/arkhiv-kursov-valyut/json/";

  Future<List<Currency>> fetchCurrencies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Currency> currencies =
          body.map((dynamic item) => Currency.fromJson(item)).toList();
      return currencies;
    } else {
      throw Exception("Failed to load currencies");
    }
  }

  Future<List<Currency>> searchCurrencies(String query) async {
    final currencies = await fetchCurrencies();
    return currencies
        .where((currency) =>
            currency.code.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
