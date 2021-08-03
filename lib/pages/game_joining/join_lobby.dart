// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:either_dart/src/future_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/form_fields.dart';
import 'package:assassin_client/widgets/template_page.dart';
import '../../colors.dart';

class JoinLobbyRoute extends StatelessWidget {
  JoinLobbyRoute({Key? key}) : super(key: key);

  final lobbynameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.headline6!.copyWith(color: assassinWhite);
    return TemplatePage(
      title: 'JOIN LOBBY',
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Insert the code\nof the lobby',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              _buildLobbyNameField(context),
              const SizedBox(height: 60),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: AssassinConfirmButton(
        text: 'JOIN GAME',
        onPressed: () async {
          final formState = _formKey.currentState!;
          final lobbyCode = lobbynameController.text;
          print('premuto');
          if (formState.validate()) {
            await context.read(lobbyProvider).joinLobby(lobbyCode).fold(
                (failure) => _handleError(context, failure),
                (_) => Navigator.pushNamed(
                    context, '/homepage/joingame/game-lobby'));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('LobbyCode null!'),
              ),
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
              'We had problem to process your request (${failure.statusCode})! Please try again'),
        ),
      );
    } else if (failure is LobbyNotExistsFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This lobby does not exists'),
        ),
      );
    } else if (failure is NetworkFailure) {
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

  Widget _buildLobbyNameField(BuildContext context) {
    // alphanumeric characters (only uppercase)
    final regex = RegExp(r'[0-9]+');

    return AssassinFormField(
      icon: FontAwesomeIcons.gamepad,
      controller: lobbynameController,
      hintText: 'Casa Surace',
      validator: (value) {
        if (!regex.hasMatch(value ?? '')) {
          return 'Invalid lobby code';
        }
        return null;
      },
    );
  }
}
