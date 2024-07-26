import 'package:finance_app/models/currency.dart';
import 'package:finance_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = widget.currencies;
  }

  void _convertCurrency() {
    if (_selectedCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a currency"),
          backgroundColor: BusinessColors.secondaryBlue,
        ),
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
    return amount.toStringAsFixed(2);
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = widget.currencies;
      } else {
        _filteredCurrencies = widget.currencies
            .where((currency) =>
                currency.code.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          floating: true,
          pinned: true,
          title: Text("Currency Converter"),
          backgroundColor: BusinessColors.primaryBlue,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Convert",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: BusinessColors.secondaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle:
                        const TextStyle(color: BusinessColors.secondaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: BusinessColors.secondaryBlue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: BusinessColors.accentGold, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.attach_money,
                        color: BusinessColors.secondaryBlue),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      _inputAmount = double.tryParse(value) ?? 1.0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Select Currency",
                    labelStyle:
                        const TextStyle(color: BusinessColors.secondaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: BusinessColors.secondaryBlue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: BusinessColors.accentGold, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.search,
                        color: BusinessColors.secondaryBlue),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: _filterCurrencies,
                ),
                if (_filteredCurrencies.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: BusinessColors.secondaryBlue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: _filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.monetization_on,
                              color: BusinessColors.accentGold),
                          title: Text(_filteredCurrencies[index].code),
                          onTap: () {
                            setState(() {
                              _selectedCurrency =
                                  _filteredCurrencies[index].code;
                            });
                            _searchController.clear();
                            _filteredCurrencies = [];
                            _convertCurrency();
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                if (_convertedAmount != null)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: BusinessColors.primaryBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Converted Amount",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: BusinessColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${_formatConvertedAmount(_convertedAmount!)} UZS",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: BusinessColors.accentGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BusinessColors.accentGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _convertCurrency,
                    child: const Text(
                      "Convert",
                      style: TextStyle(
                          fontSize: 18, color: BusinessColors.textDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
