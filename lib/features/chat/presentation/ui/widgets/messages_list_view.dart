import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/message_bubble.dart';

class MessagesListView extends StatefulWidget {
  final List<Message> messages;
  final bool isGroup;
  final Map<String, SpaceMember> membersById;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final VoidCallback onLoadMore;

  const MessagesListView({
    super.key,
    required this.messages,
    required this.isGroup,
    required this.membersById,
    required this.isLoadingMore,
    required this.hasReachedEnd,
    required this.onLoadMore,
  });

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  // reverse: true means "the end of the scroll" is the oldest message.
  void _onScroll() {
    //«لو أنا أصلًا بحمّل دلوقتي، أو مفيش رسايل أقدم خلاص — ماتعملش حاجة»
    if (widget.isLoadingMore || widget.hasReachedEnd) return;
    // «لو باقي أقل من 200 بكسل على نهاية السكرول، ابدأ جيب رسايل أقدم»
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final reversedMessages = widget.messages.reversed.toList();

    return ColoredBox(
      color: AppColors.chatBackground,
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: reversedMessages.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == reversedMessages.length) {
            return Padding(
              padding: EdgeInsets.all(12.w),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }

          final message = reversedMessages[index];
          final senderId = message.senderId;

          // The list runs newest first, so the item after this one is the
          // message that came right before it — a run of messages from the
          // same person shows one face and one name at its start.
          final previousIndex = index + 1;
          final previous = previousIndex < reversedMessages.length
              ? reversedMessages[previousIndex]
              : null;

          return MessageBubble(
            message: message,
            isMe: senderId == currentUserId,
            isGroup: widget.isGroup,
            sender: senderId == null ? null : widget.membersById[senderId],
            startsSenderRun: previous == null || previous.senderId != senderId,
          );
        },
      ),
    );
  }
}
