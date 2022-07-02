import 'dart:io';

import 'package:path/path.dart' as path;

class EncDecService {
  EncDecService._();

  final datExt = '.dat';
  final txtExt = '.txt';
  static final EncDecService _instance = EncDecService._();

  factory EncDecService.Instance() {
    return _instance;
  }

  Future<String> decode(String input, String output) async {
    if (path.extension(input) != datExt) {
      input = path.setExtension(input, datExt);
    }
    if (path.extension(output) != datExt) {
      output = path.setExtension(output, datExt);
    }

    var result =
        await Process.run('external/l2encdec.exe', ['-d', input, output]);
    return result.stdout;
  }

  Future<String> disasm(String ddf, String input, String output) async {
    if (path.extension(input) != datExt) {
      input = path.setExtension(input, datExt);
    }
    if (path.extension(output) != txtExt) {
      output = path.setExtension(output, txtExt);
    }
    var result =
        await Process.run('external/l2disasm.exe', ['-d', ddf, input, output]);
    return result.stdout;
  }
}
