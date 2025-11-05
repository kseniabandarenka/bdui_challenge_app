import 'package:client/presentation/bdui/engine/engine.dart';
import 'package:client/presentation/pages/challenge_details/bloc/challenge_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/challenge_bloc.dart';
import 'bloc/challenge_events.dart';

class ChallengeDetailScreen extends StatelessWidget {
  final String challengeId;

  const ChallengeDetailScreen({Key? key, required this.challengeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<ChallengeBloc>()..add(LoadChallengeEvent(challengeId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Challenge Details'),
          actions: [
            BlocBuilder<ChallengeBloc, ChallengeState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: state is ChallengeLoadingState
                      ? null
                      : () => context
                          .read<ChallengeBloc>()
                          .add(LoadChallengeEvent(challengeId)),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChallengeState state) {
    if (state is ChallengeLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChallengeErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<ChallengeBloc>()
                  .add(LoadChallengeEvent(challengeId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is ChallengeLoadedState) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BDUIEngine.renderFromJson(
          context: context,
          onDataUpdated: () => context
              .read<ChallengeBloc>()
              .add(LoadChallengeEvent(challengeId)),
          json: state.challengeData,
        ),
      );
    }

    return const SizedBox();
  }
}
