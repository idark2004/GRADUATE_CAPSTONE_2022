part of '../feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class SendingFeedback extends FeedbackState {}

class FeedbackSent extends FeedbackState {}

class FeedbackError extends FeedbackState {
  final String error;

  const FeedbackError(this.error);

  @override
  List<Object> get props => [error];
}
