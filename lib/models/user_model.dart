/// 用户数据模型
/// 定义用户的基本信息结构，用于存储和管理用户数据
class UserModel {
  final String? id;           // 用户ID
  final String? phone;        // 手机号
  final String? nickname;     // 昵称
  final String? gender;       // 性别：male/female/secret
  final DateTime? birthday;   // 生日
  final String? emotionState; // 情感状态
  final String? companionPersona; // 陪伴形象：xiaoman/qingyang
  final String? province;     // 省份
  final String? city;         // 城市
  final String? district;     // 区县
  final String? town;         // 乡镇街道
  final String? detailAddress; // 详细地址
  final bool isRegistered;    // 是否已注册
  final DateTime? createdAt;  // 创建时间
  final DateTime? updatedAt;  // 更新时间

  UserModel({
    this.id,
    this.phone,
    this.nickname,
    this.gender,
    this.birthday,
    this.emotionState,
    this.companionPersona,
    this.province,
    this.city,
    this.district,
    this.town,
    this.detailAddress,
    this.isRegistered = false,
    this.createdAt,
    this.updatedAt,
  });

  /// 从JSON创建用户模型
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      nickname: json['nickname'],
      gender: json['gender'],
      birthday: json['birthday'] != null 
          ? DateTime.parse(json['birthday']) 
          : null,
      emotionState: json['emotionState'],
      companionPersona: json['companionPersona'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      town: json['town'],
      detailAddress: json['detailAddress'],
      isRegistered: json['isRegistered'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'emotionState': emotionState,
      'companionPersona': companionPersona,
      'province': province,
      'city': city,
      'district': district,
      'town': town,
      'detailAddress': detailAddress,
      'isRegistered': isRegistered,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 复制并更新部分字段
  UserModel copyWith({
    String? id,
    String? phone,
    String? nickname,
    String? gender,
    DateTime? birthday,
    String? emotionState,
    String? companionPersona,
    String? province,
    String? city,
    String? district,
    String? town,
    String? detailAddress,
    bool? isRegistered,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      emotionState: emotionState ?? this.emotionState,
      companionPersona: companionPersona ?? this.companionPersona,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      town: town ?? this.town,
      detailAddress: detailAddress ?? this.detailAddress,
      isRegistered: isRegistered ?? this.isRegistered,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 检查用户是否完成新手引导
  bool get isOnboardingCompleted {
    return nickname != null && 
           gender != null && 
           birthday != null && 
           companionPersona != null &&
           province != null &&
           city != null &&
           district != null &&
           town != null &&
           detailAddress != null;
  }

  /// 获取用户年龄
  int? get age {
    if (birthday == null) return null;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month || 
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  /// 获取性别显示文本
  String get genderText {
    switch (gender) {
      case 'male':
        return '男';
      case 'female':
        return '女';
      case 'secret':
        return '保密';
      default:
        return '';
    }
  }

  /// 获取情感状态显示文本
  String get emotionStateText {
    switch (emotionState) {
      case 'happy':
        return '开心满足';
      case 'calm':
        return '平静安宁';
      case 'sad':
        return '有些低落';
      case 'anxious':
        return '有些焦虑';
      case 'in_love':
        return '恋爱中';
      case 'confused':
        return '迷茫困惑';
      default:
        return '';
    }
  }

  /// 获取陪伴形象显示文本
  String get companionPersonaText {
    switch (companionPersona) {
      case 'xiaoman':
        return '星语者·小满';
      case 'qingyang':
        return '云游道士·青阳';
      default:
        return '';
    }
  }

  /// 获取陪伴形象头像路径
  String get companionPersonaImagePath {
    switch (companionPersona) {
      case 'xiaoman':
        return 'assets/images/persona/xiaoman.png';
      case 'qingyang':
        return 'assets/images/persona/qingyang.png';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id, phone: $phone, nickname: $nickname, gender: $gender, birthday: $birthday, emotionState: $emotionState, companionPersona: $companionPersona, province: $province, city: $city, district: $district, town: $town, detailAddress: $detailAddress, isRegistered: $isRegistered)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.phone == phone &&
        other.nickname == nickname &&
        other.gender == gender &&
        other.birthday == birthday &&
        other.emotionState == emotionState &&
        other.companionPersona == companionPersona &&
        other.province == province &&
        other.city == city &&
        other.district == district &&
        other.town == town &&
        other.detailAddress == detailAddress &&
        other.isRegistered == isRegistered;
  }

  @override
  int get hashCode {
    return Object.hash(id, phone, nickname, gender, birthday, emotionState, companionPersona, province, city, district, town, detailAddress, isRegistered);
  }
} 