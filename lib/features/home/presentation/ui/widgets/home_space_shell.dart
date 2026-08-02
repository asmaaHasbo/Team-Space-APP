import 'package:flutter/material.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_bottom_nav.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_switcher_button.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/chats_tab.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/storage_tab.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/tasks_tab.dart';
import 'package:team_space/features/profile/presentation/ui/screens/profile_screen.dart';

/// The tabbed home shell. Only rendered once the user has at least one space,
/// because every tab below shows content that lives inside a space.
class HomeSpaceShell extends StatefulWidget {
  const HomeSpaceShell({super.key});

  @override
  State<HomeSpaceShell> createState() => _HomeSpaceShellState();
}

class _HomeSpaceShellState extends State<HomeSpaceShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SpaceSwitcherButton()),
      body: IndexedStack(
        index: _currentIndex,
        children: const [ChatsTab(), TasksTab(), StorageTab(), ProfileScreen()],
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
