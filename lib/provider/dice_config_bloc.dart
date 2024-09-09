import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dice_config_event.dart';
import 'dice_config_repository.dart';
import 'dice_config_state.dart';

class DiceConfigBloc extends Bloc<DiceConfigEvent, DiceConfigState> {
  final DiceConfigRepository diceConfigRepository;

  DiceConfigBloc({required this.diceConfigRepository}): super(DiceConfigLoading()) {
    on<LoadDiceConfigs>(_mapLoadDiceConfigsToState);
    on<SaveDiceConfig>(_mapSaveDiceConfigToState);
  }

  Future<void> _mapLoadDiceConfigsToState(LoadDiceConfigs event, Emitter<DiceConfigState> emit) async {
    try {
      final diceConfigs = diceConfigRepository.getDiceConfigs();
      emit(DiceConfigLoaded(diceConfigs: diceConfigs));
    } catch (_) {
      emit(DiceConfigError());
    }
  }

  Future<void> _mapSaveDiceConfigToState(SaveDiceConfig event, Emitter<DiceConfigState> emit) async {
    try {
      diceConfigRepository.saveDiceConfig(event.diceConfig);
      emit(DiceConfigLoaded(diceConfigs: diceConfigRepository.getDiceConfigs()));
    } catch (_) {
      emit(DiceConfigError());
    }
  }
}