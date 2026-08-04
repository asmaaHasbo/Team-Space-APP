import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/features/profile/presentation/ui/widgets/profile_stat_item.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

/// The spaces counter inside the profile stats card. It owns the only piece of
/// state the card needs, so the rest of the card never rebuilds with it.
class ProfileSpacesStat extends StatelessWidget {
  const ProfileSpacesStat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SpacesCubit, SpacesState, int?>(
      selector: (state) => switch (state) {
        SpacesLoaded(:final spaces) => spaces.length,
        // no spaces is a known answer, unlike loading or a failed load
        SpacesEmpty() => 0,
        _ => null,
      },
      builder: (context, count) => ProfileStatItem(
        label: context.tr('profile.spaces'),
        value: count?.toString() ?? '—',
      ),
    );
  }
}
