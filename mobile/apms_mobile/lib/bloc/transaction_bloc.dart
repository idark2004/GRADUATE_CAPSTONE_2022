import 'package:apms_mobile/bloc/repositories/transaction_repo.dart';
import 'package:apms_mobile/models/transaction_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/transaction_event.dart';
part 'states/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepo _repo;
  TransactionBloc(this._repo) : super(TransactionInitial()) {
    on<GetTransactionHistory>(_getList);
    on<ChangeHistoryDate>(
      (event, emit) => emit(TransactionInitial()),
    );
    on<ChangeTransactionType>(
      (event, emit) => emit(TransactionInitial()),
    );
  }

  _getList(GetTransactionHistory event, Emitter<TransactionState> emit) async {
    !event.loadMore ? emit(GettingTransactionList()) : "";
    List ticketModels = await Future.wait([
      _repo.getList(event.from, event.to, event.typeValue, event.pageIndex)
    ]);
    emit(GotTransactionList(ticketModels[0]));
  }
}
