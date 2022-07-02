import 'package:l2_devtools/models/skill_model.dart';

abstract class Mapper<T> {
  T map(List<String> lines);
}

class SkillMapper implements Mapper<SkillModel> {
  SkillMapper(this.splitter, this.skipFirstRow, this.fields);

  final String splitter;
  final bool skipFirstRow;
  final List<SkillField> fields;

  int getFieldIndex(String fieldName) {
    return fields
        .where((element) => element.fieldName == fieldName)
        .map((e) => e.index)
        .first;
  }

  factory SkillMapper.fromJson(Map map) {
    return SkillMapper(
      map['splitter'],
      map['skipFirstRow'],
      (map['fields'] as List).map((e) => SkillField.fromJson(e)).toList(),
    );
  }

  @override
  SkillModel map(List<String> lines) {
    return SkillModel(
      id: int.parse(lines[getFieldIndex('id')]),
      lvl: int.parse(lines[getFieldIndex('lvl')]),
      name: lines[getFieldIndex('name')],
      desc: lines[getFieldIndex('desc')],
      enchantName: lines[getFieldIndex('enchantName')],
      enchantDesc: lines[getFieldIndex('enchantDesc')],
    );
  }
}

class SkillField {
  SkillField(this.fieldName, this.index);

  final String fieldName;
  final int index;

  factory SkillField.fromJson(Map map) {
    return SkillField(map['fieldName'], map['index']);
  }
}
