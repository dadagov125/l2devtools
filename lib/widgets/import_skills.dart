import 'dart:io';

import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path/path.dart' as path;

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

  @override
  void initState() {
    super.initState();
    pathCtrl = TextEditingController(text: 'C:\\SERVER\\salvation_patch\\system');
    skillNameRuDatCtrl = TextEditingController(text: 'skillname-ru.dat');
    skillNameEnDatCtrl = TextEditingController(text: 'skillname-e.dat');
    skillGrpCtrl = TextEditingController(text: 'skillgrp.dat');
    consoleCtrl = TextEditingController();
    consoleScrollCtrl =ScrollController();
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
                    child:TextField(
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
      var skillRuName = skillNameRuDatCtrl.text;

      var outputDec = path.join('data', 'skills', 'dec', skillRuName);
      var result = await Process.run('external/l2encdec.exe',
          ['-d', path.join(systemPath, skillRuName), outputDec]);
      _log(result.stdout);
      var outputTxt = path.join(
          'data', 'skills', 'txt', skillRuName.replaceAll('.dat', '.txt'));
      result = await Process.run('external/l2disasm.exe',
          ['-d', 'external/ddf/hf/skillname-ru.ddf', outputDec, outputTxt]);
      _log(result.stdout);
    }
    if (skillNameEnEnabled) {
      var skillEnName = skillNameEnDatCtrl.text;

      var outputDec = path.join('data', 'skills', 'dec', skillEnName);
      var result = await Process.run('external/l2encdec.exe',
          ['-d', path.join(systemPath, skillEnName), outputDec]);
      _log(result.stdout);
      var outputTxt = path.join(
          'data', 'skills', 'txt', skillEnName.replaceAll('.dat', '.txt'));
      result = await Process.run('external/l2disasm.exe',
          ['-d', 'external/ddf/hf/skillname-e.ddf', outputDec, outputTxt]);
      _log(result.stdout);
    }

    var skillGrp = skillGrpCtrl.text;

    var outputDec = path.join('data', 'skills', 'dec', skillGrp);
    var result = await Process.run('external/l2encdec.exe',
        ['-d', path.join(systemPath, skillGrp), outputDec]);
    _log(result.stdout);
    var outputTxt = path.join(
        'data', 'skills', 'txt', skillGrp.replaceAll('.dat', '.txt'));
    result = await Process.run('external/l2disasm.exe',
        ['-d', 'external/ddf/hf/skillgrp.ddf', outputDec, outputTxt]);
    _log(result.stdout);



  }

  void _log(dynamic logs) {
    setState((){
      consoleCtrl.text += logs.toString();
      consoleScrollCtrl.animateTo(consoleScrollCtrl.position.maxScrollExtent,
          duration: Duration(milliseconds: 50), curve: Curves.linear);
    });

  }
}
