class SkillModel {
  SkillModel(
      {required this.id,
      required this.lvl,
      required this.name,
      required this.desc,
      required this.enchantName,
      required this.enchantDesc});

  final int id;
  final int lvl;
  final String name;
  final String desc;
  final String enchantName;
  final String enchantDesc;
}
