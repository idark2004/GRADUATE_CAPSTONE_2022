part of '../feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class SubmitFeedback extends FeedbackEvent {
  final String description;

  const SubmitFeedback(this.description);
  @override
  List<Object> get props => [description];
}
