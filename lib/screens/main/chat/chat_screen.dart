import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../services/ai_chat_service.dart';


/// 聊天页面
/// 用户与AI占卜师对话的主要界面
class ChatScreen extends StatefulWidget {
  final UserModel? currentUser;

  const ChatScreen({
    super.key,
    this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late AIChatService _aiService;

  @override
  void initState() {
    super.initState();
    _aiService = AIChatService();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 初始化聊天，发送智能开场白
  Future<void> _initializeChat() async {
    // 等待一下让界面先渲染
    await Future.delayed(const Duration(milliseconds: 500));
    
    String openingMessage = _generateOpeningMessage();
    
    setState(() {
      _messages.add(ChatMessage(
        content: openingMessage,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    
    _scrollToBottom();
  }

  /// 根据用户信息生成开场白
  String _generateOpeningMessage() {
    final user = widget.currentUser;
    if (user == null) {
      return "你好！我是你的专属占卜师，很高兴为你提供情感陪伴和占卜指导。有什么想聊的吗？";
    }

    String nickname = user.nickname?.isNotEmpty == true ? user.nickname! : "朋友";
    String companionIntro = _getCompanionIntro(user.companionPersona);
    String birthdayContext = _getBirthdayContext(user.birthday);
    
    return "$companionIntro\n\n"
        "你好$nickname！很高兴与你相遇。✨\n\n"
        "${birthdayContext.isNotEmpty ? '$birthdayContext\n\n' : ''}"
        "我精通生辰八字、紫微斗数、占星和塔罗，可以为你提供情感指导、运势分析和人生建议。有什么想了解的吗？";
  }

  /// 根据陪伴形象生成介绍
  String _getCompanionIntro(String? companionPersona) {
    switch (companionPersona) {
      case 'xiaoman':
        return "你好，我是星语者·小满，一位温柔智慧的星语解读者。我善于倾听心灵的声音，通过星辰的指引为你解读情感的密码。";
      case 'qingyang':
        return "道友你好，在下云游道士·青阳。我游历四方，精通易经八卦，善于运用古老的智慧为迷茫的心灵指点迷津。";
      default:
        return "你好，我是你的专属占卜师，很高兴能够陪伴你踏上这段心灵探索的旅程。";
    }
  }



  /// 根据生日生成上下文
  String _getBirthdayContext(DateTime? birthday) {
    if (birthday == null) return "";
    
    int age = DateTime.now().year - birthday.year;
    String zodiacSign = _getZodiacSign(birthday);
    
    return "根据你的生辰信息，你是$zodiacSign座，今年$age岁。$zodiacSign座的特质我很了解哦！";
  }

  /// 获取星座
  String _getZodiacSign(DateTime date) {
    int month = date.month;
    int day = date.day;
    
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "白羊";
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return "金牛";
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return "双子";
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return "巨蟹";
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return "狮子";
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return "处女";
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return "天秤";
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return "天蝎";
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return "射手";
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return "摩羯";
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return "水瓶";
    return "双鱼";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: _buildMessageList(),
          ),
          // 输入区域
          _buildInputArea(),
        ],
      ),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: AppColors.shadow.withOpacity(0.1),
      title: Row(
        children: [
          // AI头像
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '占卜师小雅',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '在线 · 随时为你占卜',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: _showChatMenu,
        ),
      ],
    );
  }

  /// 构建消息列表
  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          // 加载指示器
          return _buildLoadingIndicator();
        }
        
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            // AI头像
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          // 消息内容
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: AppTextStyles.body1.copyWith(
                  color: message.isUser ? Colors.white : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            // 用户头像
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.accent,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // AI头像
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          // 打字指示器
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建打字动画点
  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: Duration(milliseconds: 600 + index * 200),
      builder: (context, value, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        // 循环动画
        if (mounted && _isLoading) {
          setState(() {});
        }
      },
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 输入框
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: '说说你的困惑...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTextStyles.body1,
                  maxLines: 4,
                  minLines: 1,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 发送按钮
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 发送消息
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    // 添加用户消息
    setState(() {
      _messages.add(ChatMessage(
        content: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // 获取AI回复
      final response = await _aiService.sendMessage(text, widget.currentUser);
      
      setState(() {
        _messages.add(ChatMessage(
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          content: "抱歉，我现在有点忙，稍后再聊好吗？",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  /// 滚动到底部
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

  /// 显示聊天菜单
  void _showChatMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('重新开始对话'),
              onTap: () {
                Navigator.pop(context);
                _clearAndRestart();
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('占卜专题'),
              onTap: () {
                Navigator.pop(context);
                _showDivinationTopics();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 清除对话并重新开始
  void _clearAndRestart() {
    setState(() {
      _messages.clear();
    });
    _initializeChat();
  }

  /// 显示占卜专题
  void _showDivinationTopics() {
    // TODO: 实现占卜专题选择
  }
}

/// 聊天消息模型
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
} 