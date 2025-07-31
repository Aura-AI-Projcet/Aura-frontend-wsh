import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/user_model.dart';

/// 我的页面
/// 用户个人信息和设置界面
class ProfileScreen extends StatefulWidget {
  final UserModel? currentUser;

  const ProfileScreen({
    super.key,
    this.currentUser,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '我的',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 用户头像
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // 用户昵称
            Text(
              widget.currentUser?.nickname ?? '用户',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // 用户信息
            if (widget.currentUser?.birthday != null)
              Text(
                '${_getZodiacSign(widget.currentUser!.birthday!)}座',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
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