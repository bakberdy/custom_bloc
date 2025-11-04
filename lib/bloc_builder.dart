import 'dart:async';

import 'package:custom_bloc/bloc.dart';
import 'package:custom_bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

class BlocBuilder<B extends Bloc, S> extends StatefulWidget {
  const BlocBuilder({super.key, this.bloc, required this.builder});
  final B? bloc;
  final Widget Function(BuildContext context, S state) builder;

  @override
  State<BlocBuilder<B, S>> createState() => _BlocBuilderState();
}

class _BlocBuilderState<B extends Bloc, S> extends State<BlocBuilder<B, S>> {
  late B _bloc;
  late S _state;
  StreamSubscription<S>? _subscription;

  @override
  void initState() {
    _bloc = widget.bloc ?? context.read<B>();
    _state = _bloc.state;
    _subscribe();
    super.initState();
  }

  void _subscribe() {
    _subscription =
        _bloc.stream.listen((newState) {
              setState(() {
                _state = newState;
              });
            })
            as StreamSubscription<S>?;
  }

  @override
  void didUpdateWidget(covariant BlocBuilder<B, S> oldWidget) {
    final currentBloc = widget.bloc ?? context.read<B>();
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    if (currentBloc != oldBloc) {
      _subscription?.cancel();
      _bloc = currentBloc;
      _state = _bloc.state;
      _subscribe();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }
}
