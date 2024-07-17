import 'package:equatable/equatable.dart';
import '../models/currency.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];

  get currencies => null;
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final List<Currency> currencies;

  const CurrencyLoaded(this.currencies);

  @override
  List<Object> get props => [currencies];
}

class CurrencySearchLoaded extends CurrencyState {
  final List<Currency> currencies;

  const CurrencySearchLoaded(this.currencies);

  @override
  List<Object> get props => [currencies];
}

class CurrencySelected extends CurrencyState {
  final Currency selectedCurrency;
  final List<Currency> currencies;

  const CurrencySelected(this.selectedCurrency, this.currencies);

  @override
  List<Object> get props => [selectedCurrency, currencies];
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError(this.message);

  @override
  List<Object> get props => [message];
}
