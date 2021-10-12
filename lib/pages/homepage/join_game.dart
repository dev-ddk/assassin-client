// Flutter imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/user_view_controller.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:assassin_client/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinGamePage extends ConsumerWidget {
  const JoinGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final width = MediaQuery.of(context).size.width - 100;
    final user = watch(userState);

    final style =
        Theme.of(context).textTheme.headline3!.copyWith(color: assassinBlue);

    return user.fold(
      () => _buildLoading(),
      (error, [cache]) => _buildError(error),
      (user) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome back \n${user.username}',
              style: style,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildJoinLobbyButton(context, width),
                  _buildCreateLobbyButton(context, width),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Failure error) {
    return Text(error.message);
  }

  Widget _buildJoinLobbyButton(BuildContext context, double width) {
    return SizedBox(
      width: width / 2,
      height: width / 2,
      child: AssassinConfirmButton(
        heroTag: 'JOIN LOBBY',
        text: 'JOIN\nLOBBY',
        onPressed: () => Navigator.pushNamed(context, '/join-lobby'),
      ),
    );
  }

  Widget _buildCreateLobbyButton(BuildContext context, double width) {
    return SizedBox(
      width: width / 2,
      height: width / 2,
      child: AssassinConfirmButton(
        text: 'CREATE\nLOBBY',
        heroTag: 'CREATE LOBBY',
        onPressed: () => Navigator.pushNamed(context, '/create-lobby'),
      ),
    );
  }
}
