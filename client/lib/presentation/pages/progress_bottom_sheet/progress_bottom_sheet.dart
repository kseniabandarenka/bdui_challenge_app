import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_bloc.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import 'package:client/presentation/bdui/engine/engine.dart';

class ProgressBottomSheet extends StatelessWidget {
  final BDUIElementModel data;
  final String challengeId;
  final VoidCallback? onDataUpdated;

  const ProgressBottomSheet({
    Key? key,
    required this.data,
    required this.challengeId,
    this.onDataUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ProgressBottomSheetBloc>(),
      child: _ProgressBottomSheetContent(
        data: data,
        challengeId: challengeId,
        onDataUpdated: onDataUpdated,
      ),
    );
  }
}

class _ProgressBottomSheetContent extends StatelessWidget {
  final BDUIElementModel data;
  final String challengeId;
  final VoidCallback? onDataUpdated;

  const _ProgressBottomSheetContent({
    required this.data,
    required this.challengeId,
    required this.onDataUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProgressBottomSheetBloc, ProgressBottomSheetState>(
      listener: (context, state) {
        if (state is ProgressBottomSheetSuccess) {
          Navigator.of(context).pop();
          onDataUpdated?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Прогресс сохранен!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is ProgressBottomSheetError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.value != null) ...[
                Text(
                  data.value!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
              ],
              BDUIEngine.renderBDUIModel(
                model: data,
                context: context,
                onDataUpdated: onDataUpdated,
              ),
              BlocBuilder<ProgressBottomSheetBloc, ProgressBottomSheetState>(
                builder: (context, state) {
                  if (state is ProgressBottomSheetLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}