# 调试命令记录

## 最新修复记录 (2024-07-31)

### 🐛 修复问题
1. **陪伴形象图片不显示**
   - 问题：中文文件名导致图片加载失败
   - 解决：重命名图片文件为英文名称
   - 修改：`星语者·小满海报.png` → `xiaoman.png`
   - 修改：`云游道士·青阳海报.png` → `qingyang.png`

2. **完成按钮无反应**
   - 问题：setState() called after dispose() 错误
   - 解决：添加mounted状态检查
   - 添加：调试日志追踪问题

### 🔍 调试步骤
```bash
# 1. 清理构建缓存
flutter clean
flutter pub get

# 2. 重命名图片文件（已完成）
cd assets/images/persona
mv "星语者·小满海报.png" "xiaoman.png"
mv "云游道士·青阳海报.png" "qingyang.png"

# 3. 启动应用并观察调试日志
flutter run -d emulator-5554 --debug

# 4. 查看调试日志
# 在终端中查找以下调试信息：
# DEBUG: _completeOnboarding called
# DEBUG: _companionPersona = [selected_value]
# DEBUG: _onOnboardingCompleted called with user: [user_info]
```

## 快速启动命令

### 1. 完整体验（包含新手引导 + 注册登录 + 核心功能）

#### Android 启动
```bash
# 启动安卓模拟器
flutter emulators --launch Pixel_3a_API_34_extension_level_7_arm64-v8a

# 在安卓上启动应用（完整流程）
flutter run -d emulator-5554 --debug

# 如果遇到NDK错误，执行以下修复步骤：
# 1. 注释掉NDK配置
# 2. 清理损坏的NDK目录
rm -rf /Users/wangshanghong/Library/Android/sdk/ndk/*
# 3. 清理构建缓存
flutter clean
flutter pub get
# 4. 重新启动
flutter run -d emulator-5554 --debug
```

#### Chrome 启动
```bash
# 在Chrome上启动应用（完整流程）
flutter run -d chrome --debug
```

### 2. 跳过注册登录，直接进入主页面

#### Android 启动（跳过认证）
```bash
flutter run -d emulator-5554 --debug --dart-define=SKIP_AUTH=true
```

#### Chrome 启动（跳过认证）
```bash
flutter run -d chrome --debug --dart-define=SKIP_AUTH=true
```

## 应用功能说明

### 完整流程体验
1. **新手引导**：昵称、生日、出生地、陪伴形象选择（可跳过）
2. **陪伴形象选择**：星语者·小满 / 云游道士·青阳（新功能）
3. **注册登录**：支持手机号和邮箱两种方式，支持国际区号选择
4. **主界面**：底部三个标签页
   - **聊一聊**：AI对话，智能开场白，情感陪伴
   - **抽一卦**：塔罗牌抽签，个性化解读
   - **我的**：用户资料页面

### 核心功能使用指南

#### 陪伴形象选择（新功能）
- 进入新手引导的第5步
- 选择 **星语者·小满**：温柔智慧的星语解读者
- 选择 **云游道士·青阳**：飘逸洒脱的云游道士
- 点击「完成」直接进入对话界面

#### 聊一聊（AI对话）
- 进入应用后，点击底部"聊一聊"标签
- AI会根据你选择的陪伴形象提供个性化开场白
- 支持多种对话意图识别：占卜、焦虑舒缓、情感咨询等
- 整合了生辰八字、紫微斗数、占星、塔罗等知识体系

#### 抽一卦（塔罗牌）
- 点击底部"抽一卦"标签
- 点击"开始抽签"按钮
- 系统会随机抽取一张塔罗牌（大阿尔卡纳22张）
- 提供牌面解释、个人化建议和深层洞察
- 支持重新抽取和转到聊天页面继续深入交流

## Android 应用访问指南

### 在模拟器中找到应用
1. 启动命令执行后，等待构建完成
2. 应用会自动安装并启动
3. 如果没有自动启动，在模拟器桌面找到"Aura"图标
4. 应用名称显示为"Aura"，图标为Flutter默认图标

### 如果应用没有自动启动
```bash
# 重新启动应用
flutter run -d emulator-5554 --debug
```

## NDK 问题解决方案

如果遇到 `[CXX1101] NDK at ... did not have a source.properties file` 错误：

### 方法1：禁用NDK（推荐）
已在 `android/app/build.gradle.kts` 和 `android/gradle.properties` 中禁用NDK

### 方法2：清理NDK目录
```bash
# 删除损坏的NDK安装
rm -rf /Users/wangshanghong/Library/Android/sdk/ndk/*

# 清理构建缓存
flutter clean
flutter pub get

# 重新启动
flutter run -d emulator-5554 --debug
```

## 故障排除

### 如果模拟器没有启动
```bash
# 列出可用的模拟器
flutter emulators

# 启动特定模拟器
flutter emulators --launch [模拟器名称]
```

### 如果构建失败
```bash
# 清理所有缓存
flutter clean
flutter pub get

# 检查Flutter环境
flutter doctor

# 重新启动
flutter run -d [设备ID] --debug
```

### 检查连接的设备
```bash
flutter devices
```

### 如果图片不显示
1. 检查文件是否存在：`ls -la assets/images/persona/`
2. 确认文件名为英文：`xiaoman.png`, `qingyang.png`
3. 重新构建应用：`flutter clean && flutter pub get && flutter run`

### 如果完成按钮无反应
1. 查看控制台调试日志
2. 确认是否有 `setState() called after dispose()` 错误
3. 检查调试输出中的 `DEBUG:` 信息

## 更新记录
- 2024-07-31: 修复陪伴形象图片显示问题（文件重命名）
- 2024-07-31: 修复完成按钮无反应问题（mounted检查）
- 2024-07-31: 添加详细调试日志
- 2024-07-31: 解决NDK配置问题，成功在Android模拟器上启动应用
- 2024-xx-xx: 添加聊天和抽签功能，完整的AI对话体验
- 2024-xx-xx: 实现完整的新手引导和注册登录流程
- 2024-xx-xx: 添加跳过认证的开发模式