// import 'package:flutter/material.dart';

// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   String _username = 'User';
//   String _email = 'user@example.com';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final userData = await UserDataHelper.getUserData();
//     setState(() {
//       _username = userData['username']!;
//       _email = userData['email']!;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.6,

//       child: Column(
//         children: [
//           _buildDrawerHeader(context),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerItem(
//                   context: context,
//                   icon: Icons.home_outlined,
//                   title: 'Home',
//                   route: Routes.mainScreen,
//                 ),
//                 _buildDrawerItem(
//                   context: context,
//                   icon: Icons.favorite_outline,
//                   title: 'Wishlist',
//                   route: Routes.wishlistScreen,
//                 ),
//                 // _buildDrawerItem(
//                 //   context: context,
//                 //   icon: Icons.person_outline,
//                 //   title: 'Profile',
//                 //   onTap: () {
//                 //     Navigator.pop(context);
//                 //     // Navigate to profile if needed
//                 //   },
//                 // ),

//                 //
//                 _buildDrawerItem(
//                   context: context,
//                   icon: Icons.info_outline,
//                   title: 'About',
//                   route: Routes.aboutScreen,
//                 ),
//               ],
//             ),
//           ),
//           _buildLogoutItem(context),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
//       decoration: const BoxDecoration(color: AppColors.mainColor),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: const Icon(
//               Icons.person,
//               size: 30,
//               color: AppColors.mainColor,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Welcome, $_username!',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             _email,
//             style: const TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     String? route,
//     VoidCallback? onTap,
//   }) {
//     final isCurrentRoute =
//         route != null && ModalRoute.of(context)?.settings.name == route;

//     return ListTile(
//       leading: Icon(
//         icon,
//         color: isCurrentRoute ? AppColors.mainColor : AppColors.lightGray,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isCurrentRoute ? AppColors.mainColor : AppColors.darkBlack,
//           fontWeight: isCurrentRoute ? FontWeight.w600 : FontWeight.normal,
//         ),
//       ),
//       selected: isCurrentRoute,
//       selectedTileColor: AppColors.mainColor.withValues(alpha: 0.1),
//       onTap:
//           onTap ??
//           () {
//             Navigator.pop(context);
//             if (route != null && !isCurrentRoute) {
//               Navigator.pushReplacementNamed(context, route);
//             }
//           },
//     );
//   }

//   Widget _buildLogoutItem(BuildContext context) {
//     return ListTile(
//       leading: const Icon(Icons.logout, color: AppColors.orange),
//       title: const Text(
//         'Logout',
//         style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
//       ),
//       onTap: () {
//         Navigator.pop(context);
//         LogoutHelper.showLogoutDialog(context);
//       },
//     );
//   }
// }
