import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chats_search_field.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_action_dialog.dart';
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
  /// Search belongs to the chats list, so the icon only shows on its tab.
  static const int _chatsTabIndex = 0;

  int _currentIndex = 0;
  bool _isSearching = false;

  void _onTabSelected(int index) {
    if (_isSearching) _closeSearch();
    setState(() => _currentIndex = index);
  }

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    context.read<ChatsCubit>().clearSearch();
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: !_isSearching,
        title: _isSearching
            ? const ChatsSearchField()
            : const SpaceSwitcherButton(),
        actions: _isSearching
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _closeSearch,
                ),
              ]
            : [
                if (_currentIndex == _chatsTabIndex)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _openSearch,
                  ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    SpaceActionDialog.show(context, SpaceDialogMode.create);
                  },
                ),
              ],
      ),
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
