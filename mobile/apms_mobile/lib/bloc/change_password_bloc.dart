import 'package:apms_mobile/bloc/repositories/change_password_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/change_password_event.dart';
part 'states/change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepo _repo;
  ChangePasswordBloc(this._repo) : super(ChangePasswordInitial()) {
    on<SubmittingPasswordChange>(_changePassword);
  }

  _changePassword(
      SubmittingPasswordChange event, Emitter<ChangePasswordState> emit) async {
    emit(ChangingPassword());
    String result =
        await _repo.changePassword(event.oldPassword, event.newPassword);
    if (result.contains('successfully!')) {
      emit(PasswordChanged());
    } else {
      emit(ChangePasswordError(result));
    }
  }
}
