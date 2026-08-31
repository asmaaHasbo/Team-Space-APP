
part of 'space_members_cubit.dart';

sealed class SpaceMembersState extends Equatable {
  const SpaceMembersState();
  @override
  List<Object?> get props => [];
}

class SpaceMembersInitial extends SpaceMembersState {
  const SpaceMembersInitial();
}

class SpaceMembersLoading extends SpaceMembersState {
  const SpaceMembersLoading();
}

class SpaceMembersLoaded extends SpaceMembersState {
  const SpaceMembersLoaded(this.members);
  final List<SpaceMember> members;
  @override
  List<Object?> get props => [members];
}

class SpaceMembersError extends SpaceMembersState {
  const SpaceMembersError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}