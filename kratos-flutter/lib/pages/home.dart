import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../blocs/auth/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // get current session information when the page opens
    context.read<AuthBloc>().add(GetCurrentSessionInformation());
  }

  @override
  Widget build(BuildContext context) {
    // get loading state
    final isLoading =
        context.select((AuthBloc authBloc) => authBloc.state.isLoading);

    return Scaffold(
        appBar: AppBar(
          actions: [
            // if auth is loading, show progress indicator, otherwise a logout icon
            isLoading
                ? const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () => context.read<AuthBloc>()..add(LogOut()),
                    icon: const Icon(Icons.logout),
                  ),
          ],
        ),
        body: BlocBuilder(
          bloc: context.read<AuthBloc>(),
          builder: (BuildContext context, AuthState state) {
            if (state.session != null) {
              return _buildSessionInformation(context, state.session!);
            } else {
              return _buildSessionNotFetched(context, state);
            }
          },
        ));
  }

  _buildSessionInformation(BuildContext context, Session session) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Text(
              "Welcome back,\n${session.identity.id}!",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                  "Hello, nice to have you! you signed up with this data:"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                padding: const EdgeInsets.all(35),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[400]),
                child: Text(session.identity.traits.toString()),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child:
                  Text("You are signed in using an ORY Kratos Session Token:"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                padding: const EdgeInsets.all(35),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[400]),
                child: Text(session.id),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                    "This app mackes REST requests to ORY Kratos' Public API to validate and decode the ORY Kratos Session payload:")),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                padding: const EdgeInsets.all(35),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[400]),
                child: Text(session.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSessionNotFetched(BuildContext context, AuthState state) {
    if (state.errorMessage != null) {
      return Center(
          child: Text(
        state.errorMessage!,
        style: const TextStyle(color: Colors.red),
      ));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
