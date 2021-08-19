// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';
import '../../colors.dart';

class ConfigureLobbyRoute extends ConsumerWidget {
  ConfigureLobbyRoute({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final lobbynameController = TextEditingController();

  final maxPlayersProvider = StateProvider.autoDispose<int>((_) => 0);

  final playerNumbers = [for (int i = 4; i <= 15; i++) i];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final maxPlayers = watch(maxPlayersProvider).state;
    final textStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: assassinWhite);

    final dropdownButton = AssassinDropDownForm(
      selectedProvider: maxPlayersProvider,
      items: [
        for (int i in playerNumbers)
          Text(
            i.toString(),
            style: textStyle.copyWith(color: assassinDarkBlue),
          ),
      ],
    );

    return TemplatePage(
      title: 'CONFIGURE LOBBY',
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lobby Name', style: textStyle),
              const SizedBox(height: 4),
              _buildLobbyNameField(),
              const SizedBox(height: 20),
              Text('Max Players', style: textStyle),
              const SizedBox(height: 4),
              dropdownButton,
              const SizedBox(height: 60),
              _buildConfirmButton(context, maxPlayers),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(context, maxPlayers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: AssassinConfirmButton(
        text: 'CREATE LOBBY',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final lobbyname = lobbynameController.text;

            print(playerNumbers[maxPlayers]);
            print(lobbyname);

            Navigator.pushNamed(context, '/homepage/gamelobby');

            //TODO: api call to create lobby
          }
        },
      ),
    );
  }

  Widget _buildLobbyNameField() {
    return AssassinFormField(
      icon: FontAwesomeIcons.gamepad,
      controller: lobbynameController,
      hintText: 'Casa Surace',
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return 'Lobby must have a name';
        }
        return null;
      },
    );
  }
}
