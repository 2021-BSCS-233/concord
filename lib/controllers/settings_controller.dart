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
  final MyAuthentication myAuthentication = MyAuthentication();
  Map<String, List<String>> categories = {};
  bool didChange = false;
  var selectedLang = 0.obs;
  var showMenu = false.obs;

  @override
  void onInit() {
    super.onInit();
    final Map languageIndex = {
      'en': 1,
      'es': 2,
    };
    selectedLang.value = languageIndex[userSettings.language];
    getCategories();
  }

  String field1Message = '';
  bool field1Bool = false;
  var showValueField1 = false.obs;
  var showValueField2 = false.obs;
  var checking = false.obs;
  TextEditingController usernameTC = TextEditingController();
  TextEditingController emailTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  TextEditingController newPassTC = TextEditingController();

  getCategories() async {
    categories = _fallbackCustomCategories;
    Map<String, List<String>> response = await apiCalls.getCategoriesPerform();
    if (response.isNotEmpty) {
      categories = response;
    }
  }

  void saveSettings() {
    if (didChange) {
      myFirestore.saveSettingsFirebase(userSettings);
    }
  }

  Future<void> checkUsernameAvailability() async {
    String username = usernameTC.text.trim();
    if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(username) &&
        username.length >= 3 &&
        username.length <= 20) {
      checking.value = true;
      var result =
          await myFirestore.checkUsernameAvailabilityFirebase(username);
      if (result) {
        field1Message = 'Username available';
        field1Bool = true;
        checking.value = false;
        showValueField1.value = true;
      } else {
        field1Message = 'Username not available';
        field1Bool = false;
        checking.value = false;
        showValueField1.value = true;
      }
    } else {
      field1Message = 'Invalid Username';
      field1Bool = false;
      showValueField1.value = true;
    }
  }

  Future<bool> changeUsername() async {
    if (field1Bool) {
      var result = await myAuthentication.changeUsernameFirebase(
          usernameTC.text.trim().toLowerCase(), passwordTC.text.trim());
      if (!result) {
        showValueField2.value = true;
        return false;
      }
      update(['accountPage']);
      return true;
    }
    return false;
  }

  void changeEmail() {}

  void changePass() {}

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
