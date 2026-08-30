import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/shimmer/image_shimmer.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/presentation/helper/avatar_tint.dart';

/// A member's photo — falls back to their initials on the tint that name
/// always lands on, both when there is no photo and when it fails to load.
class MemberAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const MemberAvatar({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final tint = AvatarTint.of(name);
    final diameter = size.w;
    final url = avatarUrl;

    // Built once and reused by both branches — the same circle either way.
    final initials = Text(
      AvatarTint.initialsOf(name),
      style: AppTextStyles.font15Bold.copyWith(
        color: tint.foreground,
        fontSize: (size * 0.34).sp,
      ),
    );

    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tint.background,
        shape: BoxShape.circle,
      ),
      child: url == null || url.isEmpty
          ? initials
          : CachedNetworkImage(
              imageUrl: url,
              width: diameter,
              height: diameter,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  ImageShimmer(width: diameter, height: diameter),
              errorWidget: (_, _, _) => initials,
            ),
    );
  }
}
