// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wafed/core/themes/app_colors.dart';
// import 'package:wafed/core/themes/app_text_styles.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final VoidCallback? onBackPressed;
//   final List<Widget>? actions;
//   final bool showBackButton;

//   const CustomAppBar({
//     super.key,
//     this.title,
//     this.onBackPressed,
//     this.actions,
//     this.showBackButton = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       leading: showBackButton
//           ? IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: AppColors.black,
//                 size: 24.w,
//               ),
              

//               // Image.asset(
//               //   'assets/images/back.png',
//               //   width: 24.w,
//               //   height: 24.h,
//               // ),

//               onPressed: onBackPressed ?? () => Navigator.pop(context),
//             )
//           : null,
//       title: title != null
//           ? Text(
//               title!,
//               style: AppTextStyles.font25Bold.copyWith(color: AppColors.black),
//               textAlign: TextAlign.start,
//             )
//           : null,
//       actions: actions,
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(56.h);
// }


