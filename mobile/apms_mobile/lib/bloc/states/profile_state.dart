part of '../profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileFetching extends ProfileState {}

class ProfileFetchedFailed extends ProfileState {}

class ProfileFetchedSuccessfully extends ProfileState {
  final ProfileModel profile;
  const ProfileFetchedSuccessfully(this.profile);
}
