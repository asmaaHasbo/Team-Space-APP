import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/handle_errors.dart';
import '../models/space_model.dart';

abstract interface class SpacesRemoteDataSource {
  Future<List<SpaceModel>> getMySpaces();

  Future<SpaceModel> createSpace({required String name});

  Future<SpaceModel> joinByCode({required String inviteCode});
}

class SpacesRemoteDataSourceImpl implements SpacesRemoteDataSource {
  final SupabaseClient _client;

  SpacesRemoteDataSourceImpl(this._client);

  @override
  Future<List<SpaceModel>> getMySpaces() async {
    try {
      // RLS ("members can view their spaces") filters this to only the
      // spaces the current user belongs to — no where-clause needed here.
      final rows = await _client.from('spaces').select();
      return rows.map((json) => SpaceModel.fromJson(json)).toList();
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<SpaceModel> createSpace({required String name}) async {
    try {
      // One round-trip: the Postgres function does both inserts
      // (space + owner membership) atomically and returns the new space.
      final row = await _client.rpc(
        'create_space_with_owner',
        params: {'space_name': name},
      );
      return SpaceModel.fromJson(row);
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<SpaceModel> joinByCode({required String inviteCode}) async {
    try {
      // 1. Find the space by its invite code (throws if code is wrong —
      //    caught below and surfaced to the cubit).
      final spaceRow = await _client
          .from('spaces')
          .select()
          .eq('invite_code', inviteCode)
          .single();

      final space = SpaceModel.fromJson(spaceRow);

      // 2. Add myself as a member. upsert + ignoreDuplicates: if I'm
      //    already in this space, do nothing (don't overwrite my role) —
      //    so re-clicking an invite link just lets me back in cleanly.
      await _client.from('space_members').upsert(
        {
          'space_id': space.id,
          'user_id': _client.auth.currentUser!.id,
          'role': 'member',
        },
        ignoreDuplicates: true,
      );

      return space;
    } catch (e) {
      return handleError(e);
    }
  }
}