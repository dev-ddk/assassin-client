// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';

class ReportBugPage extends StatelessWidget {
  const ReportBugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'REPORT BUG',
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ReportBugForm(),
      ),
    );
  }
}

class ReportBugForm extends StatelessWidget {
  ReportBugForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textTheme =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: assassinWhite);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTopText(textTheme),
          const SizedBox(height: 20),
          _buildFormField(),
          const SizedBox(height: 20),
          _buildBottomText(textTheme),
          const SizedBox(height: 50),
          AssassinConfirmButton(text: 'SEND REPORT', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildFormField() {
    return AssassinFormField(
      hintText: 'Write report here',
      maxLines: 10,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return 'Report cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildBottomText(TextStyle textTheme) {
    return Text(
      'The devs will only see the content of \nthe report and the ID of the lobby',
      textAlign: TextAlign.center,
      style: textTheme,
    );
  }

  Widget _buildTopText(TextStyle textTheme) {
    return Text(
      'Use this form to send a report to the developers.',
      textAlign: TextAlign.center,
      style: textTheme,
    );
  }
}
