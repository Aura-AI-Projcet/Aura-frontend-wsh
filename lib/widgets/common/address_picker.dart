import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'app_button.dart';

/// 地址选择器组件
/// 支持省市区镇四级联动选择
class AddressPicker extends StatefulWidget {
  final Function(String country, String province, String city, String district) onAddressSelected;
  final String? initialCountry;
  final String? initialProvince;
  final String? initialCity;
  final String? initialDistrict;

  const AddressPicker({
    super.key,
    required this.onAddressSelected,
    this.initialCountry,
    this.initialProvince,
    this.initialCity,
    this.initialDistrict,
  });

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  List<dynamic> _addressData = [];
  String? _selectedCountry;
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAddressData();
    _selectedCountry = widget.initialCountry;
    _selectedProvince = widget.initialProvince;
    _selectedCity = widget.initialCity;
    _selectedDistrict = widget.initialDistrict;
  }

  Future<void> _loadAddressData() async {
    setState(() {
      _loading = true;
    });
    final String jsonStr = await rootBundle.loadString('assets/geo/world_divisions.json');
    final List<dynamic> data = json.decode(jsonStr);
    setState(() {
      _addressData = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                Icons.location_on,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getAddressText(),
                  style: AppTextStyles.body1.copyWith(
                    color: _isAddressComplete() ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          text: '选择地址',
          onPressed: _loading ? null : _showAddressPicker,
          type: ButtonType.outline,
        ),
      ],
    );
  }

  String _getAddressText() {
    if (_selectedCountry == null) {
      return '请选择国家/地区';
    }
    List<String> parts = [_selectedCountry!];
    if (_selectedProvince != null) parts.add(_selectedProvince!);
    if (_selectedCity != null) parts.add(_selectedCity!);
    if (_selectedDistrict != null) parts.add(_selectedDistrict!);
    return parts.join(' ');
  }

  bool _isAddressComplete() {
    return _selectedCountry != null && _selectedProvince != null && _selectedCity != null && _selectedDistrict != null;
  }

  void _showAddressPicker() {
    final List<String> countries = _addressData.map<String>((e) => e['name'] as String).toList();
    
    final List<String> provinces = _selectedCountry == null
        ? []
        : () {
            final countryData = _addressData.firstWhere(
              (e) => e['name'] == _selectedCountry, 
              orElse: () => {'children': <dynamic>[]}
            );
            final children = countryData['children'] as List<dynamic>?;
            return children?.map<String>((e) => e['name'] as String).toList() ?? <String>[];
          }();
          
    final List<String> cities = _selectedProvince == null || _selectedCountry == null
        ? []
        : () {
            final countryData = _addressData.firstWhere((e) => e['name'] == _selectedCountry);
            final countryChildren = countryData['children'] as List<dynamic>?;
            if (countryChildren == null) return <String>[];
            
            final provinceData = countryChildren.firstWhere(
              (e) => e['name'] == _selectedProvince, 
              orElse: () => {'children': <dynamic>[]}
            );
            final children = provinceData['children'] as List<dynamic>?;
            return children?.map<String>((e) => e['name'] as String).toList() ?? <String>[];
          }();
          
    final List<String> districts = _selectedCity == null || _selectedProvince == null || _selectedCountry == null
        ? []
        : () {
            final countryData = _addressData.firstWhere((e) => e['name'] == _selectedCountry);
            final countryChildren = countryData['children'] as List<dynamic>?;
            if (countryChildren == null) return <String>[];
            
            final provinceData = countryChildren.firstWhere((e) => e['name'] == _selectedProvince);
            final provinceChildren = provinceData['children'] as List<dynamic>?;
            if (provinceChildren == null) return <String>[];
            
            final cityData = provinceChildren.firstWhere(
              (e) => e['name'] == _selectedCity, 
              orElse: () => {'children': <dynamic>[]}
            );
            final children = cityData['children'] as List<dynamic>?;
            return children?.map<String>((e) => e['name'] as String).toList() ?? <String>[];
          }();
          
    _showSimplePicker(countries, provinces, cities, districts);
  }

  void _showSimplePicker(List<String> countries, List<String> provinces, List<String> cities, List<String> districts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择地址'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(labelText: '国家/地区'),
                items: countries.map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                    _selectedProvince = null;
                    _selectedCity = null;
                    _selectedDistrict = null;
                  });
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: const InputDecoration(labelText: '省/州'),
                items: provinces.map((province) => DropdownMenuItem(
                  value: province,
                  child: Text(province),
                )).toList(),
                onChanged: _selectedCountry != null ? (value) {
                  setState(() {
                    _selectedProvince = value;
                    _selectedCity = null;
                    _selectedDistrict = null;
                  });
                } : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(labelText: '城市'),
                items: cities.map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                )).toList(),
                onChanged: _selectedProvince != null ? (value) {
                  setState(() {
                    _selectedCity = value;
                    _selectedDistrict = null;
                  });
                } : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                decoration: const InputDecoration(labelText: '区/县'),
                items: districts.map((district) => DropdownMenuItem(
                  value: district,
                  child: Text(district),
                )).toList(),
                onChanged: _selectedCity != null ? (value) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                } : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (_selectedCountry != null && _selectedProvince != null && _selectedCity != null && _selectedDistrict != null) {
                widget.onAddressSelected(_selectedCountry!, _selectedProvince!, _selectedCity!, _selectedDistrict!);
              }
              Navigator.of(context).pop();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
} 