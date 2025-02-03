import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:bidhub/presentations/bloc/users/users_state.dart';
import 'package:bidhub/presentations/widgets/dialog/credit_card_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AvatarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AvatarAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

    return AppBar(
      title: const Text('BidHub'),
      leading: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                backgroundImage: state.user.avatar.isNotEmpty
                    ? NetworkImage('$baseUrl${state.user.avatar}')
                    : null,
                child: state.user.avatar.isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            );
          } else {
            return const CircleAvatar(
              child: Icon(Icons.person),
            );
          }
        },
      ),
      actions: [
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded && state.user.role == 2) {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.account_balance_wallet),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreditCardDialog(),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('Saldo: ${state.user.balance}€'),
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
