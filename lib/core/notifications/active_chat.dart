class ActiveChat {
  String? _chatId;

  void enter(String chatId) => _chatId = chatId;

  void leave(String chatId) {
    if (_chatId == chatId) _chatId = null;
  }

  bool isOpen(String chatId) => _chatId == chatId;
}