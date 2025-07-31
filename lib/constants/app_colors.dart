import 'package:flutter/material.dart';

/// 应用色彩常量
/// 定义温暖、治愈、缓解焦虑的配色方案
class AppColors {
  // 私有构造函数，防止实例化
  AppColors._();

  // 主色调 - 温暖珊瑚红
  static const Color primary = Color(0xFFFF6B6B);
  
  // 辅助色 - 清新青绿
  static const Color secondary = Color(0xFF4ECDC4);
  
  // 背景色 - 温暖灰白
  static const Color background = Color(0xFFF7F7F7);
  
  // 文字色 - 深灰蓝
  static const Color textPrimary = Color(0xFF2C3E50);
  
  // 强调色 - 温暖黄色
  static const Color accent = Color(0xFFFFE66D);
  
  // 次要文字色
  static const Color textSecondary = Color(0xFF7F8C8D);
  
  // 边框色
  static const Color border = Color(0xFFE0E0E0);
  
  // 错误色
  static const Color error = Color(0xFFE74C3C);
  
  // 成功色
  static const Color success = Color(0xFF27AE60);
  
  // 警告色
  static const Color warning = Color(0xFFF39C12);
  
  // 卡片背景色
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // 阴影色
  static const Color shadow = Color(0x1A000000);
  
  // 渐变色彩
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF6EDDD6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFE66D), Color(0xFFFFF2A8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 