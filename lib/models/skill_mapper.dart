import 'package:l2_devtools/models/skill_model.dart';

abstract class Mapper<T> {
  Mapper(this.splitter, this.skipFirstRow, this.fields);
   final String  splitter;
   final bool  skipFirstRow;
   final List<SkillField>  fields;

  T fromLine(String line);

  String toLine(T model);

  int getFieldIndex(String fieldName) {
    return this.fields
        .where((element) => element.fieldName == fieldName)
        .map((e) => e.index)
        .first;
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

class SkillMapper extends Mapper<SkillModel> {
  SkillMapper(super.splitter, super.skipFirstRow, super.fields);

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

  factory SkillMapper.fromJson(Map map) {
    return SkillMapper(
      map['splitter'],
      map['skipFirstRow'],
      (map['fields'] as List).map((e) => SkillField.fromJson(e)).toList(),
    );
  }
}

class SkillGrpMapper extends Mapper<SkillGrpModel>{
  SkillGrpMapper(super.splitter, super.skipFirstRow, super.fields);

  @override
  SkillGrpModel fromLine(String line) {
    final split = line.split(splitter);
    return SkillGrpModel(
      id: int.parse(split[getFieldIndex('id')]),
      lvl: int.parse(split[getFieldIndex('lvl')]),
      skillPosition: int.parse(split[getFieldIndex('skillPosition')]),
      operateType: int.parse(split[getFieldIndex('operateType')]),
      mpConsume: int.parse(split[getFieldIndex('mpConsume')]),
      castRange: int.parse(split[getFieldIndex('castRange')]),
      castStyle: int.parse(split[getFieldIndex('castStyle')]),
      hitTime: double.parse(split[getFieldIndex('hitTime')]),
      isMagic: int.parse(split[getFieldIndex('isMagic')]),
      animation: split[getFieldIndex('lvl')].toString(),
      skillVisualEffect: split[getFieldIndex('skillVisualEffect')].toString(),
      icon: split[getFieldIndex('icon')].toString(),
      iconPanel: split[getFieldIndex('iconPanel')].toString(),
      debuff: int.parse(split[getFieldIndex('debuff')]),

      enchanted: int.parse(split[getFieldIndex('enchanted')]),
      enchantSkillLevel: int.parse(split[getFieldIndex('enchantSkillLevel')]),
      enchantIcon: split[getFieldIndex('enchantIcon')].toString(),

      hpConsume: int.parse(split[getFieldIndex('hpConsume')]),
      rumbleSelf: int.parse(split[getFieldIndex('rumbleSelf')]),
      rumbleTarget: int.parse(split[getFieldIndex('rumbleTarget')]),

      gaugeTime: double.parse(split[getFieldIndex('gaugeTime')]),

      additionalTag: split[getFieldIndex('additionalTag')].toString(),


    );
  }

  @override
  String toLine(SkillGrpModel model) {
    // TODO: implement toLine
    throw UnimplementedError();
  }

  factory SkillGrpMapper.fromJson(Map map) {
    return SkillGrpMapper(
      map['splitter'],
      map['skipFirstRow'],
      (map['fields'] as List).map((e) => SkillField.fromJson(e)).toList(),
    );
  }

}

