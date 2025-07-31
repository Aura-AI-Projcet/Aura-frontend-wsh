import 'dart:math';
import '../models/user_model.dart';

/// 占卜知识库服务
/// 提供生辰八字、紫微斗数、占星学、塔罗等算卦知识
class DivinationKnowledgeService {
  final Random _random = Random();

  /// 获取占卜建议
  Future<DivinationResult> getDivinationAdvice(String type, UserModel? user) async {
    switch (type) {
      case 'bazi':
        return _getBaziAdvice(user);
      case 'ziwei':
        return _getZiweiAdvice(user);
      case 'astrology':
        return _getAstrologyAdvice(user);
      case 'tarot':
        return _getTarotAdvice(user);
      default:
        return _getGeneralAdvice(user);
    }
  }

  /// 生辰八字分析
  DivinationResult _getBaziAdvice(UserModel? user) {
    final elements = ['金', '木', '水', '火', '土'];
    final primaryElement = elements[_random.nextInt(elements.length)];
    final secondaryElement = elements[_random.nextInt(elements.length)];
    
    final interpretations = {
      '金': '你的性格坚毅果断，有很强的执行力。金主收敛，适合在秋季（7-9月）做重要决定。',
      '木': '你充满生命力和创造力，善于成长和适应。木主生发，春季（1-3月）是你的旺运期。',
      '水': '你聪明灵活，善于应变和思考。水主流动，适合从事需要智慧和变通的工作。',
      '火': '你热情开朗，有很强的感染力。火主炎上，夏季（4-6月）是你的能量最旺盛的时候。',
      '土': '你稳重可靠，是很好的朋友和合作伙伴。土主承载，具有很强的包容力和耐心。'
    };

    final advices = {
      '金': '建议多接触自然，平衡过于强硬的性格。可以尝试园艺或者冥想来柔化内心。',
      '木': '保持学习和成长的心态，但也要注意适度休息，避免过度消耗自己的能量。',
      '水': '你的智慧是天赋，但要避免过度思考导致的焦虑。相信直觉，它往往比理性更准确。',
      '火': '你的热情是优势，但要学会控制情绪，避免过于冲动。多喝水，保持内心平静。',
      '土': '你的稳定是珍贵品质，但也要适时突破舒适圈，给自己创造新的可能性。'
    };

    return DivinationResult(
      type: '生辰八字',
      interpretation: '根据你的生辰信息，主运为$primaryElement，辅运为$secondaryElement。${interpretations[primaryElement]}',
      advice: advices[primaryElement]!,
      luckyElements: [primaryElement, secondaryElement],
    );
  }

  /// 紫微斗数分析
  DivinationResult _getZiweiAdvice(UserModel? user) {
    final stars = ['紫微', '天机', '太阳', '武曲', '天同', '廉贞', '天府', '太阴', '贪狼', '巨门', '天相', '天梁', '七杀', '破军'];
    final mainStar = stars[_random.nextInt(stars.length)];
    
    final starMeanings = {
      '紫微': '你具有领导气质，天生的贵人星。适合担任管理角色，但要注意不要过于强势。',
      '天机': '你聪明机智，善于策划和分析。适合从事需要智慧和策略的工作。',
      '太阳': '你开朗大方，具有很强的感染力。是天生的社交达人，但要注意保护私人空间。',
      '武曲': '你意志坚强，执行力很强。在财务管理方面有天赋，但要避免过于功利。',
      '天同': '你性格温和，善解人意。具有很好的调和能力，适合做和谐使者。',
      '廉贞': '你有原则有底线，追求完美。在艺术或精神层面有独特的见解。',
      '天府': '你稳重大方，有很好的包容力。适合做管理者或顾问类工作。',
      '太阴': '你内心细腻，直觉敏锐。在照顾他人方面有天赋，但要注意保护自己的能量。',
      '贪狼': '你多才多艺，充满好奇心。学习能力强，但要专注，避免过于分散精力。',
      '巨门': '你善于表达，有很强的沟通能力。适合教育、咨询或媒体相关工作。',
      '天相': '你善于协调，是天生的和平使者。在人际关系处理上有独特的智慧。',
      '天梁': '你稳重可靠，有长者风范。在指导和帮助他人方面有特殊的能力。',
      '七杀': '你果断勇敢，有开拓精神。适合挑战性强的工作，但要注意情绪管理。',
      '破军': '你勇于创新，善于突破。在变革和创新方面有天赋，但要注意坚持。'
    };

    return DivinationResult(
      type: '紫微斗数',
      interpretation: '你的命宫主星是$mainStar星。${starMeanings[mainStar]}',
      advice: '建议你发挥$mainStar星的正面特质，同时注意平衡可能的负面倾向。最近一个月是你的成长期，适合学习新知识或发展新技能。',
      luckyElements: [mainStar],
    );
  }

