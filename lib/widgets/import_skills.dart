import 'dart:io';

import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

class ImportSkills extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImportSkillsState();
}

class _ImportSkillsState extends State<ImportSkills> {
  int _index = 0;
  late TextEditingController pathCtrl;

  @override
  void initState() {
    super.initState();
    pathCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stepper(
              currentStep: _index,
              controlsBuilder: (_, __) => SizedBox.shrink(),
              onStepTapped: (int index) {
                if (index != 0) return;
                setState(() {
                  _index = index;
                });
              },
              steps: <Step>[
                Step(
                  title: const Text('Select L2 system folder'),
                  isActive: true,
                  state: StepState.complete,
                  content: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: pathCtrl,
                            onChanged: (value){
                              this.setState(() {
                              });
                            },
                            decoration: InputDecoration(
                              label: Text('Path'),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    FilesystemPicker.open(
                                            title: 'Select folder',
                                            context: context,
                                            rootDirectory: Directory('\\'),
                                            fsType: FilesystemType.folder,
                                            pickText: 'Select',
                                            folderIconColor: Colors.red,
                                            fileTileSelectMode:
                                                FileTileSelectMode.wholeTile)
                                        .then((value) {
                                      pathCtrl.text=value??pathCtrl.text;
                                    }).catchError((err) {
                                      err.toString();
                                    });
                                  },
                                  icon: Icon(Icons.folder)),
                            ),
                          ),
                          const Text('Content for Step 1'),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                                onPressed:pathCtrl.text.isEmpty?null: () {
                                  setState(() {
                                    _index = 1 + _index;
                                  });
                                },
                                child: Text('Continue')),
                          )
                        ],
                      )),
                ),
                const Step(
                  title: Text('Step 2 title'),
                  isActive: true,
                  content: Text('Content for Step 2'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
