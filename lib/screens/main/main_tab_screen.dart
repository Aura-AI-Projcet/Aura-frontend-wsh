import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/user_model.dart';
import 'chat/chat_screen.dart';
import 'divination/divination_screen.dart';
import 'profile/profile_screen.dart';

/// 主要的Tab导航屏幕
/// 包含聊一聊、抽一卦、我的三个Tab
class MainTabScreen extends StatefulWidget {
  final UserModel? currentUser;

  const MainTabScreen({
    super.key,
    this.currentUser,
  });

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ChatScreen(currentUser: widget.currentUser),
      DivinationScreen(currentUser: widget.currentUser),
      ProfileScreen(currentUser: widget.currentUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 构建底部导航栏
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                index: 0,
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: '聊一聊',
              ),
              _buildTabItem(
                index: 1,
                icon: Icons.auto_awesome_outlined,
                activeIcon: Icons.auto_awesome,
                label: '抽一卦',
              ),
              _buildTabItem(
                index: 2,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建Tab项
  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 