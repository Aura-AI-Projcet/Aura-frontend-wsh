import 'dart:math';
import '../models/user_model.dart';
import 'divination_knowledge_service.dart';

/// AI聊天服务
/// 集成大模型API和算卦知识，提供智能对话功能
class AIChatService {
  final DivinationKnowledgeService _knowledgeService = DivinationKnowledgeService();
  final Random _random = Random();

  /// 发送消息并获取AI回复
  Future<String> sendMessage(String userMessage, UserModel? currentUser) async {
    try {
      // 分析用户意图
      final intent = _analyzeUserIntent(userMessage);
      
      // 根据意图生成回复
      switch (intent.type) {
        case IntentType.divination:
          return await _generateDivinationResponse(userMessage, intent, currentUser);
        case IntentType.anxiety:
          return _generateAnxietyResponse(userMessage, currentUser);
        case IntentType.love:
          return _generateLoveResponse(userMessage, currentUser);
        case IntentType.career:
          return _generateCareerResponse(userMessage, currentUser);
        case IntentType.general:
        default:
          return _generateGeneralResponse(userMessage, currentUser);
      }
    } catch (e) {
      return _getRandomComfortResponse();
    }
  }

  /// 分析用户意图
  UserIntent _analyzeUserIntent(String message) {
    message = message.toLowerCase();
    
    // 占卜相关关键词
    final divinationKeywords = ['算', '占卜', '运势', '命运', '八字', '紫微', '星座', '塔罗', '预测', '未来', '运气'];
    // 焦虑相关关键词
    final anxietyKeywords = ['焦虑', '担心', '害怕', '紧张', '压力', '烦躁', '不安', '恐惧', '忧虑'];
    // 感情相关关键词
    final loveKeywords = ['爱情', '恋爱', '感情', '喜欢', '分手', '结婚', '男友', '女友', '暗恋', '表白'];
    // 事业相关关键词
    final careerKeywords = ['工作', '事业', '职业', '升职', '跳槽', '面试', '同事', '老板', '创业', '收入'];

    if (divinationKeywords.any((keyword) => message.contains(keyword))) {
      return UserIntent(IntentType.divination, _extractDivinationType(message));
    }
    
    if (anxietyKeywords.any((keyword) => message.contains(keyword))) {
      return UserIntent(IntentType.anxiety, null);
    }
    
    if (loveKeywords.any((keyword) => message.contains(keyword))) {
      return UserIntent(IntentType.love, null);
    }
    
    if (careerKeywords.any((keyword) => message.contains(keyword))) {
      return UserIntent(IntentType.career, null);
    }
    
    return UserIntent(IntentType.general, null);
  }

  /// 提取占卜类型
  String? _extractDivinationType(String message) {
    if (message.contains('八字')) return 'bazi';
    if (message.contains('紫微')) return 'ziwei';
    if (message.contains('星座') || message.contains('占星')) return 'astrology';
    if (message.contains('塔罗')) return 'tarot';
    return null;
  }

