import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/chat_message.dart';
import '../services/chatbot_service.dart';
import '../widgets/chat_bubble.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<String> _quickSuggestions = [
    '✨ Recommend shampoo for hair fall & dandruff',
    '🌿 I have dry sensitive skin, what should I use?',
    '🛍️ Add 2 rose soaps and 1 hair oil to cart',
    '🧪 How is cold process herbal soap made?',
  ];

  @override
  void initState() {
    super.initState();
    // Initial welcome message
    _messages.add(
      ChatMessage(
        id: 'msg-0',
        text: "Namaste! 🌿 I am your HERBSKIN HEAVEN AI Botanical Consultant.\n\nAsk me for skin & hair diagnoses, cold-process formulation advice, live stock status, or tell me what to add to your bag!",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? textToSend]) async {
    final messageText = textToSend ?? _inputController.text.trim();
    if (messageText.isEmpty) return;

    if (textToSend == null) _inputController.clear();

    final userMessage = ChatMessage(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });
    _scrollToBottom();

    final response = await ChatbotService.sendMessage(messageText);

    List<SuggestedItem>? suggestedItems;
    if (response['items'] != null && response['items'] is List) {
      suggestedItems = (response['items'] as List)
          .map((i) => SuggestedItem.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    final aiReply = ChatMessage(
      id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
      text: response['reply'] ?? 'I have received your herbal query.',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedCartItems: suggestedItems,
      actionType: response['action'],
    );

    setState(() {
      _messages.add(aiReply);
      _isTyping = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.brand100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.brand700, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Herbal AI Assistant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(
                  'Powered by Gemini & Herbal Knowledge Base',
                  style: TextStyle(fontSize: 10, color: AppColors.brand700, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubbleWidget(message: _messages[index]);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: const [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brand600),
                  ),
                  SizedBox(width: 8),
                  Text('AI is formulating response...', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),

          // Quick Prompt Suggestions
          if (_messages.length <= 2)
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickSuggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ActionChip(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.brand100),
                    label: Text(
                      _quickSuggestions[index],
                      style: const TextStyle(fontSize: 11, color: AppColors.brand900, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () => _sendMessage(_quickSuggestions[index]),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask anything or say "Order 2 rose soaps"...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surfaceMuted,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.brand600,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
