// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/form_fields.dart';
import 'package:assassin_client/widgets/template_page.dart';
import '../../colors.dart';

class JoinLobbyRoute extends StatelessWidget {
  JoinLobbyRoute({Key? key}) : super(key: key);

  final lobbynameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.headline6!.copyWith(color: assassinWhite);
    return TemplatePage(
      title: 'JOIN LOBBY',
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Insert the code\nof the lobby',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            _buildLobbyNameField(),
            const SizedBox(height: 60),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: AssassinConfirmButton(
        text: 'JOIN GAME',
        onPressed: () {},
      ),
    );
  }

  Widget _buildLobbyNameField() {
    return AssassinFormField(
      icon: FontAwesomeIcons.gamepad,
      controller: lobbynameController,
      hintText: 'Casa Surace',
    );
  }
}
