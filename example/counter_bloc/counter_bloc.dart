import 'package:custom_bloc/bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(number: 0)) {
    on<IncrementEvent>((IncrementEvent event, emit) async {
      emit(CounterState(number: state.number + 1));
    });

    on<DecrementEvent>((DecrementEvent event, emit) async {
      emit(CounterState(number: state.number - 1));
    });
  }
}
