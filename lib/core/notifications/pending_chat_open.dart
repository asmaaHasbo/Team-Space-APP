class PendingChatOpen {
  String? _chatId;

  void set(String chatId) => _chatId = chatId;

  /// يرجّع اللي مستني ويمسحه — عشان ميتفتحش مرتين
  String? take() {
    final chatId = _chatId;
    _chatId = null;
    return chatId;
  }
}