// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/regex.dart';
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';
import '../../colors.dart';

class JoinLobbyRoute extends ConsumerWidget {
  const JoinLobbyRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return TemplatePage(
      title: 'JOIN LOBBY',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: LobbyCodeForm()),
      ),
    );
  }
}

class LobbyCodeForm extends StatefulWidget {
  const LobbyCodeForm({
    Key? key,
  }) : super(key: key);

  @override
  _LobbyCodeFormState createState() => _LobbyCodeFormState();
}

class _LobbyCodeFormState extends State<LobbyCodeForm> {
  final _formKey = GlobalKey<FormState>();
  final _lobbyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: assassinWhite);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text('LobbyCode', textAlign: TextAlign.center, style: style),
          const SizedBox(height: 10),
          _buildLobbyNameField(),
          const SizedBox(height: 40),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AssassinConfirmButton(
        text: 'JOIN GAME',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            //TODO: finish
            final result = await context
                .read(gameViewCntrl)
                .joinGame(_lobbyNameController.text);

            result.fold(
              (error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to join lobby')),
              ),
              (newLobby) =>
                  Navigator.pushNamed(context, '/homepage/join-game/lobby'),
            );
          }
        },
      ),
    );
  }

  Widget _buildLobbyNameField() {
    return AssassinFormField(
      icon: FontAwesomeIcons.gamepad,
      controller: _lobbyNameController,
      hintText: 'Casa Surace',
      validator: (value) {
        //TODO: fix
        if (lobbyRegex.hasMatch(value ?? '')) {
          return 'Invalid lobby code';
        }
        return null;
      },
    );
  }
}
