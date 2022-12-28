import 'package:apms_mobile/bloc/repositories/topup_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/topup_event.dart';
part 'states/topup_state.dart';

final TopupRepo repo = TopupRepo();

class TopupBloc extends Bloc<TopupEvent, TopupState> {
  TopupBloc() : super(TopupInitial()) {
    on<FetchExchangeRate>(_fetchExchangeRate);
    on<MakeTopupTransaction>(_makeTopupTransaction);
  }

  _fetchExchangeRate(FetchExchangeRate event, Emitter<TopupState> emit) async {
    try {
      emit(ExchangeRateFetching());
      int result = await repo.getExchangeRate();
      emit(ExchangeRateFetchedSuccessfully(result));
    } catch (e) {
      emit(ExchangeRateFetchedFailed());
    }
  }

  _makeTopupTransaction(
      MakeTopupTransaction event, Emitter<TopupState> emit) async {
    try {
      emit(TopupTransactionProcessing());
      var result = await repo.makeTopupTransaction(event.amount);
      emit(TopupTransactionProcessedSuccessfully(result["message"]));
    } catch (e) {
      emit(TopupTransactionProcessedFailed());
    }
  }
}
