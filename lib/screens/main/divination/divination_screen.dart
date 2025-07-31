import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../services/divination_knowledge_service.dart';
import '../../../widgets/common/app_button.dart';

/// 抽一卦页面
/// 用户进行塔罗牌占卜的主要界面
class DivinationScreen extends StatefulWidget {
  final UserModel? currentUser;

  const DivinationScreen({
    super.key,
    this.currentUser,
  });

  @override
  State<DivinationScreen> createState() => _DivinationScreenState();
}

class _DivinationScreenState extends State<DivinationScreen>
    with TickerProviderStateMixin {
  final DivinationKnowledgeService _knowledgeService = DivinationKnowledgeService();
  
  bool _isDrawing = false;
  bool _hasDrawn = false;
  DivinationResult? _result;
  
  late AnimationController _cardAnimationController;
  late AnimationController _revealAnimationController;
  late Animation<double> _cardFlipAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // 卡片翻转动画
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 结果展示动画
    _revealAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardFlipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _cardScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _revealAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _hasDrawn ? _buildResultView() : _buildDrawView(),
      ),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        '抽一卦',
        style: AppTextStyles.heading2.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: _hasDrawn ? [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
          onPressed: _resetDivination,
          tooltip: '重新抽签',
        ),
      ] : null,
    );
  }

  /// 构建抽签界面
  Widget _buildDrawView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 顶部说明
          _buildDescription(),
          
          const SizedBox(height: 40),
          
          // 塔罗牌区域
          Expanded(
            child: Center(
              child: _buildTarotCardArea(),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // 抽签按钮
          _buildDrawButton(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 构建说明文字
  Widget _buildDescription() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.accent.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 32,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                '塔罗占卜',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '专注内心，静下心来思考你想了解的问题\n然后点击下方按钮抽取属于你的塔罗牌',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建塔罗牌区域
  Widget _buildTarotCardArea() {
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardScaleAnimation.value,
          child: _isDrawing 
              ? _buildFlippingCard()
              : _buildCardBack(),
        );
      },
    );
  }

  /// 构建卡牌背面
  Widget _buildCardBack() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'TAROT',
            style: AppTextStyles.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建翻转中的卡牌
  Widget _buildFlippingCard() {
    return AnimatedBuilder(
      animation: _cardFlipAnimation,
      builder: (context, child) {
        if (_cardFlipAnimation.value < 0.5) {
          // 显示背面
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_cardFlipAnimation.value * 3.14159),
            child: _buildCardBack(),
          );
        } else {
          // 显示正面
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((_cardFlipAnimation.value - 0.5) * 3.14159),
            child: _buildCardFront(),
          );
        }
      },
    );
  }

  /// 构建卡牌正面
  Widget _buildCardFront() {
    if (_result == null) return Container();
    
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 卡牌顶部
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
            child: Center(
              child: Text(
                _result!.luckyElements.first,
                style: AppTextStyles.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // 卡牌内容
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 塔罗牌图标
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTarotIcon(_result!.luckyElements.first),
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    _result!.luckyElements.first,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    '塔罗牌',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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

  /// 构建抽签按钮
  Widget _buildDrawButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: _isDrawing ? '正在抽签...' : '开始抽签',
        onPressed: _isDrawing ? null : _drawTarotCard,
        isLoading: _isDrawing,
        type: ButtonType.primary,
        size: ButtonSize.large,
      ),
    );
  }

  /// 构建结果界面
  Widget _buildResultView() {
    if (_result == null) return Container();
    
    return AnimatedBuilder(
      animation: _revealAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _revealAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - _revealAnimation.value)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 抽到的卡牌展示
                  _buildCardResult(),
                  const SizedBox(height: 24),
                  
                  // 占卜解读
                  _buildInterpretation(),
                  const SizedBox(height: 24),
                  
                  // 建议和指导
                  _buildAdvice(),
                  const SizedBox(height: 32),
                  
                  // 操作按钮
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建卡牌结果展示
  Widget _buildCardResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTarotIcon(_result!.luckyElements.first),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '你抽到的塔罗牌',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _result!.luckyElements.first,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建解读内容
  Widget _buildInterpretation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '牌义解读',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _result!.interpretation,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建建议内容
  Widget _buildAdvice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '指导建议',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _result!.advice,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 个性化补充
          _buildPersonalizedInsight(),
        ],
      ),
    );
  }

  /// 构建个性化洞察
  Widget _buildPersonalizedInsight() {
    final user = widget.currentUser;
    if (user == null) return Container();
    
    String personalizedMessage = _generatePersonalizedMessage(user);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '专属解读',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            personalizedMessage,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: '重新抽签',
            onPressed: _resetDivination,
            type: ButtonType.primary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: '返回聊天',
            onPressed: _goToChat,
            type: ButtonType.secondary,
          ),
        ),
      ],
    );
  }

  /// 抽取塔罗牌
  Future<void> _drawTarotCard() async {
    setState(() {
      _isDrawing = true;
    });

    // 开始卡牌动画
    _cardAnimationController.forward();

    // 模拟抽签延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 获取塔罗牌结果
    final result = await _knowledgeService.getDivinationAdvice('tarot', widget.currentUser);

    setState(() {
      _result = result;
    });

    // 等待卡牌翻转完成
    await _cardAnimationController.forward();
    
    // 稍作延迟后显示结果
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isDrawing = false;
      _hasDrawn = true;
    });

    // 开始结果展示动画
    _revealAnimationController.forward();
  }

  /// 重置占卜
  void _resetDivination() {
    setState(() {
      _hasDrawn = false;
      _result = null;
    });
    _cardAnimationController.reset();
    _revealAnimationController.reset();
  }

  /// 返回聊天
  void _goToChat() {
    // 通过Navigator返回到主界面，然后切换到聊天Tab
    // 由于我们使用的是IndexedStack而不是TabController，需要通过回调来处理
    Navigator.of(context).pop();
  }

  /// 获取塔罗牌图标
  IconData _getTarotIcon(String cardName) {
    switch (cardName) {
      case '愚者': return Icons.child_care;
      case '魔术师': return Icons.auto_fix_high;
      case '女祭司': return Icons.psychology;
      case '皇后': return Icons.diamond;
      case '皇帝': return Icons.account_balance;
      case '教皇': return Icons.temple_buddhist;
      case '恋人': return Icons.favorite;
      case '战车': return Icons.directions_car;
      case '力量': return Icons.fitness_center;
      case '隐士': return Icons.bedtime;
      case '命运之轮': return Icons.rotate_right;
      case '正义': return Icons.balance;
      case '倒吊人': return Icons.flip;
      case '死神': return Icons.transform;
      case '节制': return Icons.balance_outlined;
      case '恶魔': return Icons.dangerous;
      case '塔': return Icons.domain;
      case '星星': return Icons.star;
      case '月亮': return Icons.nightlight;
      case '太阳': return Icons.wb_sunny;
      case '审判': return Icons.gavel;
      case '世界': return Icons.public;
      default: return Icons.auto_awesome;
    }
  }

  /// 生成个性化信息
  String _generatePersonalizedMessage(UserModel user) {
    String nickname = user.nickname ?? '朋友';
    String emotionContext = '';
    
    if (user.emotionState != null) {
      switch (user.emotionState) {
        case 'happy':
          emotionContext = '你目前的开心状态与这张牌的能量很契合，';
          break;
        case 'in_love':
          emotionContext = '结合你目前的恋爱状态，这张牌提醒你';
          break;
        case 'sad':
          emotionContext = '虽然你最近情绪低落，但这张牌带来希望，';
          break;
        case 'anxious':
          emotionContext = '针对你目前的焦虑情绪，这张牌建议你';
          break;
        case 'confused':
          emotionContext = '对于你现在的迷茫状态，这张牌指引你';
          break;
        default:
          emotionContext = '根据你的当前状态，这张牌建议你';
      }
    }
    
    List<String> personalizedAdvice = [
      '$emotionContext要相信内在的智慧和直觉。',
      '$nickname，这张牌反映了你内心深处的渴望，$emotionContext勇敢地向前迈进。',
      '$emotionContext保持平衡的心态，相信一切都会向好的方向发展。',
      '对于$nickname来说，$emotionContext关注当下的机会和可能性。',
    ];
    
    return personalizedAdvice[DateTime.now().millisecond % personalizedAdvice.length];
  }
} 