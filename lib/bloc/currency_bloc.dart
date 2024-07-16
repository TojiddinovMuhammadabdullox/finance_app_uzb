import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_event.dart';
import 'currency_state.dart';
import '../repository/currency_repository.dart';

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
  }
}
