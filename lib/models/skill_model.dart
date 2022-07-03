import 'id.dart';

abstract class SkillBase implements Id {
  SkillBase(this.id, this.lvl);

  @override
  final int id;
  final int lvl;

  bool isRootLvl() {
    return lvl == 1;
  }

  bool isSubLvl() {
    return lvl > 1 && lvl < 100;
  }

  bool isEnchantLvl() {
    return lvl >= 100;
  }
}

class SkillModel extends SkillBase {
  SkillModel(
      {required int id,
      required int lvl,
      required this.name,
      required this.desc,
      required this.enchantName,
      required this.enchantDesc})
      : super(id, lvl);

  final String name;
  final String desc;
  final String enchantName;
  final String enchantDesc;
}

class SkillGrpModel extends SkillBase {
  SkillGrpModel({
    required int id,
    required int lvl,
    required this.skillPosition,
    required this.operateType,
    required this.mpConsume,
    required this.castRange,
    required this.castStyle,
    required this.hitTime,
    required this.isMagic,
    required this.animation,
    required this.skillVisualEffect,
    required this.icon,
    required this.iconPanel,
    required this.debuff,
    required this.enchanted,
    required this.enchantSkillLevel,
    required this.enchantIcon,
    required this.hpConsume,
    required this.rumbleSelf,
    required this.rumbleTarget,
    required this.gaugeTime,
    required this.additionalTag,
  }) : super(id, lvl);

  final int skillPosition;
  final int operateType;
  final int mpConsume;
  final int castRange;
  final int castStyle;
  final double hitTime;
  final int isMagic;
  final String animation;
  final String skillVisualEffect;
  final String icon;
  final String iconPanel;
  final int debuff;
  final int enchanted;
  final int enchantSkillLevel;
  final String enchantIcon;
  final int hpConsume;
  final int rumbleSelf;
  final int rumbleTarget;
  final double gaugeTime;
  final String additionalTag;
}


