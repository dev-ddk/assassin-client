// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:assassin_client/colors.dart';

class EditProfileRoute extends StatelessWidget {
  const EditProfileRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: assassinDarkestBlue,
      appBar: AppBar(
        backgroundColor: assassinDarkBlue,
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png', 'jpeg'],
            );

            if (result != null) {
              final file = result.files.first;
              print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);
              print(file.path);
            } else {
              // User canceled the picker
            }
          },
          child: Text('Select Photo'),
        ),
      ),
    );
  }
}