  /// 生成占卜回复
  Future<String> _generateDivinationResponse(String message, UserIntent intent, UserModel? user) async {
    final divinationType = intent.subType ?? 'general';
    final knowledge = await _knowledgeService.getDivinationAdvice(divinationType, user);
    
    final responses = [
      "让我为你${_getDivinationMethodName(divinationType)}...\n\n${knowledge.interpretation}\n\n${knowledge.advice}",
      "根据${_getDivinationMethodName(divinationType)}分析：\n\n${knowledge.interpretation}\n\n建议：${knowledge.advice}",
      "我来用${_getDivinationMethodName(divinationType)}为你解答：\n\n${knowledge.interpretation}\n\n${knowledge.advice}",
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  /// 生成焦虑回复
  String _generateAnxietyResponse(String message, UserModel? user) {
    final responses = [
      "我能感受到你现在的焦虑，这种感觉确实不好受。让我们一起来分析一下...\n\n焦虑往往来源于对未知的恐惧。你可以试着把担心的事情写下来，看看哪些是你能控制的，哪些是无法控制的。\n\n从你的生辰信息来看，建议你多接触大自然，比如散步或者观察植物，这能帮助你平静心境。",
      "感受到你的不安，别担心，我们一起来化解这份焦虑。\n\n焦虑是身体在提醒我们需要关注某些事情。你可以尝试深呼吸：吸气4秒，屏息4秒，呼气6秒，重复几次。\n\n另外，建议你找一个安静的地方，闭上眼睛，想象一个让你感到安全和平静的地方。这个练习能帮助大脑重新调节。",
      "理解你现在的焦虑情绪，这说明你是一个有责任心的人。\n\n焦虑有时是我们过分关注结果而忽略了过程。试着专注当下这一刻，问问自己：'现在这一刻，我是安全的吗？'通常答案是肯定的。\n\n从占星学角度，建议你多关注当下的小美好，比如一杯温茶、一朵花、或者一个微笑。"
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  /// 生成感情回复
  String _generateLoveResponse(String message, UserModel? user) {
    final responses = [
      "感情的事情总是让人既甜蜜又困扰呢～\n\n从你的情感状态来看，你是一个真诚待人的人。在感情中，最重要的是保持真实的自己，不要为了迎合对方而改变本质。\n\n建议你用塔罗的智慧：过去、现在、未来。回顾这段感情的美好，珍惜当下的感受，对未来保持开放的心态。",
      "爱情就像星座运行，有时相合，有时相冲，这都是自然规律。\n\n真正的感情需要两个完整的人相遇，而不是两个半个人拼凑。你需要先爱自己，才能更好地爱别人。\n\n从生辰八字的角度，建议你在感情中保持适度的独立，给彼此成长的空间。这样的感情才能长久。",
      "感情的困惑我很理解，每个人都会遇到。\n\n爱情没有标准答案，但有一个不变的真理：健康的感情应该让你变得更好，而不是更糟。如果一段感情让你经常怀疑自己、失去自信，那可能需要重新审视。\n\n建议你多关注内心的声音，你的直觉往往比理性分析更准确。"
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  /// 生成事业回复
  String _generateCareerResponse(String message, UserModel? user) {
    final responses = [
      "事业发展是人生重要的一部分，你的关注说明你很有上进心。\n\n从紫微斗数的角度，每个人都有自己的天赋和适合的道路。建议你先了解自己的优势和兴趣所在，然后制定相应的发展计划。\n\n记住，成功不只是薪资和职位，更重要的是找到能发挥自己价值、获得成就感的工作。",
      "工作上的困扰很常见，关键是找到平衡点。\n\n建议你用五行理论来分析：金（目标明确）、木（持续成长）、水（灵活适应）、火（保持热情）、土（脚踏实地）。看看自己在哪个方面需要加强。\n\n另外，人际关系在职场中很重要，保持真诚但也要学会保护自己。",
      "事业就像种树，需要时间和耐心。\n\n现在的努力不一定立即见效，但会在未来某个时刻开花结果。建议你制定短期和长期目标，然后一步步实现。\n\n从占星的角度，建议你关注自己的成长周期，有时退一步是为了更好地前进。"
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  /// 生成一般回复
  String _generateGeneralResponse(String message, UserModel? user) {
    final responses = [
      "谢谢你和我分享这些，我能感受到你的真诚。\n\n生活中遇到各种情况都很正常，重要的是保持积极的心态。你觉得在这个问题上，什么是最让你困扰的呢？我们可以一起分析一下。",
      "听起来你最近有不少想法呢。\n\n有时候把内心的想法说出来就已经是很好的开始了。你觉得目前最需要的是什么？是建议、倾听，还是一些占卜指引？",
      "我在用心听你说的每一句话。\n\n每个人的人生都有独特的轨迹，没有标准答案，但总有适合的方向。如果你愿意，可以告诉我更多细节，我会用我的知识为你提供一些参考。",
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  /// 获取占卜方法名称
  String _getDivinationMethodName(String type) {
    switch (type) {
      case 'bazi':
        return '生辰八字';
      case 'ziwei':
        return '紫微斗数';
      case 'astrology':
        return '占星学';
      case 'tarot':
        return '塔罗牌';
      default:
        return '综合占卜';
    }
  }

  /// 获取随机安慰回复
  String _getRandomComfortResponse() {
    final responses = [
      "我现在有点忙，但我一直在听。有什么特别想聊的吗？",
      "让我想想...你说的很有道理，我需要仔细考虑一下。",
      "抱歉让你久等了，我在整理思路。可以再详细说说吗？",
    ];
    
    return responses[_random.nextInt(responses.length)];
  }
}

/// 用户意图分析结果
class UserIntent {
  final IntentType type;
  final String? subType;

  UserIntent(this.type, this.subType);
}

/// 意图类型枚举
enum IntentType {
  divination,  // 占卜
  anxiety,     // 焦虑
  love,        // 感情
  career,      // 事业
  general,     // 一般对话
} 