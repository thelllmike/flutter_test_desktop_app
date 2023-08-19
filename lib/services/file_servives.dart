import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metatube/utils/snackBar.dart';

class FileService {
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedField;
  String _selectedDirectory = '';

  void saveContent(context) async {
    final title = titlecontroller.text;
    final description = descriptionController.text;
    final tag = tagController.text;

    final textContent =
        "Title:\n\n$title\n\nDescription:\n\n$description\n\nTags:\n\n$tag";

    try {
      if (_selectedField != null) {
        await _selectedField!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        String metadataDirPath = _selectedDirectory;
        if (metadataDirPath.isEmpty) {
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = metadataDirPath = directory!;
        }
        final filePath = '$metadataDirPath/$todayDate - $title - MetaData.txt';
        //c:/mike/desktop/2023/ this is tilelt - metadata txt
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);
      }
      SnackBarUtils.showSnackBar(
          context, Icons.check_circle, 'File saved successfully');
    } catch (e) {
      SnackBarUtils.showSnackBar(context, Icons.error, 'File ot saved');
    }
  }

  void loadFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        _selectedField = file;

        final fileContent = await file.readAsString();

        final lines = fileContent.split('\n\n');
        titlecontroller.text = lines[1];
        descriptionController.text = lines[3];
        tagController.text = lines[5];
        SnackBarUtils.showSnackBar(context, Icons.upload_file, 'File Uploaded');
      } else {
        SnackBarUtils.showSnackBar(
            context, Icons.error_rounded, 'File not selected');
      }
    } catch (e) {
      SnackBarUtils.showSnackBar(
          context, Icons.error_rounded, 'No file selected');
    }
  }

  void newFile(context) {
    _selectedField = null;
    titlecontroller.clear();
    descriptionController.clear();
    tagController.clear();
    SnackBarUtils.showSnackBar(context, Icons.file_upload, 'New File save');
  }

  void newDirectory(context) async{
    try{
      String? directory = await FilePicker.platform.getDirectoryPath();
      _selectedDirectory = directory!;
      _selectedField = null;
      SnackBarUtils.showSnackBar(context, Icons.folder, 'New folder selected');
    }
    catch(e){
      SnackBarUtils.showSnackBar(context, Icons.euro_rounded, 'No folder seleted');
    }
  }

  static String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedData = formatter.format(now);
    return formattedData;
  }
}