  /// 占星学分析
  DivinationResult _getAstrologyAdvice(UserModel? user) {
    String zodiacSign = '白羊';
    if (user?.birthday != null) {
      zodiacSign = _getZodiacSign(user!.birthday!);
    }

    final zodiacAdvice = {
      '白羊': '你充满活力和冒险精神，是天生的领导者。但要注意控制冲动，多听取他人意见。',
      '金牛': '你稳重可靠，有很好的审美和财务管理能力。但要避免过于固执，保持开放心态。',
      '双子': '你聪明机智，适应能力强。有很好的沟通天赋，但要注意专注力的培养。',
      '巨蟹': '你直觉敏锐，善于照顾他人。情感丰富，但要注意保护自己不被他人情绪影响。',
      '狮子': '你自信大方，有很强的表现欲。天生的艺术天赋，但要注意谦逊和倾听。',
      '处女': '你细致认真，追求完美。分析能力强，但要避免过度焦虑和苛求。',
      '天秤': '你追求和谐美好，善于平衡。有很好的人际关系，但要注意坚持自己的立场。',
      '天蝎': '你深刻敏锐，有很强的洞察力。情感丰富，但要学会释放和信任。',
      '射手': '你乐观开朗，热爱自由和探索。有哲学思维，但要注意脚踏实地。',
      '摩羯': '你踏实努力，有很强的责任心。适合长期规划，但要注意生活的乐趣。',
      '水瓶': '你独立创新，有独特的思维方式。关心社会，但要注意与他人的情感连接。',
      '双鱼': '你敏感浪漫，富有想象力。直觉强，但要注意现实感和边界设立。'
    };

    return DivinationResult(
      type: '占星学',
      interpretation: '作为$zodiacSign座，${zodiacAdvice[zodiacSign]}',
      advice: '建议你在这个月关注自己的情绪变化，$zodiacSign座的人在这个时期特别适合内省和成长。多关注月亮的变化，它会影响你的情绪和直觉。',
      luckyElements: [zodiacSign],
    );
  }

  /// 塔罗牌分析
  DivinationResult _getTarotAdvice(UserModel? user) {
    final majorArcana = [
      '愚者', '魔术师', '女祭司', '皇后', '皇帝', '教皇', '恋人', '战车', 
      '力量', '隐士', '命运之轮', '正义', '倒吊人', '死神', '节制', 
      '恶魔', '塔', '星星', '月亮', '太阳', '审判', '世界'
    ];

    final card = majorArcana[_random.nextInt(majorArcana.length)];
    
    final cardMeanings = {
      '愚者': '新的开始即将到来，保持开放和好奇的心态。不要害怕冒险，相信直觉。',
      '魔术师': '你拥有实现目标的所有能力，关键是要相信自己并付诸行动。',
      '女祭司': '倾听内心的声音，直觉会给你指引。现在适合学习和内省。',
      '皇后': '关注创造力和感性，这是丰收和成长的时期。',
      '皇帝': '建立秩序和结构，用理性和权威来处理问题。',
      '教皇': '寻求智慧和指导，传统的方法可能更适合现在的情况。',
      '恋人': '面临选择，要跟随内心而非外在压力。感情方面有新发展。',
      '战车': '保持决心和毅力，克服障碍就能达成目标。',
      '力量': '用温柔而非强硬的方式处理问题，内在的力量比外在更重要。',
      '隐士': '适合独处和反思，寻找内在的智慧和方向。',
      '命运之轮': '变化即将到来，保持灵活性，顺应生命的节奏。',
      '正义': '公平和平衡很重要，诚实面对自己和他人。',
      '倒吊人': '换个角度看问题，有时候等待比行动更有智慧。',
      '死神': '某个阶段即将结束，为新的开始做好准备。',
      '节制': '保持平衡和耐心，缓慢而稳定地前进。',
      '恶魔': '识别并克服内在的恐惧和限制性信念。',
      '塔': '突然的变化可能令人震惊，但会带来解放和新的可能。',
      '星星': '保持希望和信念，你的愿望会实现。',
      '月亮': '注意幻象和欺骗，相信直觉但也要理性分析。',
      '太阳': '成功和快乐即将到来，保持乐观和积极。',
      '审判': '重新评估人生，原谅过去，为未来做好准备。',
      '世界': '完成和成就，你已经到达了一个重要的里程碑。'
    };

    return DivinationResult(
      type: '塔罗牌',
      interpretation: '为你抽取的牌是：$card。${cardMeanings[card]}',
      advice: '塔罗牌提醒你关注当下的能量和机会。建议你在做决定时既要相信直觉，也要结合理性思考。记住，未来是可以通过现在的行动来塑造的。',
      luckyElements: [card],
    );
  }

  /// 综合占卜分析
  DivinationResult _getGeneralAdvice(UserModel? user) {
    final generalAdvice = [
      '根据你目前的能量场，我感受到你正在经历一个重要的成长期。',
      '你的生命数字显示，现在是一个特别的转换期。',
      '从你的气场来看，你最近的心境有了很大的变化。',
      '综合各种迹象，你正在走向一个新的人生阶段。'
    ];

    final suggestions = [
      '建议你多关注内心的声音，它会给你最准确的指引。',
      '现在适合做一些重要的决定，相信自己的判断力。',
      '保持开放的心态，新的机会正在靠近你。',
      '注意身边的小细节，它们可能包含重要的信息。'
    ];

    return DivinationResult(
      type: '综合占卜',
      interpretation: generalAdvice[_random.nextInt(generalAdvice.length)],
      advice: suggestions[_random.nextInt(suggestions.length)],
      luckyElements: ['直觉', '成长', '机会'],
    );
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
}

/// 占卜结果模型
class DivinationResult {
  final String type;           // 占卜类型
  final String interpretation; // 解读
  final String advice;         // 建议
  final List<String> luckyElements; // 幸运元素

  DivinationResult({
    required this.type,
    required this.interpretation,
    required this.advice,
    required this.luckyElements,
  });
} 