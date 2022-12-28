import 'package:apms_mobile/bloc/repositories/feedback_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/feedback_event.dart';
part 'states/feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepo _repo;
  FeedbackBloc(this._repo) : super(FeedbackInitial()) {
    on<SubmitFeedback>(_sendFeedback);
  }

  _sendFeedback(SubmitFeedback event, Emitter<FeedbackState> emit) async {
    emit(SendingFeedback());
    String result = await _repo.sendFeedback(event.description);
    if (result.contains('successfully!')) {
      emit(FeedbackSent());
    } else {
      emit(FeedbackError(result));
    }
  }
}
