import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 通用按钮组件
/// 支持不同样式和状态，统一按钮外观
class AppButton extends StatelessWidget {
  final String text;                    // 按钮文字
  final VoidCallback? onPressed;        // 点击回调
  final ButtonType type;                // 按钮类型
  final ButtonSize size;                // 按钮尺寸
  final bool isLoading;                 // 是否显示加载状态
  final bool isDisabled;                // 是否禁用
  final Widget? icon;                   // 图标
  final double? width;                  // 按钮宽度
  final double? height;                 // 按钮高度

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? _getButtonWidth(),
      height: height ?? _getButtonHeight(),
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: _getButtonStyle(),
        child: _buildButtonContent(),
      ),
    );
  }

  /// 构建按钮内容
  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary ? Colors.white : AppColors.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text, style: _getTextStyle()),
        ],
      );
    }

    return Text(text, style: _getTextStyle());
  }

  /// 获取按钮样式
  ButtonStyle _getButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getForegroundColor(),
      elevation: _getElevation(),
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: _getBorderSide(),
      ),
      padding: _getPadding(),
    );
  }

  /// 获取背景色
  Color _getBackgroundColor() {
    if (isDisabled) {
      return AppColors.border;
    }

    switch (type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.secondary:
        return Colors.transparent;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  /// 获取前景色（文字和图标颜色）
  Color _getForegroundColor() {
    if (isDisabled) {
      return AppColors.textSecondary;
    }

    switch (type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return AppColors.primary;
      case ButtonType.outline:
        return AppColors.primary;
      case ButtonType.text:
        return AppColors.primary;
    }
  }

  /// 获取阴影高度
  double _getElevation() {
    if (isDisabled) return 0;
    
    switch (type) {
      case ButtonType.primary:
        return 2;
      case ButtonType.secondary:
      case ButtonType.outline:
      case ButtonType.text:
        return 0;
    }
  }

  /// 获取边框
  BorderSide _getBorderSide() {
    if (isDisabled) {
      return const BorderSide(color: AppColors.border);
    }

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.text:
        return BorderSide.none;
      case ButtonType.outline:
        return const BorderSide(color: AppColors.primary, width: 1);
    }
  }

  /// 获取内边距
  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  /// 获取按钮宽度
  double _getButtonWidth() {
    switch (size) {
      case ButtonSize.small:
        return 80;
      case ButtonSize.medium:
        return 120;
      case ButtonSize.large:
        return double.infinity;
    }
  }

  /// 获取按钮高度
  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  /// 获取文字样式
  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.body2.copyWith(
          fontWeight: FontWeight.bold,
          color: _getForegroundColor(),
        );
      case ButtonSize.medium:
        return AppTextStyles.button.copyWith(
          color: _getForegroundColor(),
        );
      case ButtonSize.large:
        return AppTextStyles.button.copyWith(
          fontSize: 18,
          color: _getForegroundColor(),
        );
    }
  }
}

/// 按钮类型枚举
enum ButtonType {
  primary,    // 主要按钮
  secondary,  // 次要按钮
  outline,    // 轮廓按钮
  text,       // 文字按钮
}

/// 按钮尺寸枚举
enum ButtonSize {
  small,   // 小尺寸
  medium,  // 中等尺寸
  large,   // 大尺寸
} 