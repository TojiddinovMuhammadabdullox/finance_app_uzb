import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class FetchCurrencies extends CurrencyEvent {}

class SearchCurrencies extends CurrencyEvent {
  final String query;

  const SearchCurrencies(this.query);

  @override
  List<Object> get props => [query];
}

class SelectCurrency extends CurrencyEvent {
  final String code;

  const SelectCurrency(this.code);

  @override
  List<Object> get props => [code];
}
