import 'package:flutter/material.dart';

import '../models/skill_model.dart';

class SkillsProvider extends ChangeNotifier {
  SkillsProvider() {}

  List<SkillModel> _skillList = [];
  Map<int, List<SkillModel>> _skillMap = {};

  void loadSkills() {
    List<SkillModel> loadedSkills = [];
    _skillList = loadedSkills;

    _skillList.forEach((skill) {
      if (!_skillMap.containsKey(skill.id)) {
        _skillMap[skill.id] = [skill];
      } else {
        final skills = _skillMap[skill.id]!;
        skills.add(skill);
      }
    });

    _skillMap.values.forEach((skills) {
      skills.sort((a, b) {
        return a.lvl - b.lvl;
      });
    });
    notifyListeners();
  }
}
