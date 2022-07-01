import 'dart:io';

import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

class ImportSkills extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImportSkillsState();
}

class _ImportSkillsState extends State<ImportSkills> {
  int _index = 0;

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
                          const Text('Content for Step 1'),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                   FilesystemPicker.open(
                                    title: 'Save to folder',
                                    context: context,
                                    rootDirectory: Directory.systemTemp,
                                    fsType: FilesystemType.file,
                                  ).then((value) {
                                    value.toString();
                                   }).catchError((err){
                                     err.toString();
                                   });
                                  // setState(() {
                                  //   _index = 1 + _index;
                                  // });
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
