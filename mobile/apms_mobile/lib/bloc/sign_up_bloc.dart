import 'package:apms_mobile/bloc/repositories/sign_up_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/sign_up_event.dart';
part 'states/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepo repo;
  SignUpBloc(this.repo) : super(SignUpInitial()) {
    on<SignUpSubmiting>(_submitSignUp);
  }

  _submitSignUp(SignUpSubmiting event, Emitter<SignUpState> emit) async {
    emit(SigningUp());
    String result = await repo.signUp(
      event.phoneNumber,
      event.fullName,
      event.password,
    );
    if (!result.contains("used!")) {
      emit(SignedUp());
    } else {
      emit(SignUpError(result));
    }
  }
}
