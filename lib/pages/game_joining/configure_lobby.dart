// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:either_dart/src/future_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/form_fields.dart';
import 'package:assassin_client/widgets/template_page.dart';
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

  Widget _buildConfirmButton(BuildContext context, maxPlayers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: AssassinConfirmButton(
        text: 'CREATE LOBBY',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final lobbyname = lobbynameController.text;
            final lobbyRepo = context.read(lobbyProvider);

            await lobbyRepo.createAndJoinLobby(lobbyname).fold(
                  (failure) => _handleError(context, failure),
                  (_) => Navigator.pushNamed(context, '/homepage/'),
                );
          }
        },
      ),
    );
  }

  void _handleError(BuildContext context, Failure failure) {
    if (failure is AuthFailure) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (failure is RequestFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'We had problem to process your request (${failure.response.statusCode})! Please try again'),
        ),
      );
    } else if (failure is DioNetworkFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network Error!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error!'),
        ),
      );
    }
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
