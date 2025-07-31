import 'package:flutter/material.dart';
import 'dart:async';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input_field.dart';

/// 注册页面
/// 手机号+验证码注册，与登录页面风格一致
class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isCodeLoading = false;
  int _countdown = 0;
  String? _phoneError;
  String? _codeError;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo和标题
                _buildHeader(),
                
                const SizedBox(height: 40),
                
                // 注册表单
                _buildRegisterForm(),
                
                const SizedBox(height: 32),
                
                // 注册按钮
                _buildRegisterButton(),
                
                const SizedBox(height: 24),
                
                // 登录链接
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        
        // 标题
        Text(
          '创建你的Aura账号',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // 副标题
        Text(
          '开始你的情感陪伴之旅',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// 构建注册表单
  Widget _buildRegisterForm() {
    return Column(
      children: [
        // 手机号输入
        PhoneInputField(
          controller: _phoneController,
          errorText: _phoneError,
          onChanged: (value) {
            setState(() {
              _phoneError = null;
            });
          },
        ),
        
        const SizedBox(height: 20),
        
        // 验证码输入
        Row(
          children: [
            Expanded(
              child: VerificationCodeInputField(
                controller: _codeController,
                errorText: _codeError,
                onChanged: (value) {
                  setState(() {
                    _codeError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // 获取验证码按钮
            SizedBox(
              width: 120,
              child: AppButton(
                text: _countdown > 0 ? '${_countdown}s' : '获取验证码',
                onPressed: _countdown > 0 ? null : _sendVerificationCode,
                type: ButtonType.outline,
                isLoading: _isCodeLoading,
                isDisabled: _phoneController.text.length != 11,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 隐私政策提示
        _buildPrivacyNotice(),
      ],
    );
  }

  /// 构建隐私政策提示
  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.security,
            color: AppColors.accent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '注册即表示同意我们的服务条款和隐私政策',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建注册按钮
  Widget _buildRegisterButton() {
    return AppButton(
      text: '注册',
      onPressed: _register,
      type: ButtonType.primary,
      size: ButtonSize.large,
      width: double.infinity,
      isLoading: _isLoading,
    );
  }

  /// 构建登录链接
  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '已有账号？',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: widget.onGoToLogin,
            child: const Text(
              '立即登录',
              style: AppTextStyles.link,
            ),
          ),
        ],
      ),
    );
  }

  /// 发送验证码
  Future<void> _sendVerificationCode() async {
    // 验证手机号
    if (_phoneController.text.length != 11) {
      setState(() {
        _phoneError = '请输入正确的手机号';
      });
      return;
    }

    setState(() {
      _isCodeLoading = true;
    });

    try {
      // 模拟发送验证码
      await Future.delayed(const Duration(seconds: 2));
      
      // 开始倒计时
      _startCountdown();
      
      // 显示成功提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('验证码已发送到 ${_phoneController.text}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发送失败：$e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCodeLoading = false;
        });
      }
    }
  }

  /// 开始倒计时
  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });
    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        
        if (_countdown <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// 注册
  Future<void> _register() async {
    // 验证表单
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 验证手机号
    if (_phoneController.text.length != 11) {
      setState(() {
        _phoneError = '请输入正确的手机号';
      });
      return;
    }

    // 验证验证码
    if (_codeController.text.length != 6) {
      setState(() {
        _codeError = '请输入6位验证码';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 模拟注册请求
      await Future.delayed(const Duration(seconds: 2));
      
      // 注册成功
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('注册成功！欢迎加入Aura'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 延迟跳转，让用户看到成功提示
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          widget.onRegisterSuccess();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('注册失败：$e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 