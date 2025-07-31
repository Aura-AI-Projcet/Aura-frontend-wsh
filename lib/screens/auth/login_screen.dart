import 'dart:async';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input_field.dart';
import '../../models/user_model.dart';

/// 登录页面
/// 支持手机号+验证码登录和邮箱+验证码登录，温暖亲切的界面设计
class LoginScreen extends StatefulWidget {
  final Function(UserModel) onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 登录方式：phone 或 email
  String _loginType = 'phone';
  
  // 手机号相关
  final TextEditingController _phoneController = TextEditingController();
  Country _selectedCountry = Country.parse('CN'); // 默认中国
  
  // 邮箱相关
  final TextEditingController _emailController = TextEditingController();
  
  // 验证码
  final TextEditingController _codeController = TextEditingController();
  
  bool _isLoading = false;
  bool _isCountingDown = false;
  int _countdown = 0;
  Timer? _timer;
  String _accountError = '';
  String _codeError = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _timer?.cancel();
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
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题区域
              Text(
                '欢迎回来',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '让占卜师小雅继续为你提供情感陪伴',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // 主要内容
              Expanded(
                child: Column(
                  children: [
                    // 登录方式选择
                    _buildLoginTypeSelector(),
                    const SizedBox(height: 24),

                    // 输入区域
                    if (_loginType == 'phone') ...[
                      _buildPhoneInput(),
                    ] else ...[
                      _buildEmailInput(),
                    ],
                    
                    if (_accountError.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _accountError,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // 验证码输入
                    VerificationCodeInputField(
                      controller: _codeController,
                      onChanged: (value) {
                        setState(() {
                          _codeError = '';
                        });
                      },
                      errorText: _codeError.isEmpty ? null : _codeError,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 发送验证码按钮
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: _isCountingDown ? '$_countdown秒后重发' : '发送验证码',
                        onPressed: _canSendCode() && !_isCountingDown ? _sendVerificationCode : null,
                        type: ButtonType.secondary,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 登录按钮
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: _isLoading ? '登录中...' : '登录',
                        onPressed: _canLogin() && !_isLoading ? _login : null,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),

              // 底部注册链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '还没有账号？',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onGoToRegister,
                    child: Text(
                      '立即注册',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建登录方式选择器
  Widget _buildLoginTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _loginType = 'phone';
                  _accountError = '';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _loginType == 'phone' ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '手机号登录',
                  style: AppTextStyles.body1.copyWith(
                    color: _loginType == 'phone' ? Colors.white : AppColors.textSecondary,
                    fontWeight: _loginType == 'phone' ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _loginType = 'email';
                  _accountError = '';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _loginType == 'email' ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '邮箱登录',
                  style: AppTextStyles.body1.copyWith(
                    color: _loginType == 'email' ? Colors.white : AppColors.textSecondary,
                    fontWeight: _loginType == 'email' ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建手机号输入
  Widget _buildPhoneInput() {
    return Row(
      children: [
        // 国家选择器
        GestureDetector(
          onTap: _showCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedCountry.flagEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 4),
                Text(
                  '+${_selectedCountry.phoneCode}',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 手机号输入框
        Expanded(
          child: PhoneInputField(
            controller: _phoneController,
            onChanged: (value) {
              setState(() {
                _accountError = '';
              });
            },
            hintText: '请输入手机号',
          ),
        ),
      ],
    );
  }

  /// 显示国家选择器
  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _accountError = '';
        });
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: '搜索国家',
          hintText: '输入国家名称',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建邮箱输入
  Widget _buildEmailInput() {
    return EmailInputField(
      controller: _emailController,
      onChanged: (value) {
        setState(() {
          _accountError = '';
        });
      },
    );
  }

  /// 检查是否可以发送验证码
  bool _canSendCode() {
    if (_loginType == 'phone') {
      return _phoneController.text.length >= 7;
    } else {
      return EmailValidator.validate(_emailController.text);
    }
  }

  /// 检查是否可以登录
  bool _canLogin() {
    return _canSendCode() && _codeController.text.length == 6;
  }

  /// 发送验证码
  Future<void> _sendVerificationCode() async {
    if (!_canSendCode()) return;

    setState(() {
      _isCountingDown = true;
      _countdown = 60;
      _accountError = '';
    });

    // 开始倒计时
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown <= 0) {
          _isCountingDown = false;
          timer.cancel();
        }
      });
    });

    // 模拟发送验证码
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('验证码已发送'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  /// 登录
  Future<void> _login() async {
    if (!_canLogin()) return;

    setState(() {
      _isLoading = true;
      _accountError = '';
      _codeError = '';
    });

    try {
      // 模拟登录请求
      await Future.delayed(const Duration(seconds: 2));

      // Mock登录：任何格式正确的账号+6位验证码都能成功
      if (_codeController.text.length == 6) {
        // 创建用户模型
        final user = UserModel(
          nickname: _loginType == 'phone' ? '手机用户' : '邮箱用户',
          phone: _loginType == 'phone' ? _phoneController.text : null,
          emotionState: 'happy',
          isRegistered: true,
        );

        widget.onLoginSuccess(user);
      } else {
        setState(() {
          _codeError = '验证码错误';
        });
      }
    } catch (e) {
      setState(() {
        _accountError = '登录失败，请重试';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

/// 邮箱输入框组件
class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const EmailInputField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: controller,
      label: '邮箱',
      hint: '请输入邮箱地址',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
      errorText: errorText,
      onChanged: onChanged,
    );
  }
} 