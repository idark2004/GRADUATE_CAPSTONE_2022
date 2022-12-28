import 'package:apms_mobile/bloc/repositories/profile_repo.dart';
import 'package:apms_mobile/models/profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'events/profile_event.dart';
part 'states/profile_state.dart';

final repo = ProfileRepo();
final token = SharedPreferences.getInstance();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileInformation>(_fetchProfileInformation);
  }

  _fetchProfileInformation(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileFetching());
      ProfileModel result = await repo.getProfilePersonalInformation();
      emit(ProfileFetchedSuccessfully(result));
    } catch (e) {
      emit(ProfileFetchedFailed());
    }
  }
}
