import 'package:equatable/equatable.dart';
import 'package:team_space/core/shared/cubit/safe_cubit.dart';

import '../../../../../core/error/handle_errors.dart';
import '../../../domain/entities/space_member.dart';
import '../../../domain/usecases/get_space_members.dart';
part 'space_members_state.dart';

class SpaceMembersCubit extends SafeCubit<SpaceMembersState> {
  final GetSpaceMembers _getSpaceMembers;
  SpaceMembersCubit({required GetSpaceMembers getSpaceMembers})
    : _getSpaceMembers = getSpaceMembers,
      super(const SpaceMembersInitial());

  Future<void> getSpaceMembers({required String spaceId}) async {
    if (state is SpaceMembersLoading) return;
    emit(const SpaceMembersLoading());
    try {
      final members = await _getSpaceMembers(spaceId: spaceId);
      emit(SpaceMembersLoaded(members));
    } on AppException catch (e) {
      emit(SpaceMembersError(e.message));
    }
  }
}
