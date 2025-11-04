import 'dart:async';
import 'dart:developer';

abstract class Bloc<Event, State> {
  //streams to event and state
  final StreamController<Event> _eventController = StreamController<Event>();
  final StreamController<State> _stateController =
      StreamController<State>.broadcast();

  //current state
  State _state;

  //getters
  State get state => _state;
  Stream<State> get stream => _stateController.stream;

  //event memory
  final Map<Type, Function> _eventHandlers = {};

  //constructor
  Bloc(State initialState) : _state = initialState {
    _eventController.stream.listen(_handleEvent);
  }

  Future<void> _handleEvent(Event event) async {
    final handler = _eventHandlers[event.runtimeType];

    if (handler != null) {
      final emitter = _Emitter(this);
      await handler(event, emitter);
    } else {
      log('handler not found for type ${event.runtimeType}');
    }
  }

  void on<E extends Event>(
    Future<void> Function(E event, Emitter<State> emit) handler,
  ) {
    _eventHandlers[E] = handler;
  }

  void add(Event event) {
    _eventController.add(event);
  }

  void _emit(State state) {
    _state = state;
    _stateController.add(state);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

abstract class Emitter<State> {
  void call(State state);
}

class _Emitter<State> implements Emitter<State> {
  final Bloc<dynamic, State> _bloc;

  _Emitter(this._bloc);

  @override
  void call(State state) {
    return _bloc._emit(state);
  }
}
