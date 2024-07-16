import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_bloc.dart';
import '../bloc/currency_event.dart';
import '../bloc/currency_state.dart';
import '../models/currency.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyInitial) {
            context.read<CurrencyBloc>().add(FetchCurrencies());
            return Center(child: CircularProgressIndicator());
          } else if (state is CurrencyLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CurrencyLoaded) {
            return CurrencyConverter(currencies: state.currencies);
          } else if (state is CurrencyError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  final List<Currency> currencies;

  CurrencyConverter({required this.currencies});

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
          DropdownButtonFormField<String>(
            value: _selectedCurrency,
            hint: Text("Select Currency"),
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
          TextField(
            decoration: InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _inputAmount = double.tryParse(value) ?? 1.0;
              });
            },
          ),
          ElevatedButton(
            onPressed: _convertCurrency,
            child: Text("Convert"),
          ),
          if (_convertedAmount != null)
            Text(
              "Converted Amount: $_convertedAmount UZS",
              style: TextStyle(fontSize: 20),
            ),
        ],
      ),
    );
  }

  void _convertCurrency() {
    if (_selectedCurrency == null) {
      return;
    }

    final selectedCurrencyRate = widget.currencies
        .firstWhere((currency) => currency.code == _selectedCurrency)
        .rate;

    setState(() {
      _convertedAmount = _inputAmount * selectedCurrencyRate;
    });
  }
}
