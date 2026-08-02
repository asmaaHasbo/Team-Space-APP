part of 'spaces_cubit.dart';

sealed class SpacesState extends Equatable {
  const SpacesState();
  @override
  List<Object?> get props => [];
}

// ── list states (drive the screen) ──

final class SpacesInitial extends SpacesState {
  const SpacesInitial();
}

final class SpacesLoading extends SpacesState {
  const SpacesLoading();
}

final class SpacesLoaded extends SpacesState {
  final List<Space> spaces;
  const SpacesLoaded(this.spaces);
  @override
  List<Object?> get props => [spaces];
}

final class SpacesError extends SpacesState {
  final String message;
  const SpacesError(this.message);
  @override
  List<Object?> get props => [message];
}
// ── create-space action states (listened to, don't rebuild the list) ──

final class CreateSpaceLoading extends SpacesState {
  const CreateSpaceLoading();
}

final class CreateSpaceSuccess extends SpacesState {
  const CreateSpaceSuccess();
}

final class CreateSpaceError extends SpacesState {
  final String message;
  const CreateSpaceError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── join-space action states ──

final class JoinSpaceLoading extends SpacesState {
  const JoinSpaceLoading();
}

final class JoinSpaceSuccess extends SpacesState {
  const JoinSpaceSuccess();
}

final class JoinSpaceError extends SpacesState {
  final String message;
  const JoinSpaceError(this.message);
  @override
  List<Object?> get props => [message];
}