import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AssTraIoUtil {

  static Future<String> saveFile(String filename, String fileContent) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <=29) {
      var storage = await Permission.storage.status;
      if (storage != PermissionStatus.granted) {
        await Permission.storage.request();
      }
    } else {
      var storage = await Permission.manageExternalStorage.status;
      if (storage != PermissionStatus.granted) {
        await Permission.manageExternalStorage.request();
      }
    }

    File file;
    try {
      String? dir = await FilePicker.platform.getDirectoryPath();
      file = File('$dir/$filename');
      if (await file.exists()) await file.delete();
      await file.writeAsString(fileContent);
    } catch (exception) {
      return "";
    }

    return file.path;
  }

  static Future<File?> pickFile() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <=29) {
      var storage = await Permission.storage.status;
      if (storage != PermissionStatus.granted) {
        await Permission.storage.request();
      }
    } else {
      var storage = await Permission.manageExternalStorage.status;
      if (storage != PermissionStatus.granted) {
        await Permission.manageExternalStorage.request();
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false, dialogTitle: 'Pick import file');
    List<File>? files = result?.paths.map((path) => File(path!)).toList();
    if (files != null && files.isNotEmpty) return files.elementAt(0);
    return null;
  }

}