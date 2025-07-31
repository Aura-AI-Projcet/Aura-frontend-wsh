import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'models/user_model.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

/// Aura应用主入口
/// 占卜与情感陪伴App（MVP版）
void main() {
  runApp(const AuraApp());
}

/// Aura应用主类
class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura - 情感陪伴伙伴',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'PingFang',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      // 临时直接启动OnboardingScreen，这样我们就能立即看到修改效果
      home: OnboardingScreen(
        onOnboardingCompleted: (user) {
          print('Onboarding completed: ${user.nickname}');
        },
      ),
    );
  }
}

/// 应用导航器
/// 管理应用的主要导航流程
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  UserModel? _currentUser;
  bool _isOnboardingCompleted = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  /// 检查应用状态
  /// 判断用户是否需要新手引导或登录
  Future<void> _checkAppState() async {
    // 这里应该从本地存储或服务器检查用户状态
    // 目前使用模拟数据
    await Future.delayed(const Duration(seconds: 1));
    
    // 模拟检查结果：新用户需要新手引导
    setState(() {
      _isOnboardingCompleted = false;
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 根据应用状态显示不同页面
    if (!_isOnboardingCompleted) {
      return WelcomeScreen(
        onStartOnboarding: _startOnboarding,
      );
    } else if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: _onLoginSuccess,
        onGoToRegister: _goToRegister,
      );
    } else {
      return _buildMainScreen();
    }
  }

  /// 开始新手引导
  void _startOnboarding() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OnboardingScreen(
          onOnboardingCompleted: _onOnboardingCompleted,
        ),
      ),
    );
  }

  /// 新手引导完成
  void _onOnboardingCompleted(UserModel user) {
    setState(() {
      _currentUser = user;
      _isOnboardingCompleted = true;
    });
    
    // 显示完成提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('欢迎 ${user.nickname}！让我们开始你的情感陪伴之旅'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 登录成功
  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
    
    // 显示欢迎提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('登录成功！欢迎回来'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  /// 跳转到注册页面
  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          onRegisterSuccess: _onRegisterSuccess,
          onGoToLogin: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  /// 注册成功
  void _onRegisterSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
    
    // 返回登录页面
    Navigator.of(context).pop();
    
    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('注册成功！请登录'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  /// 构建主屏幕
  Widget _buildMainScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Aura',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showUserProfile,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 欢迎信息
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.warmGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            
            Text(
              '欢迎回来，${_currentUser?.nickname ?? '朋友'}！',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            Text(
              '你的情感陪伴伙伴随时为你服务',
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // 功能按钮
            _buildFeatureButtons(),
          ],
        ),
      ),
    );
  }

  /// 构建功能按钮
  Widget _buildFeatureButtons() {
    return Column(
      children: [
        _buildFeatureButton(
          icon: Icons.chat_bubble_outline,
          title: '对话陪伴',
          subtitle: '与AI伙伴聊天，获得情感支持',
          onTap: _openChat,
        ),
        const SizedBox(height: 16),
        _buildFeatureButton(
          icon: Icons.auto_awesome,
          title: '每日抽签',
          subtitle: '获取今日专属签文和建议',
          onTap: _openDailyDivination,
        ),
        const SizedBox(height: 16),
        _buildFeatureButton(
          icon: Icons.psychology,
          title: '合盘分析',
          subtitle: '基于你的信息生成专属命盘',
          onTap: _openAstrologyAnalysis,
        ),
      ],
    );
  }

  /// 构建功能按钮
  Widget _buildFeatureButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示用户资料
  void _showUserProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '用户资料',
          style: AppTextStyles.heading3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('昵称：${_currentUser?.nickname ?? '未设置'}'),
            Text('性别：${_currentUser?.genderText ?? '未设置'}'),
            Text('生日：${_currentUser?.birthday != null ? '${_currentUser!.birthday!.year}年${_currentUser!.birthday!.month}月${_currentUser!.birthday!.day}日' : '未设置'}'),
            Text('情感状态：${_currentUser?.emotionStateText ?? '未设置'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text('退出登录'),
          ),
        ],
      ),
    );
  }

  /// 退出登录
  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _currentUser = null;
    });
  }

  /// 打开对话功能
  void _openChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('对话陪伴功能开发中...'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  /// 打开每日抽签功能
  void _openDailyDivination() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('每日抽签功能开发中...'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  /// 打开合盘分析功能
  void _openAstrologyAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('合盘分析功能开发中...'),
        backgroundColor: AppColors.warning,
      ),
    );
  }
} 