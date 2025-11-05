import 'package:client/presentation/bdui/engine/engine.dart';
import 'package:client/presentation/pages/home/bloc/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/home_bloc.dart';
import 'bloc/home_events.dart';

class BDUIHomeScreen extends StatelessWidget {
  const BDUIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<HomeBloc>()..add(LoadHomeEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Challenges - BDUI'),
          backgroundColor: Colors.blue,
          actions: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: state is HomeLoadingState
                      ? null
                      : () => context.read<HomeBloc>().add(LoadHomeEvent()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка: ${state.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<HomeBloc>().add(LoadHomeEvent()),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoadedState) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BDUIEngine.renderFromJson(
          json: state.homeData,
          context: context,
          onDataUpdated: () => context.read<HomeBloc>().add(LoadHomeEvent()),
        ),
      );
    }

    return const SizedBox();
  }
}
