import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_bloc.dart';
import '../bloc/currency_event.dart';
import '../bloc/currency_state.dart';
import '../models/currency.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Finance",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyInitial) {
            context.read<CurrencyBloc>().add(FetchCurrencies());
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrencyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrencyLoaded) {
            return CurrencyConverter(currencies: state.currencies);
          } else if (state is CurrencyError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  final List<Currency> currencies;

  const CurrencyConverter({super.key, required this.currencies});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String? _selectedCurrency;
  double _inputAmount = 1.0;
  double? _convertedAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Miqdorni kiritng",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _inputAmount = double.tryParse(value) ?? 1.0;
                    });
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  style: const TextStyle(color: Colors.blue),
                  value: _selectedCurrency,
                  hint: const Text("Valyutani tanlang"),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value;
                    });
                  },
                  items: widget.currencies
                      .map((currency) => DropdownMenuItem(
                            value: currency.code,
                            child: Text(currency.code),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_convertedAmount != null)
            Text(
              "${_formatConvertedAmount(_convertedAmount!)} UZS",
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
              onPressed: _convertCurrency,
              child: const Text(
                "Ayirboshlash",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _convertCurrency() {
    if (_selectedCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Valyutani tanlang")),
      );
      return;
    }

    final selectedCurrencyRate = widget.currencies
        .firstWhere((currency) => currency.code == _selectedCurrency)
        .rate;

    setState(() {
      _convertedAmount = _inputAmount * selectedCurrencyRate;
    });
  }

  String _formatConvertedAmount(double amount) {
    String amountStr = amount.toStringAsFixed(4);
    return amountStr;
  }
}
