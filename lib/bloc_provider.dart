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
        throw Exception('BlocProvider<$B> не найден в дереве виджетов');
      }

      return provider.bloc;
    } else {
      final provider = context
          .getInheritedWidgetOfExactType<_InheritedBlocProvider<B>>();

      if (provider == null) {
        throw Exception('BlocProvider<$B> не найден в дереве виджетов');
      }

      return provider.bloc;
    }
  }

  @override
  State<StatefulWidget> createState() => _BlocProviderState();
}

class _BlocProviderState extends State {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
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
