import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService extends ChangeNotifier {
  bool _isSubscribed = false;
  String _selectedPlan = '';
  static const _subscriptionKey = 'isSubscribed';
  static const _selectedPlanKey = 'selectedPlan';

  SubscriptionService() {
    _loadSubscriptionStatus();
  }

  bool get isSubscribed => _isSubscribed;
  String get selectedPlan => _selectedPlan;

  void subscribe(String plan) async {
    _isSubscribed = true;
    _selectedPlan = plan;
    notifyListeners();
    _saveSubscriptionStatus();
  }

  void unsubscribe() async {
    _isSubscribed = false;
    _selectedPlan = '';
    notifyListeners();
    _saveSubscriptionStatus();
  }

  Future<void> _saveSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, _isSubscribed);
    await prefs.setString(_selectedPlanKey, _selectedPlan);
  }

  Future<void> _loadSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSubscribed = prefs.getBool(_subscriptionKey) ?? false;
    _selectedPlan = prefs.getString(_selectedPlanKey) ?? '';
    notifyListeners();
  }
}
