import 'package:l2_devtools/models/skill_model.dart';

abstract class Mapper<T> {
  T fromLine(String line);

  String toLine(T model);
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
  SkillModel fromLine(String line) {
    var split = line.split(splitter);
    return SkillModel(
      id: int.parse(split[getFieldIndex('id')]),
      lvl: int.parse(split[getFieldIndex('lvl')]),
      name: split[getFieldIndex('name')],
      desc: split[getFieldIndex('desc')],
      enchantName: split[getFieldIndex('enchantName')],
      enchantDesc: split[getFieldIndex('enchantDesc')],
    );
  }

  @override
  String toLine(SkillModel model) {
    List<String> split = List.generate(fields.length, (index) => 'none');

    split[getFieldIndex('id')] = model.id.toString();
    split[getFieldIndex('lvl')] = model.lvl.toString();
    split[getFieldIndex('name')] = model.name.toString();
    split[getFieldIndex('desc')] = model.desc.toString();
    split[getFieldIndex('enchantName')] = model.enchantName.toString();
    split[getFieldIndex('enchantDesc')] = model.enchantDesc.toString();
    return split.join('\t');
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
