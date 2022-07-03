import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:l2_devtools/models/skill_model.dart';
import 'package:path/path.dart' as path;

import '../models/skill_mapper.dart';
import '../services/enc_dec_service.dart';

class ImportSkills extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImportSkillsState();
}

class _ImportSkillsState extends State<ImportSkills> {
  late TextEditingController pathCtrl;
  late TextEditingController skillNameRuDatCtrl;
  late TextEditingController skillNameEnDatCtrl;
  late TextEditingController skillGrpCtrl;
  late TextEditingController consoleCtrl;
  late ScrollController consoleScrollCtrl;

  bool skillNameEnEnabled = true;
  bool skillNameRuEnabled = true;

  final EncDecService encDecService = EncDecService.Instance();

  @override
  void initState() {
    super.initState();
    pathCtrl =
        TextEditingController(text: 'C:\\SERVER\\salvation_patch\\system');
    skillNameRuDatCtrl = TextEditingController(text: 'skillname-ru.dat');
    skillNameEnDatCtrl = TextEditingController(text: 'skillname-e.dat');
    skillGrpCtrl = TextEditingController(text: 'skillgrp.dat');
    consoleCtrl = TextEditingController();
    consoleScrollCtrl = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import skills'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        // constraints: BoxConstraints(maxWidth: 600),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: pathCtrl,
                    onChanged: (value) {
                      this.setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text('Select L2 system folder'),
                      suffixIcon: IconButton(
                          onPressed: _selectFolder, icon: Icon(Icons.folder)),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: skillNameRuEnabled,
                        onChanged: (bool? value) {
                          this.setState(() {
                            skillNameRuEnabled = value ?? skillNameRuEnabled;
                          });
                        },
                      ),
                      Flexible(
                          child: TextField(
                        controller: skillNameRuDatCtrl,
                        enabled: skillNameRuEnabled,
                        onChanged: (value) {
                          this.setState(() {});
                        },
                        decoration: InputDecoration(
                          label: Text('RU: SkillName-ru.dat file'),
                        ),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: skillNameEnEnabled,
                        onChanged: (bool? value) {
                          this.setState(() {
                            skillNameEnEnabled = value ?? skillNameEnEnabled;
                          });
                        },
                      ),
                      Flexible(
                          child: TextField(
                        controller: skillNameEnDatCtrl,
                        enabled: skillNameEnEnabled,
                        onChanged: (value) {
                          this.setState(() {});
                        },
                        decoration: InputDecoration(
                            label: Text('En: SkillName-e.dat file')),
                      ))
                    ],
                  ),
                  TextField(
                    controller: skillGrpCtrl,
                    onChanged: (value) {
                      this.setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text('SkillGrp.dat file'),
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                child: SingleChildScrollView(
              controller: consoleScrollCtrl,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      // scrollController: consoleScrollCtrl,
                      controller: consoleCtrl,
                      enabled: false,
                      style: TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        label: Text('Console'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          child: Text('Import'),
          onPressed: _validate() ? _import : null,
        ),
      ),
    );
  }

  bool _validate() {
    if (pathCtrl.text.isEmpty) return false;
    if (skillGrpCtrl.text.isEmpty) return false;
    if (skillNameRuEnabled && skillNameRuDatCtrl.text.isEmpty) return false;
    if (skillNameEnEnabled && skillNameEnDatCtrl.text.isEmpty) return false;
    if (!skillNameRuEnabled && !skillNameEnEnabled) return false;

    return true;
  }

  void _selectFolder() {
    FilesystemPicker.open(
            title: 'Select folder',
            context: context,
            rootDirectory: Directory('\\'),
            fsType: FilesystemType.folder,
            pickText: 'Select',
            folderIconColor: Colors.red,
            fileTileSelectMode: FileTileSelectMode.wholeTile)
        .then((value) {
      setState(() {
        pathCtrl.text = value ?? pathCtrl.text;
        consoleCtrl.text += '\nl2 system folder: ${value}';
      });
    }).catchError((err) {
      consoleCtrl.text += err.toString();
    });
  }

  void _import() async {
    var systemPath = pathCtrl.text;
    if (skillNameRuEnabled) {
      var filename = path.setExtension(skillNameRuDatCtrl.text, '');

      var outputDec = path.join('data', 'skills', 'dec', filename);
      var inputEnc = path.join(systemPath, filename);
      var log = await encDecService.decode(inputEnc, outputDec);
      _log(log);

      var outputTxt = path.join('data', 'skills', 'txt', filename);

      var ddf = path.join('config', 'hf', 'ddf', 'skillname-ru.ddf');
      log = await encDecService.disasm(ddf, outputDec, outputTxt);
      _log(log);


      ////////////////

      List<SkillModel> skills = [];


      var jsonStr = File('config/hf/mappers/skillname.json').readAsStringSync();
      var map = jsonDecode(jsonStr);
      var mapper = SkillMapper.fromJson(map);


      var file = File(path.setExtension(outputTxt, '.txt'));
      var list = file.readAsLinesSync();
      for (var i = 0; i < list.length; i++) {
        if (i == 0 && mapper.skipFirstRow) continue;
        var line = list[i];
        var model = mapper.fromLine(line);
        skills.add(model);
      }
    }
    // if (skillNameEnEnabled) {
    //   var filename = skillNameEnDatCtrl.text;
    //
    //   var outputDec = path.join('data', 'skills', 'dec', filename);
    //   var inputEnc = path.join(systemPath, filename);
    //   var log = await encDecService.decode(inputEnc, outputDec);
    //   _log(log);
    //
    //   var outputTxt = path.join('data', 'skills', 'txt', filename);
    //
    //   var ddf = path.join('config', 'hf', 'ddf', 'skillname-e.ddf');
    //   log = await encDecService.disasm(ddf, outputDec, outputTxt);
    //   _log(log);
    // }

    var filename = skillGrpCtrl.text;


    var outputDec = path.join('data', 'skills', 'dec', filename);
    var inputEnc = path.join(systemPath, filename);
    var log = await encDecService.decode(inputEnc, outputDec);
    _log(log);

    var outputTxt = path.join('data', 'skills', 'txt', filename);

    var ddf = path.join('config', 'hf', 'ddf', 'skillgrp.ddf');
    log = await encDecService.disasm(ddf, outputDec, outputTxt);
    _log(log);

    var jsonStr = File('config/hf/mappers/skillgrp.json').readAsStringSync();
    var map = jsonDecode(jsonStr);
    var mapper = SkillGrpMapper.fromJson(map);

    var file = File(path.setExtension(outputTxt, '.txt'));
    var list = file.readAsLinesSync();
    List<SkillGrpModel> grp=[];
    for (var i = 0; i < list.length; i++) {
      if (i == 0 && mapper.skipFirstRow) continue;
      var line = list[i];
      var model = mapper.fromLine(line);
      grp.add(model);
    }

    var last = grp.last;
    last.toString();
  }

  void _log(dynamic logs) {
    setState(() {
      consoleCtrl.text += logs.toString();
      consoleScrollCtrl.animateTo(consoleScrollCtrl.position.maxScrollExtent,
          duration: Duration(milliseconds: 50), curve: Curves.linear);
    });
  }
}
