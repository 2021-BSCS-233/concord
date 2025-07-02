import 'package:concord/models/settings_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  SettingsModel userSettings;
  SettingsController({required this.userSettings});

  APICalls apiCalls = APICalls();
  final MyFirestore myFirestore = MyFirestore();
  Map<String, List<String>> categories = {};
  bool didChange = false;
  Rx<int> selectedLang = 0.obs;
  Rx<bool> showMenu = false.obs;

  @override
  void onInit(){
    super.onInit();
    final Map languageIndex = {
      'en': 1,
      'es': 2,
    };
    selectedLang.value = languageIndex[userSettings.language];
  }

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  getCategories() async {
    categories = _fallbackCustomCategories;
    Map<String, List<String>> response = await apiCalls.getCategoriesPerform();
    if (response.isNotEmpty) {
      categories = response;
    }
  }

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }

  void saveSettings() {
    if (didChange) {
      myFirestore.saveSettingsFirebase(userSettings);
    }
  }

  final Map<String, List<String>> _fallbackCustomCategories = {
    'Programming': [
      'Python',
      'JavaScript',
      'Flutter',
      'Firebase',
      'C# & .NET',
      'Java & Android',
      'Databases',
      'APIs & Networking',
      'Frontend Development',
      'Backend Development',
    ],
    'Education & Learning': [
      'Academic Subjects',
      'Study Skills',
      'Online Learning'
    ],
    'Health & Wellness': [
      'Physical Health',
      'Mental Health',
      'Diet & Nutrition'
    ],
    'Home & Lifestyle': [
      'Cooking',
      'Home Improvement & DIY',
      'Personal Finance',
      'Parenting & Family',
      'Hobbies & Crafts'
    ],
    'Arts & Culture': [
      'Visual Arts',
      'Performing Arts',
      'Literature',
      'Film & Television'
    ],
    'News': [
      'Politics & Government',
      'Social Issues',
      'World News',
      'Local News'
    ]
  };
}
