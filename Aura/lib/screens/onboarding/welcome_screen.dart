import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/app_button.dart';

/// 新手引导欢迎页面
/// 温暖、治愈的欢迎界面，降低用户焦虑感
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStartOnboarding;

  const WelcomeScreen({
    super.key,
    required this.onStartOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 顶部留白
              const SizedBox(height: 60),
              
              // 主要插画区域
              Expanded(
                flex: 3,
                child: _buildIllustration(),
              ),
              
              // 文字内容区域
              Expanded(
                flex: 2,
                child: _buildContent(),
              ),
              
              // 按钮区域
              _buildButtonArea(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建插画区域
  Widget _buildIllustration() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.warmGradient,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景装饰
          Positioned(
            top: 20,
            left: 20,
            child: _buildDecorationCircle(40, AppColors.primary.withOpacity(0.3)),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: _buildDecorationCircle(30, AppColors.secondary.withOpacity(0.3)),
          ),
          Positioned(
            top: 60,
            right: 40,
            child: _buildDecorationCircle(25, AppColors.accent.withOpacity(0.4)),
          ),
          
          // 主要插画内容
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 温暖的拥抱图标
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              
              // 装饰性文字
              const Text(
                '✨',
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建装饰圆圈
  Widget _buildDecorationCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  /// 构建文字内容
  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 主标题
        Text(
          '欢迎来到Aura',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        
        // 副标题
        Text(
          '你的情感陪伴伙伴',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // 描述文字
        Text(
          '让我们一起开启这段温暖的旅程\n在这里，你将被理解、被关心、被陪伴',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建按钮区域
  Widget _buildButtonArea() {
    return Column(
      children: [
        // 开始按钮
        AppButton(
          text: '开始体验',
          onPressed: onStartOnboarding,
          type: ButtonType.primary,
          size: ButtonSize.large,
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        
        // 温馨提示
        Text(
          '无需注册，立即体验温暖陪伴',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
} 