import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 通用输入框组件
/// 支持不同样式和验证，统一输入框外观
class AppInputField extends StatefulWidget {
  final String? label;                   // 标签文字
  final String? hint;                    // 提示文字
  final String? errorText;               // 错误文字
  final TextEditingController? controller; // 控制器
  final TextInputType keyboardType;      // 键盘类型
  final bool obscureText;                // 是否隐藏文字
  final bool enabled;                    // 是否启用
  final bool readOnly;                   // 是否只读
  final int maxLines;                    // 最大行数
  final int? maxLength;                   // 最大长度
  final List<TextInputFormatter>? inputFormatters; // 输入格式化器
  final Widget? prefixIcon;              // 前缀图标
  final Widget? suffixIcon;              // 后缀图标
  final VoidCallback? onTap;             // 点击回调
  final ValueChanged<String>? onChanged; // 内容变化回调
  final ValueChanged<String>? onSubmitted; // 提交回调
  final String? Function(String?)? validator; // 验证函数

  const AppInputField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _isObscureText = false;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _isObscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.input.copyWith(
              color: AppColors.textSecondary,
            ),
            errorText: widget.errorText,
            errorStyle: AppTextStyles.error,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.enabled ? AppColors.cardBackground : AppColors.background,
            border: _getBorder(),
            enabledBorder: _getBorder(),
            focusedBorder: _getBorder(isFocused: true),
            errorBorder: _getBorder(isError: true),
            focusedErrorBorder: _getBorder(isFocused: true, isError: true),
            disabledBorder: _getBorder(isDisabled: true),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            counterText: '', // 隐藏字符计数器
          ),
          style: AppTextStyles.input.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// 构建后缀图标
  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _isObscureText = !_isObscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  /// 获取边框样式
  OutlineInputBorder _getBorder({
    bool isFocused = false,
    bool isError = false,
    bool isDisabled = false,
  }) {
    Color borderColor;
    double borderWidth = 1;

    if (isDisabled) {
      borderColor = AppColors.border;
    } else if (isError) {
      borderColor = AppColors.error;
      borderWidth = 1.5;
    } else if (isFocused) {
      borderColor = AppColors.primary;
      borderWidth = 1.5;
    } else {
      borderColor = AppColors.border;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}

/// 手机号输入框（支持国际化）
class PhoneInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? errorText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    this.controller,
    this.errorText,
    this.hintText,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      label: '手机号',
      hint: hintText ?? '请输入手机号',
      errorText: errorText,
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 15, // 支持国际手机号长度
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      prefixIcon: const Icon(
        Icons.phone_android,
        color: AppColors.textSecondary,
      ),
      onChanged: onChanged,
      validator: validator ?? _validatePhone,
    );
  }

  /// 验证手机号（支持国际化）
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    // 简化验证：至少7位数字，最多15位
    if (value.length < 7 || value.length > 15) {
      return '手机号长度应为7-15位';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '手机号只能包含数字';
    }
    return null;
  }
}

/// 验证码输入框
class VerificationCodeInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const VerificationCodeInputField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      label: '验证码',
      hint: '请输入验证码',
      errorText: errorText,
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      prefixIcon: const Icon(
        Icons.security,
        color: AppColors.textSecondary,
      ),
      onChanged: onChanged,
      validator: validator ?? _validateCode,
    );
  }

  /// 验证验证码
  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }
    if (value.length != 6) {
      return '验证码格式不正确';
    }
    return null;
  }
} 