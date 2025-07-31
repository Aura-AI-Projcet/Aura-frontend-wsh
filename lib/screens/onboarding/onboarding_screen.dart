import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input_field.dart';
import '../../models/user_model.dart';

/// 新手引导主页面
/// 步骤式引导用户完成信息采集，温暖亲切的交互体验
class OnboardingScreen extends StatefulWidget {
  final Function(UserModel) onOnboardingCompleted;

  const OnboardingScreen({
    super.key,
    required this.onOnboardingCompleted,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // 防止重复点击
  bool _isProcessing = false;
  
  // 用户信息
  String _nickname = '';
  String _gender = '';
  DateTime? _birthday;
  String _companionPersona = '';
  String _birthCountry = '';
  String _birthRegion = '';
  String _birthCity = '';
  
  // 表单控制器
  final TextEditingController _nicknameController = TextEditingController();

  // 行政区划数据缓存
  List<dynamic> _worldDivisions = [];
  final List<dynamic> _currentLevel = [];
  List<String> _selectedPath = [];

  @override
  void initState() {
    super.initState();
    _birthday = DateTime(2000, 1, 1, 0, 0, 0);
    _loadWorldDivisions();
  }

  Future<void> _loadWorldDivisions() async {
    // 直接使用简化的地区数据，避免复杂的JSON解析
    setState(() {
      _worldDivisions = _getSimpleWorldDivisions();
    });
  }

  /// 转换行政区划数据
  List<dynamic>? _convertSubdivisions(dynamic subdivisions) {
    if (subdivisions == null || subdivisions is! Map) return null;
    
    List<dynamic> result = [];
    subdivisions.forEach((code, data) {
      if (data is Map && data['name'] != null) {
        result.add({
          'code': code,
          'name': data['name'],
          'children': [] // 简化处理，只支持两级选择
        });
      }
    });
    
    return result.isNotEmpty ? result : null;
  }

  /// 获取简化的世界地区数据（备用）
  List<dynamic> _getSimpleWorldDivisions() {
    return [
      {
        'code': 'CN',
        'name': '中国',
        'children': [
          {'code': 'CN-11', 'name': '北京市', 'children': []},
          {'code': 'CN-12', 'name': '天津市', 'children': []},
          {'code': 'CN-13', 'name': '河北省', 'children': []},
          {'code': 'CN-14', 'name': '山西省', 'children': []},
          {'code': 'CN-15', 'name': '内蒙古自治区', 'children': []},
          {'code': 'CN-21', 'name': '辽宁省', 'children': []},
          {'code': 'CN-22', 'name': '吉林省', 'children': []},
          {'code': 'CN-23', 'name': '黑龙江省', 'children': []},
          {'code': 'CN-31', 'name': '上海市', 'children': []},
          {'code': 'CN-32', 'name': '江苏省', 'children': []},
          {'code': 'CN-33', 'name': '浙江省', 'children': []},
          {'code': 'CN-34', 'name': '安徽省', 'children': []},
          {'code': 'CN-35', 'name': '福建省', 'children': []},
          {'code': 'CN-36', 'name': '江西省', 'children': []},
          {'code': 'CN-37', 'name': '山东省', 'children': []},
          {'code': 'CN-41', 'name': '河南省', 'children': []},
          {'code': 'CN-42', 'name': '湖北省', 'children': []},
          {'code': 'CN-43', 'name': '湖南省', 'children': []},
          {'code': 'CN-44', 'name': '广东省', 'children': []},
          {'code': 'CN-45', 'name': '广西壮族自治区', 'children': []},
          {'code': 'CN-46', 'name': '海南省', 'children': []},
          {'code': 'CN-50', 'name': '重庆市', 'children': []},
          {'code': 'CN-51', 'name': '四川省', 'children': []},
          {'code': 'CN-52', 'name': '贵州省', 'children': []},
          {'code': 'CN-53', 'name': '云南省', 'children': []},
          {'code': 'CN-54', 'name': '西藏自治区', 'children': []},
          {'code': 'CN-61', 'name': '陕西省', 'children': []},
          {'code': 'CN-62', 'name': '甘肃省', 'children': []},
          {'code': 'CN-63', 'name': '青海省', 'children': []},
          {'code': 'CN-64', 'name': '宁夏回族自治区', 'children': []},
          {'code': 'CN-65', 'name': '新疆维吾尔自治区', 'children': []},
          {'code': 'CN-71', 'name': '台湾省', 'children': []},
          {'code': 'CN-91', 'name': '香港特别行政区', 'children': []},
          {'code': 'CN-92', 'name': '澳门特别行政区', 'children': []},
        ]
      },
      {
        'code': 'US',
        'name': '美国',
        'children': [
          {'code': 'US-AL', 'name': 'Alabama', 'children': []},
          {'code': 'US-AK', 'name': 'Alaska', 'children': []},
          {'code': 'US-AZ', 'name': 'Arizona', 'children': []},
          {'code': 'US-AR', 'name': 'Arkansas', 'children': []},
          {'code': 'US-CA', 'name': 'California', 'children': []},
          {'code': 'US-CO', 'name': 'Colorado', 'children': []},
          {'code': 'US-CT', 'name': 'Connecticut', 'children': []},
          {'code': 'US-DE', 'name': 'Delaware', 'children': []},
          {'code': 'US-FL', 'name': 'Florida', 'children': []},
          {'code': 'US-GA', 'name': 'Georgia', 'children': []},
          {'code': 'US-HI', 'name': 'Hawaii', 'children': []},
          {'code': 'US-ID', 'name': 'Idaho', 'children': []},
          {'code': 'US-IL', 'name': 'Illinois', 'children': []},
          {'code': 'US-IN', 'name': 'Indiana', 'children': []},
          {'code': 'US-IA', 'name': 'Iowa', 'children': []},
          {'code': 'US-KS', 'name': 'Kansas', 'children': []},
          {'code': 'US-KY', 'name': 'Kentucky', 'children': []},
          {'code': 'US-LA', 'name': 'Louisiana', 'children': []},
          {'code': 'US-ME', 'name': 'Maine', 'children': []},
          {'code': 'US-MD', 'name': 'Maryland', 'children': []},
          {'code': 'US-MA', 'name': 'Massachusetts', 'children': []},
          {'code': 'US-MI', 'name': 'Michigan', 'children': []},
          {'code': 'US-MN', 'name': 'Minnesota', 'children': []},
          {'code': 'US-MS', 'name': 'Mississippi', 'children': []},
          {'code': 'US-MO', 'name': 'Missouri', 'children': []},
          {'code': 'US-MT', 'name': 'Montana', 'children': []},
          {'code': 'US-NE', 'name': 'Nebraska', 'children': []},
          {'code': 'US-NV', 'name': 'Nevada', 'children': []},
          {'code': 'US-NH', 'name': 'New Hampshire', 'children': []},
          {'code': 'US-NJ', 'name': 'New Jersey', 'children': []},
          {'code': 'US-NM', 'name': 'New Mexico', 'children': []},
          {'code': 'US-NY', 'name': 'New York', 'children': []},
          {'code': 'US-NC', 'name': 'North Carolina', 'children': []},
          {'code': 'US-ND', 'name': 'North Dakota', 'children': []},
          {'code': 'US-OH', 'name': 'Ohio', 'children': []},
          {'code': 'US-OK', 'name': 'Oklahoma', 'children': []},
          {'code': 'US-OR', 'name': 'Oregon', 'children': []},
          {'code': 'US-PA', 'name': 'Pennsylvania', 'children': []},
          {'code': 'US-RI', 'name': 'Rhode Island', 'children': []},
          {'code': 'US-SC', 'name': 'South Carolina', 'children': []},
          {'code': 'US-SD', 'name': 'South Dakota', 'children': []},
          {'code': 'US-TN', 'name': 'Tennessee', 'children': []},
          {'code': 'US-TX', 'name': 'Texas', 'children': []},
          {'code': 'US-UT', 'name': 'Utah', 'children': []},
          {'code': 'US-VT', 'name': 'Vermont', 'children': []},
          {'code': 'US-VA', 'name': 'Virginia', 'children': []},
          {'code': 'US-WA', 'name': 'Washington', 'children': []},
          {'code': 'US-WV', 'name': 'West Virginia', 'children': []},
          {'code': 'US-WI', 'name': 'Wisconsin', 'children': []},
          {'code': 'US-WY', 'name': 'Wyoming', 'children': []},
        ]
      },
      {
        'code': 'JP',
        'name': '日本',
        'children': [
          {'code': 'JP-01', 'name': '北海道', 'children': []},
          {'code': 'JP-02', 'name': '青森县', 'children': []},
          {'code': 'JP-03', 'name': '岩手县', 'children': []},
          {'code': 'JP-04', 'name': '宫城县', 'children': []},
          {'code': 'JP-05', 'name': '秋田县', 'children': []},
          {'code': 'JP-06', 'name': '山形县', 'children': []},
          {'code': 'JP-07', 'name': '福岛县', 'children': []},
          {'code': 'JP-08', 'name': '茨城县', 'children': []},
          {'code': 'JP-09', 'name': '栃木县', 'children': []},
          {'code': 'JP-10', 'name': '群马县', 'children': []},
          {'code': 'JP-11', 'name': '埼玉县', 'children': []},
          {'code': 'JP-12', 'name': '千叶县', 'children': []},
          {'code': 'JP-13', 'name': '东京都', 'children': []},
          {'code': 'JP-14', 'name': '神奈川县', 'children': []},
          {'code': 'JP-15', 'name': '新潟县', 'children': []},
          {'code': 'JP-16', 'name': '富山县', 'children': []},
          {'code': 'JP-17', 'name': '石川县', 'children': []},
          {'code': 'JP-18', 'name': '福井县', 'children': []},
          {'code': 'JP-19', 'name': '山梨县', 'children': []},
          {'code': 'JP-20', 'name': '长野县', 'children': []},
          {'code': 'JP-21', 'name': '岐阜县', 'children': []},
          {'code': 'JP-22', 'name': '静冈县', 'children': []},
          {'code': 'JP-23', 'name': '爱知县', 'children': []},
          {'code': 'JP-24', 'name': '三重县', 'children': []},
          {'code': 'JP-25', 'name': '滋贺县', 'children': []},
          {'code': 'JP-26', 'name': '京都府', 'children': []},
          {'code': 'JP-27', 'name': '大阪府', 'children': []},
          {'code': 'JP-28', 'name': '兵库县', 'children': []},
          {'code': 'JP-29', 'name': '奈良县', 'children': []},
          {'code': 'JP-30', 'name': '和歌山县', 'children': []},
          {'code': 'JP-31', 'name': '鸟取县', 'children': []},
          {'code': 'JP-32', 'name': '岛根县', 'children': []},
          {'code': 'JP-33', 'name': '冈山县', 'children': []},
          {'code': 'JP-34', 'name': '广岛县', 'children': []},
          {'code': 'JP-35', 'name': '山口县', 'children': []},
          {'code': 'JP-36', 'name': '德岛县', 'children': []},
          {'code': 'JP-37', 'name': '香川县', 'children': []},
          {'code': 'JP-38', 'name': '爱媛县', 'children': []},
          {'code': 'JP-39', 'name': '高知县', 'children': []},
          {'code': 'JP-40', 'name': '福冈县', 'children': []},
          {'code': 'JP-41', 'name': '佐贺县', 'children': []},
          {'code': 'JP-42', 'name': '长崎县', 'children': []},
          {'code': 'JP-43', 'name': '熊本县', 'children': []},
          {'code': 'JP-44', 'name': '大分县', 'children': []},
          {'code': 'JP-45', 'name': '宫崎县', 'children': []},
          {'code': 'JP-46', 'name': '鹿儿岛县', 'children': []},
          {'code': 'JP-47', 'name': '冲绳县', 'children': []},
        ]
      },
      {
        'code': 'GB',
        'name': '英国',
        'children': [
          {'code': 'GB-ENG', 'name': 'England', 'children': []},
          {'code': 'GB-SCT', 'name': 'Scotland', 'children': []},
          {'code': 'GB-WLS', 'name': 'Wales', 'children': []},
          {'code': 'GB-NIR', 'name': 'Northern Ireland', 'children': []},
        ]
      },
      {
        'code': 'CA',
        'name': '加拿大',
        'children': [
          {'code': 'CA-AB', 'name': 'Alberta', 'children': []},
          {'code': 'CA-BC', 'name': 'British Columbia', 'children': []},
          {'code': 'CA-MB', 'name': 'Manitoba', 'children': []},
          {'code': 'CA-NB', 'name': 'New Brunswick', 'children': []},
          {'code': 'CA-NL', 'name': 'Newfoundland and Labrador', 'children': []},
          {'code': 'CA-NS', 'name': 'Nova Scotia', 'children': []},
          {'code': 'CA-ON', 'name': 'Ontario', 'children': []},
          {'code': 'CA-PE', 'name': 'Prince Edward Island', 'children': []},
          {'code': 'CA-QC', 'name': 'Quebec', 'children': []},
          {'code': 'CA-SK', 'name': 'Saskatchewan', 'children': []},
          {'code': 'CA-NT', 'name': 'Northwest Territories', 'children': []},
          {'code': 'CA-NU', 'name': 'Nunavut', 'children': []},
          {'code': 'CA-YT', 'name': 'Yukon', 'children': []},
        ]
      },
      {
        'code': 'AU',
        'name': '澳大利亚',
        'children': [
          {'code': 'AU-NSW', 'name': 'New South Wales', 'children': []},
          {'code': 'AU-QLD', 'name': 'Queensland', 'children': []},
          {'code': 'AU-SA', 'name': 'South Australia', 'children': []},
          {'code': 'AU-TAS', 'name': 'Tasmania', 'children': []},
          {'code': 'AU-VIC', 'name': 'Victoria', 'children': []},
          {'code': 'AU-WA', 'name': 'Western Australia', 'children': []},
          {'code': 'AU-ACT', 'name': 'Australian Capital Territory', 'children': []},
          {'code': 'AU-NT', 'name': 'Northern Territory', 'children': []},
        ]
      },
      {
        'code': 'DE',
        'name': '德国',
        'children': [
          {'code': 'DE-BW', 'name': 'Baden-Württemberg', 'children': []},
          {'code': 'DE-BY', 'name': 'Bavaria', 'children': []},
          {'code': 'DE-BE', 'name': 'Berlin', 'children': []},
          {'code': 'DE-BB', 'name': 'Brandenburg', 'children': []},
          {'code': 'DE-HB', 'name': 'Bremen', 'children': []},
          {'code': 'DE-HH', 'name': 'Hamburg', 'children': []},
          {'code': 'DE-HE', 'name': 'Hesse', 'children': []},
          {'code': 'DE-MV', 'name': 'Mecklenburg-Vorpommern', 'children': []},
          {'code': 'DE-NI', 'name': 'Lower Saxony', 'children': []},
          {'code': 'DE-NW', 'name': 'North Rhine-Westphalia', 'children': []},
          {'code': 'DE-RP', 'name': 'Rhineland-Palatinate', 'children': []},
          {'code': 'DE-SL', 'name': 'Saarland', 'children': []},
          {'code': 'DE-SN', 'name': 'Saxony', 'children': []},
          {'code': 'DE-ST', 'name': 'Saxony-Anhalt', 'children': []},
          {'code': 'DE-SH', 'name': 'Schleswig-Holstein', 'children': []},
          {'code': 'DE-TH', 'name': 'Thuringia', 'children': []},
        ]
      },
      {
        'code': 'FR',
        'name': '法国',
        'children': [
          {'code': 'FR-ARA', 'name': 'Auvergne-Rhône-Alpes', 'children': []},
          {'code': 'FR-BFC', 'name': 'Bourgogne-Franche-Comté', 'children': []},
          {'code': 'FR-BRE', 'name': 'Brittany', 'children': []},
          {'code': 'FR-CVL', 'name': 'Centre-Val de Loire', 'children': []},
          {'code': 'FR-COR', 'name': 'Corsica', 'children': []},
          {'code': 'FR-GES', 'name': 'Grand Est', 'children': []},
          {'code': 'FR-HDF', 'name': 'Hauts-de-France', 'children': []},
          {'code': 'FR-IDF', 'name': 'Île-de-France', 'children': []},
          {'code': 'FR-NOR', 'name': 'Normandy', 'children': []},
          {'code': 'FR-NAQ', 'name': 'Nouvelle-Aquitaine', 'children': []},
          {'code': 'FR-OCC', 'name': 'Occitania', 'children': []},
          {'code': 'FR-PDL', 'name': 'Pays de la Loire', 'children': []},
          {'code': 'FR-PAC', 'name': 'Provence-Alpes-Côte d\'Azur', 'children': []},
        ]
      },
    ];
  }

  // 步骤配置
  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: '告诉我你的名字吧',
      subtitle: '这样我就能更好地陪伴你',
      type: OnboardingStepType.nickname,
    ),
    OnboardingStep(
      title: '选择你的性别',
      subtitle: '这样我能为你提供更贴心的建议',
      type: OnboardingStepType.gender,
    ),
    OnboardingStep(
      title: '你的生日是什么时候？',
      subtitle: '生日信息将用于为你生成专属的命盘分析',
      type: OnboardingStepType.birthday,
    ),
    OnboardingStep(
      title: '你的出生地在哪里？',
      subtitle: '出生地信息将用于生成准确的生辰八字和星盘分析',
      type: OnboardingStepType.address,
    ),
            OnboardingStep(
          title: '选择你的陪伴形象',
          subtitle: '选择一位能与你心灵共鸣的占卜师',
          type: OnboardingStepType.companion,
        ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部进度条
            _buildProgressBar(),
            
            // 主要内容区域
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildStepContent(_steps[index]);
                },
              ),
            ),
            
            // 底部按钮区域
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  /// 构建进度条
  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 步骤指示器
          Row(
            children: List.generate(_steps.length, (index) {
              bool isActive = index <= _currentStep;
              
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < _steps.length - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          
          // 步骤文字
          Text(
            '${_currentStep + 1} / ${_steps.length}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建步骤内容
  Widget _buildStepContent(OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // 插画区域
          Expanded(
            flex: 1,
            child: _buildStepIllustration(step.type),
          ),
          
          // 文字内容
          Expanded(
            flex: 1,
            child: _buildStepText(step),
          ),
          
          // 输入区域
          Expanded(
            flex: 3,
            child: _buildStepInput(step),
          ),
        ],
      ),
    );
  }

  /// 构建步骤插画
  Widget _buildStepIllustration(OnboardingStepType type) {
    IconData iconData;
    Color iconColor;
    
    switch (type) {
      case OnboardingStepType.nickname:
        iconData = Icons.person;
        iconColor = AppColors.primary;
        break;
      case OnboardingStepType.gender:
        iconData = Icons.favorite;
        iconColor = AppColors.secondary;
        break;
      case OnboardingStepType.birthday:
        iconData = Icons.cake;
        iconColor = AppColors.accent;
        break;
      case OnboardingStepType.address:
        iconData = Icons.location_on;
        iconColor = AppColors.secondary;
        break;
      case OnboardingStepType.companion:
        iconData = Icons.people_alt;
        iconColor = AppColors.primary;
        break;
    }
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 60,
        color: iconColor,
      ),
    );
  }

  /// 构建步骤文字
  Widget _buildStepText(OnboardingStep step) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          step.title,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          step.subtitle,
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建步骤输入
  Widget _buildStepInput(OnboardingStep step) {
    switch (step.type) {
      case OnboardingStepType.nickname:
        return _buildNicknameInput();
      case OnboardingStepType.gender:
        return _buildGenderSelection();
      case OnboardingStepType.birthday:
        return _buildBirthdaySelection();
      case OnboardingStepType.address:
        return _buildAddressSelection();
      case OnboardingStepType.companion:
        return _buildCompanionSelection();
    }
  }

  /// 构建昵称输入
  Widget _buildNicknameInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInputField(
          controller: _nicknameController,
          label: '昵称',
          hint: '请输入2-10个字符',
          maxLength: 10,
          onChanged: (value) {
            setState(() {
              _nickname = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          '昵称不能为空，请输入2-10个字符',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// 构建性别选择
  Widget _buildGenderSelection() {
    final genderOptions = [
      {'value': 'male', 'text': '男', 'icon': Icons.male, 'color': Colors.blue},
      {'value': 'female', 'text': '女', 'icon': Icons.female, 'color': Colors.pink},
      {'value': 'secret', 'text': '保密', 'icon': Icons.visibility_off, 'color': Colors.grey},
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...genderOptions.map((option) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildSelectionCard(
            text: option['text'] as String,
            icon: option['icon'] as IconData,
            iconColor: option['color'] as Color,
            isSelected: _gender == option['value'],
            onTap: () {
              setState(() {
                _gender = option['value'] as String;
              });
            },
          ),
        )),
      ],
    );
  }

  /// 构建生日选择
  Widget _buildBirthdaySelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 显示当前选择的生日
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _birthday != null 
                      ? '${_birthday!.year}年${_birthday!.month.toString().padLeft(2, '0')}月${_birthday!.day.toString().padLeft(2, '0')}日 ${_birthday!.hour.toString().padLeft(2, '0')}:${_birthday!.minute.toString().padLeft(2, '0')}:${_birthday!.second.toString().padLeft(2, '0')}'
                      : '请选择你的生日',
                  style: AppTextStyles.body1.copyWith(
                    color: _birthday != null ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // 提示文字
        Text(
          '年月日为必选项，时分秒为可选项',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // 生日选择器
        Expanded(
          child: _buildBirthdayPicker(),
        ),
      ],
    );
  }

  /// 构建生日选择器
  Widget _buildBirthdayPicker() {
    // 生成年份列表（1900年到当前年份）
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 1900 + 1, (index) => 1900 + index).reversed.toList();
    
    // 生成月份列表
    final months = List.generate(12, (index) => index + 1);
    
    // 生成日期列表（根据选择的年月动态生成）
    final selectedYear = _birthday?.year ?? currentYear;
    final selectedMonth = _birthday?.month ?? 1;
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final days = List.generate(daysInMonth, (index) => index + 1);
    
    // 生成时分秒列表
    final hours = List.generate(24, (index) => index);
    final minutes = List.generate(60, (index) => index);
    final seconds = List.generate(60, (index) => index);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // 标题行
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildPickerTitle('年', true)),
                Expanded(child: _buildPickerTitle('月', true)),
                Expanded(child: _buildPickerTitle('日', true)),
                Expanded(child: _buildPickerTitle('时', false)),
                Expanded(child: _buildPickerTitle('分', false)),
                Expanded(child: _buildPickerTitle('秒', false)),
              ],
            ),
          ),
          
          // 选择器行
          Expanded(
            child: Row(
              children: [
                // 年份选择器
                Expanded(
                  child: _buildPickerColumn(
                    items: years.map((year) => '$year').toList(),
                    selectedIndex: years.indexOf(_birthday?.year ?? currentYear),
                    onChanged: (index) {
                      final newYear = years[index];
                      final newMonth = _birthday?.month ?? 1;
                      final newDay = _birthday?.day ?? 1;
                      final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
                      final adjustedDay = newDay > daysInNewMonth ? daysInNewMonth : newDay;
                      
                      setState(() {
                        _birthday = DateTime(
                          newYear, 
                          newMonth, 
                          adjustedDay,
                          _birthday?.hour ?? 0,
                          _birthday?.minute ?? 0,
                          _birthday?.second ?? 0,
                        );
                      });
                    },
                  ),
                ),
                
                // 月份选择器
                Expanded(
                  child: _buildPickerColumn(
                    items: months.map((month) => month.toString().padLeft(2, '0')).toList(),
                    selectedIndex: months.indexOf(_birthday?.month ?? 1),
                    onChanged: (index) {
                      final newMonth = months[index];
                      final newYear = _birthday?.year ?? currentYear;
                      final newDay = _birthday?.day ?? 1;
                      final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
                      final adjustedDay = newDay > daysInNewMonth ? daysInNewMonth : newDay;
                      
                      setState(() {
                        _birthday = DateTime(
                          newYear, 
                          newMonth, 
                          adjustedDay,
                          _birthday?.hour ?? 0,
                          _birthday?.minute ?? 0,
                          _birthday?.second ?? 0,
                        );
                      });
                    },
                  ),
                ),
                
                // 日期选择器
                Expanded(
                  child: _buildPickerColumn(
                    items: days.map((day) => day.toString().padLeft(2, '0')).toList(),
                    selectedIndex: days.indexOf(_birthday?.day ?? 1),
                    onChanged: (index) {
                      final newDay = days[index];
                      final newYear = _birthday?.year ?? currentYear;
                      final newMonth = _birthday?.month ?? 1;
                      
                      setState(() {
                        _birthday = DateTime(
                          newYear, 
                          newMonth, 
                          newDay,
                          _birthday?.hour ?? 0,
                          _birthday?.minute ?? 0,
                          _birthday?.second ?? 0,
                        );
                      });
                    },
                  ),
                ),
                
                // 小时选择器
                Expanded(
                  child: _buildPickerColumn(
                    items: hours.map((hour) => hour.toString().padLeft(2, '0')).toList(),
                    selectedIndex: hours.indexOf(_birthday?.hour ?? 0),
                    onChanged: (index) {
                      final newHour = hours[index];
                      final newYear = _birthday?.year ?? currentYear;
                      final newMonth = _birthday?.month ?? 1;
                      final newDay = _birthday?.day ?? 1;
                      
                      setState(() {
                        _birthday = DateTime(
                          newYear, 
                          newMonth, 
                          newDay,
                          newHour,
                          _birthday?.minute ?? 0,
                          _birthday?.second ?? 0,
                        );
                      });
                    },
                  ),
                ),
                
                // 分钟选择器
                Expanded(
                  child: _buildPickerColumn(
                    items: minutes.map((minute) => minute.toString().padLeft(2, '0')).toList(),
                    selectedIndex: minutes.indexOf(_birthday?.minute ?? 0),
                    onChanged: (index) {
                      final newMinute = minutes[index];
                      final newYear = _birthday?.year ?? currentYear;
                      final newMonth = _birthday?.month ?? 1;
                      final newDay = _birthday?.day ?? 1;
                      final newHour = _birthday?.hour ?? 0;
                      
                      setState(() {
                        _birthday = DateTime(
                          newYear, 
                          newMonth, 
                          newDay,
                          newHour,
                          newMinute,
                          _birthday?.second ?? 0,
                        );
                      });
                    },
                  ),
                ),
                
                // 秒钟选择器
                Expanded(
                  child: _buildPickerColumn(
                    items: seconds.map((second) => second.toString().padLeft(2, '0')).toList(),
                    selectedIndex: seconds.indexOf(_birthday?.second ?? 0),
                    onChanged: (index) {
                      final newSecond = seconds[index];
                      final newYear = _birthday?.year ?? currentYear;
                      final newMonth = _birthday?.month ?? 1;
                      final newDay = _birthday?.day ?? 1;
                      final newHour = _birthday?.hour ?? 0;
                      final newMinute = _birthday?.minute ?? 0;
                      
                      setState(() {
                        _birthday = DateTime(
                          newYear, 
                          newMonth, 
                          newDay,
                          newHour,
                          newMinute,
                          newSecond,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建选择器标题
  Widget _buildPickerTitle(String title, bool isRequired) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        if (isRequired)
          Text(
            '必选',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontSize: 8,
            ),
          )
        else
          Text(
            '可选',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 8,
            ),
          ),
      ],
    );
  }

  /// 构建选择器列
  Widget _buildPickerColumn({
    required List<String> items,
    required int selectedIndex,
    required Function(int) onChanged,
  }) {
    // 确保索引在有效范围内
    final safeIndex = selectedIndex.clamp(0, items.length - 1);
    
    return ListWheelScrollView.useDelegate(
      itemExtent: 30,
      diameterRatio: 1.5,
      perspective: 0.01,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: safeIndex),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final isSelected = index == safeIndex;
          return Center(
            child: Text(
              items[index],
              style: AppTextStyles.body1.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: isSelected ? 16 : 14,
              ),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  /// 构建出生地选择
  Widget _buildAddressSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 当前选择的出生地显示
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedPath.isEmpty ? '请选择出生地' : _selectedPath.join(' - '),
                  style: AppTextStyles.body1.copyWith(
                    color: _selectedPath.length >= 3 ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          text: '选择出生地',
          onPressed: _worldDivisions.isEmpty ? null : _showDivisionPicker,
          width: double.infinity,
        ),
      ],
    );
  }

  void _showDivisionPicker() async {
    List<dynamic> level = _worldDivisions;
    List<String> path = [];
    
    while (true) {
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              String searchQuery = '';
              List<dynamic> filteredLevel = level;
              
              return SimpleDialog(
                title: Text(path.isEmpty ? '选择国家' : path.length == 1 ? '选择省/州' : '请选择'),
                children: [
                  // 搜索框（仅在选择国家时显示）
                  if (path.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: '搜索国家...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  // 当前路径显示
                  if (path.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '当前位置: ${path.join(' > ')}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  // 选项列表
                  Container(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: SingleChildScrollView(
                      child: Column(
                        children: (() {
                          // 根据搜索条件过滤列表
                          List<dynamic> displayList = level;
                          if (path.isEmpty && searchQuery.isNotEmpty) {
                            displayList = level.where((item) {
                              if (item is Map<String, dynamic> && item['name'] is String) {
                                return (item['name'] as String)
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase());
                              }
                              return false;
                            }).toList();
                          }
                          return displayList;
                        })().map<Widget>((item) {
                          // 确保item是Map类型且包含name字段
                          if (item is Map<String, dynamic> && item['name'] is String) {
                            return SimpleDialogOption(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'] as String,
                                        style: AppTextStyles.body1,
                                      ),
                                    ),
                                    // 如果有子项，显示箭头
                                    if (item['children'] is List && (item['children'] as List).isNotEmpty)
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, item['name'] as String);
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        }).toList(),
                      ),
                    ),
                  ),
                  // 返回上一级按钮
                  if (path.isNotEmpty)
                    SimpleDialogOption(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('返回上一级', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, '__back');
                      },
                    ),
                ],
              );
            },
          );
        },
      );
      
      if (result == null) break;
      if (result == '__back') {
        // 回退一级
        path.removeLast();
        // 重新定位level
        level = _worldDivisions;
        for (final name in path) {
          try {
            final found = level.firstWhere(
              (e) => e is Map<String, dynamic> && e['name'] == name,
            );
            if (found is Map<String, dynamic> && found['children'] is List) {
              level = found['children'];
            }
          } catch (e) {
            // 如果找不到，就中断循环
            break;
          }
        }
        continue;
      }
      
      path.add(result);
      
      try {
        final selected = level.firstWhere(
          (e) => e is Map<String, dynamic> && e['name'] == result,
        );
        
        if (selected is Map<String, dynamic> && selected['children'] is List && (selected['children'] as List).isNotEmpty) {
          // 有下级选项，继续选择
          level = selected['children'];
        } else {
          // 已选到最末级或无下级选项
          setState(() {
            _selectedPath = List.from(path);
            _birthCountry = path.isNotEmpty ? path[0] : '';
            _birthRegion = path.length > 1 ? path[1] : '';
            _birthCity = path.length > 2 ? path[2] : '';
          });
          break;
        }
      } catch (e) {
        // 如果找不到匹配项，说明已到最末级
        setState(() {
          _selectedPath = List.from(path);
          _birthCountry = path.isNotEmpty ? path[0] : '';
          _birthRegion = path.length > 1 ? path[1] : '';
          _birthCity = path.length > 2 ? path[2] : '';
        });
        break;
      }
    }
  }

  /// 构建陪伴形象选择
  Widget _buildCompanionSelection() {
    final companionOptions = [
      {
        'value': 'xiaoman',
        'name': '星语者·小满',
        'description': '温柔智慧的星语解读者，擅长情感占卜与心灵指导',
        'imagePath': 'assets/images/persona/xiaoman.png',
      },
      {
        'value': 'qingyang',
        'name': '云游道士·青阳',
        'description': '飘逸洒脱的云游道士，精通易经八卦与命理推演',
        'imagePath': 'assets/images/persona/qingyang.png',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: companionOptions.map((option) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildCompanionCard(
                value: option['value'] as String,
                name: option['name'] as String,
                description: option['description'] as String,
                imagePath: option['imagePath'] as String,
                isSelected: _companionPersona == option['value'],
                onTap: () {
                  print('🎭 选择陪伴形象: ${option['value']}');
                  setState(() {
                    _companionPersona = option['value'] as String;
                  });
                  print('🎭 _companionPersona更新为: $_companionPersona');
                  print('🎭 _canProceed(): ${_canProceed()}');
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建选择卡片
  Widget _buildSelectionCard({
    required String text,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : iconColor,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppTextStyles.body1.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建陪伴形象卡片
  Widget _buildCompanionCard({
    required String value,
    required String name,
    required String description,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // 形象头像
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // 文字信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.heading3.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // 选中指示器
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 跳过按钮
          if (_currentStep < _steps.length - 1)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: AppButton(
                text: '跳过，直接注册',
                onPressed: _skipOnboarding,
                type: ButtonType.text,
              ),
            ),
          
          // 主要按钮行
          Row(
            children: [
              // 上一步按钮
              if (_currentStep > 0)
                Expanded(
                  child: AppButton(
                    text: '上一步',
                    onPressed: _previousStep,
                    type: ButtonType.outline,
                  ),
                ),
              
              if (_currentStep > 0) const SizedBox(width: 16),
              
              // 下一步/完成按钮
              Expanded(
                child: AppButton(
                  text: _currentStep == _steps.length - 1 ? '完成' : '下一步',
                  onPressed: (_canProceed() && !_isProcessing) ? _nextStep : null,
                  type: ButtonType.primary,
                  isDisabled: !_canProceed() || _isProcessing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  /// 检查是否可以进入下一步
  bool _canProceed() {
    bool canProceed = false;
    switch (_steps[_currentStep].type) {
      case OnboardingStepType.nickname:
        canProceed = _nickname.trim().length >= 2;
        break;
      case OnboardingStepType.gender:
        canProceed = _gender.isNotEmpty;
        break;
      case OnboardingStepType.birthday:
        canProceed = _birthday != null; // 现在总是有默认值
        break;
      case OnboardingStepType.address:
        canProceed = _selectedPath.length >= 2; // 改为2级：国家+省份
        break;
      case OnboardingStepType.companion:
        canProceed = _companionPersona.isNotEmpty;
        print('🔍 companion步骤检查: _companionPersona="$_companionPersona", isEmpty=${_companionPersona.isEmpty}, canProceed=$canProceed');
        break;
    }
    print('🔍 当前步骤${_currentStep}(${_steps[_currentStep].type}) canProceed: $canProceed');
    return canProceed;
  }

  /// 下一步
  void _nextStep() {
    print('🚀 _nextStep调用，当前步骤: $_currentStep, 总步骤: ${_steps.length}');
    
          // 防止重复调用
      if (_isProcessing) {
        print('⚠️ 正在处理中，忽略重复点击');
        return;
      }
    
    if (!mounted) {
      print('⚠️ Widget未mounted，停止_nextStep执行');
      return;
    }
    
    _isProcessing = true;
    
    if (_currentStep == _steps.length - 1) {
      // 完成新手引导
      print('🎉 准备完成新手引导');
      _completeOnboarding();
    } else {
      // 进入下一步
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // 页面切换完成后重置处理状态
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          _isProcessing = false;
        }
      });
    }
  }

  /// 上一步
  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 跳过新手引导，直接进入注册
  void _skipOnboarding() {
    // 创建空的用户信息，后续在注册登录页面补充
    final user = UserModel(
      nickname: '',
      gender: '',
      birthday: null,
      companionPersona: '',
      province: '',
      city: '',
      district: '',
      town: '',
      detailAddress: '',
    );
    
    widget.onOnboardingCompleted(user);
  }

  /// 完成新手引导
  void _completeOnboarding() {
    print('✅ _completeOnboarding调用');
    print('📝 用户信息：昵称=$_nickname, 性别=$_gender, 陪伴形象=$_companionPersona');
    
    // 确保Widget还在树中
    if (!mounted) {
      print('⚠️ Widget未mounted，停止_completeOnboarding执行');
      return;
    }
    
    final user = UserModel(
      nickname: _nickname.trim(),
      gender: _gender,
      birthday: _birthday,
      companionPersona: _companionPersona,
      province: _selectedPath.isNotEmpty ? _selectedPath[0] : '',
      city: _selectedPath.length > 1 ? _selectedPath[1] : '',
      district: _selectedPath.length > 2 ? _selectedPath[2] : '',
      town: '',
      detailAddress: '',
    );
    
    print('🔄 调用回调函数 onOnboardingCompleted，mounted=$mounted');
    widget.onOnboardingCompleted(user);
    print('🔄 回调函数调用完成');
    
    // 重置处理状态
    _isProcessing = false;
  }
}

/// 新手引导步骤配置
class OnboardingStep {
  final String title;
  final String subtitle;
  final OnboardingStepType type;

  OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

/// 新手引导步骤类型
enum OnboardingStepType {
  nickname,  // 昵称设置
  gender,    // 性别选择
  birthday,  // 生日设置
  address,   // 出生地选择
  companion, // 陪伴形象选择
} 