import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'constants/app_colors.dart';
import 'models/user_model.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main/main_tab_screen.dart';

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
      home: const AppNavigator(),
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
  bool _skipAuth = false; // 用于开发阶段跳过认证
  bool _showOnboarding = false; // 是否显示新手引导页面

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  /// 检查应用状态
  /// 判断用户是否需要新手引导或登录
  Future<void> _checkAppState() async {
    // 检查是否跳过认证（开发模式）
    const bool isDevelopment = bool.fromEnvironment('SKIP_AUTH', defaultValue: false);
    if (isDevelopment) {
      setState(() {
        _skipAuth = true;
        _currentUser = UserModel(
          nickname: '开发用户',
          gender: 'male',
          birthday: DateTime(1990, 5, 15),
          province: '北京市',
          city: '北京市',
          district: '朝阳区',
          emotionState: 'happy',
        );
        _isOnboardingCompleted = true;
        _isLoggedIn = true;
      });
      return;
    }
    
    // 正常模式：检查用户状态
    await Future.delayed(const Duration(seconds: 1));
    
    // 模拟检查结果：新用户需要新手引导
    setState(() {
      _isOnboardingCompleted = false;
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 开发模式直接进入主界面
    if (_skipAuth) {
      return _buildMainScreen();
    }
    
    // 根据应用状态决定显示哪个屏幕
    if (_showOnboarding) {
      return OnboardingScreen(
        onOnboardingCompleted: _onOnboardingCompleted,
      );
    } else if (!_isOnboardingCompleted) {
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
    setState(() {
      _showOnboarding = true;
    });
  }

  /// 新手引导完成
  void _onOnboardingCompleted(UserModel user) {
    print('🎯 main.dart: _onOnboardingCompleted被调用');
    print('🎯 接收到的用户信息: ${user.nickname}, ${user.companionPersona}');
    print('🎯 mounted状态: $mounted');
    
    // 严格检查mounted状态
    if (!mounted) {
      print('⚠️ Widget已销毁，无法更新状态');
      return;
    }
    
    try {
      // 更新状态，但不立即导航
      setState(() {
        _currentUser = user;
        _isOnboardingCompleted = true;
        _showOnboarding = false; // 关闭新手引导页面
        // 重要：设置为未登录状态，这样build方法会自动显示登录页面
        _isLoggedIn = false;
      });
      
      print('🎯 状态已更新，build方法将自动显示登录页面');
      
      // 显示欢迎信息（如果用户完成了新手引导）
      if (!(user.nickname?.isEmpty ?? true)) {
        // 使用addPostFrameCallback确保在页面切换完成后显示消息
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            print('🎯 显示欢迎信息');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('欢迎 ${user.nickname}！请登录以继续你的占卜之旅'),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
    } catch (e) {
      print('⚠️ setState出错: $e');
      // 如果setState失败，记录错误但不再尝试其他操作
    }
  }

  /// 跳转到登录页面
  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLoginSuccess: _onLoginSuccess,
          onGoToRegister: _goToRegister,
        ),
      ),
    );
  }

  /// 登录成功
  void _onLoginSuccess(UserModel user) {
    setState(() {
      _currentUser = user;
      _isLoggedIn = true;
      _isOnboardingCompleted = true; // 确保登录后不会回到新手引导
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('欢迎回来，${user.nickname}！'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 跳转到注册页面
  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          onRegisterSuccess: () {
            _onRegisterSuccess(UserModel(nickname: '新用户'));
          },
          onGoToLogin: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  /// 注册成功
  void _onRegisterSuccess(UserModel user) {
    setState(() {
      _currentUser = user;
      _isLoggedIn = true;
      _isOnboardingCompleted = true; // 确保注册后不会回到新手引导
    });
    
    // 关闭注册页面
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('注册成功，欢迎 ${user.nickname}！'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 构建主屏幕
  Widget _buildMainScreen() {
    return MainTabScreen(currentUser: _currentUser);
  }
} 