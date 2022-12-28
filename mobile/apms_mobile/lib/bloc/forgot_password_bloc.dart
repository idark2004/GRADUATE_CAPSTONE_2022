import 'package:apms_mobile/bloc/repositories/forgot_password_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/forgot_password_event.dart';
part 'states/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepo _repo;
  ForgotPasswordBloc(this._repo) : super(ForgotPasswordInitial()) {
    on<SubmitPhoneNumber>(_checkPhone);
    on<SubmitNewPassword>(_createNewPassword);
  }

  _checkPhone(
      SubmitPhoneNumber event, Emitter<ForgotPasswordState> emit) async {
    emit(CheckingPhoneNumber());
    bool result = await _repo.checkPhoneNumber(event.phoneNumber);
    if (result) {
      emit(PhoneNumberExist());
    } else {
      emit(PhoneNumberNotExist());
    }
  }

  _createNewPassword(
      SubmitNewPassword event, Emitter<ForgotPasswordState> emit) async {
    emit(CreatingNewPassword());
    bool result =
        await _repo.createNewPassword(event.phoneNumber, event.password);
    if (result) {
      emit(NewPasswordCreated());
    } else {
      emit(CreateNewPasswordError());
    }
  }
}
