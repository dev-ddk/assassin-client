// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/form_fields.dart';
import 'package:assassin_client/widgets/template_page.dart';

class ReportBugRoute extends StatelessWidget {
  const ReportBugRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'REPORT BUG',
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              'Use this form to send a report to the developers.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: assassinWhite),
            ),
            SizedBox(height: 20),
            AssassinFormField(
              hintText: 'Write report here',
              maxLines: 10,
            ),
            SizedBox(height: 20),
            Text(
              'The devs will only see the content of \nthe report and the ID of the lobby',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: assassinWhite),
            ),
            SizedBox(height: 50),
            AssassinConfirmButton(text: 'SEND REPORT', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
