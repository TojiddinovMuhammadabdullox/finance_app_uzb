import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_event.dart';
import 'currency_state.dart';
import '../repository/currency_repository.dart';
import 'package:rxdart/rxdart.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository repository;

  CurrencyBloc(this.repository) : super(CurrencyInitial()) {
    on<FetchCurrencies>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final currencies = await repository.fetchCurrencies();
        emit(CurrencyLoaded(currencies));
      } catch (e) {
        emit(CurrencyError(e.toString()));
      }
    });

    on<SearchCurrencies>((event, emit) async {
      if (event.query.isEmpty) {
        emit(CurrencyInitial());
      } else {
        emit(CurrencyLoading());
        try {
          final currencies = await repository.searchCurrencies(event.query);
          emit(CurrencySearchLoaded(currencies));
        } catch (e) {
          emit(CurrencyError(e.toString()));
        }
      }
    }, transformer: debounce(Duration(milliseconds: 300)));

    on<SelectCurrency>((event, emit) {
      final currentState = state;
      if (currentState is CurrencyLoaded ||
          currentState is CurrencySearchLoaded) {
        final selectedCurrency = currentState.currencies.firstWhere(
          (currency) => currency.code.toLowerCase() == event.code.toLowerCase(),
          orElse: () => null,
        );
        if (selectedCurrency != null) {
          emit(CurrencySelected(selectedCurrency, currentState.currencies));
        }
      }
    });
  }

  EventTransformer<CurrencyEvent> debounce<CurrencyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
