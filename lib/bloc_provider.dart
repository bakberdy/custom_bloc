import 'package:custom_bloc/bloc.dart';
import 'package:flutter/material.dart';

class BlocProvider<B extends Bloc> extends StatefulWidget {
  final Widget child;
  final B Function() create;
  final bool lazy;

  const BlocProvider({
    super.key,
    required this.child,
    required this.create,
    this.lazy = true,
  }) : super();

  static B of<B extends Bloc>(BuildContext context, {bool listen = true}) {
    if (listen) {
      final provider = context
          .dependOnInheritedWidgetOfExactType<_InheritedBlocProvider<B>>();

      if (provider == null) {
        throw Exception('BlocProvider<$B> not found on widget tree');
      }

      return provider.bloc;
    } else {
      final provider = context
          .getInheritedWidgetOfExactType<_InheritedBlocProvider<B>>();

      if (provider == null) {
        throw Exception('BlocProvider<$B> not found on widget tree');
      }

      return provider.bloc;
    }
  }

  @override
  State<StatefulWidget> createState() => _BlocProviderState<B>();
}

class _BlocProviderState<B extends Bloc> extends State<BlocProvider> {
  late B _bloc;
  bool _isInitialized = false;

  @override
  void initState() {
    if (!widget.lazy) {
      _createBloc();
    }
    super.initState();
  }

  void _createBloc() {
    if (!_isInitialized) {
      _bloc = widget.create() as B;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lazy && !_isInitialized) {
      _createBloc();
    }
    
    return _InheritedBlocProvider<B>(
      bloc: _bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _bloc.dispose();
    }
    super.dispose();
  }
}

class _InheritedBlocProvider<B extends Bloc> extends InheritedWidget {
  final B bloc;

  const _InheritedBlocProvider({required this.bloc, required super.child});

  @override
  bool updateShouldNotify(_InheritedBlocProvider<B> oldWidget) {
    return bloc != oldWidget.bloc;
  }
}
