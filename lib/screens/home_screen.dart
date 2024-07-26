import 'package:finance_app/screens/converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_bloc.dart';
import '../bloc/currency_event.dart';
import '../bloc/currency_state.dart';

class BusinessColors {
  static const Color primaryBlue = Color(0xFF0A2342);
  static const Color secondaryBlue = Color(0xFF2D4B73);
  static const Color accentGold = Color(0xFFD5A021);
  static const Color backgroundGrey = Color(0xFFF0F2F5);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFFFFFFFF);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: BusinessColors.primaryBlue,
        scaffoldBackgroundColor: BusinessColors.backgroundGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: BusinessColors.primaryBlue,
          foregroundColor: BusinessColors.textLight,
        ),
        colorScheme: const ColorScheme.light(
          primary: BusinessColors.primaryBlue,
          secondary: BusinessColors.secondaryBlue,
          onPrimary: BusinessColors.textLight,
          onSecondary: BusinessColors.textLight,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: BusinessColors.textDark),
          titleMedium: TextStyle(color: BusinessColors.textDark),
          bodyMedium: TextStyle(color: BusinessColors.textDark),
        ),
      ),
      child: Scaffold(
        body: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            if (state is CurrencyInitial) {
              context.read<CurrencyBloc>().add(FetchCurrencies());
              return const Center(child: CircularProgressIndicator());
            } else if (state is CurrencyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CurrencyLoaded ||
                state is CurrencySearchLoaded) {
              return CurrencyConverter(currencies: state.currencies);
            } else if (state is CurrencyError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("Unknown state"));
            }
          },
        ),
      ),
    );
  }
}
