import 'package:equatable/equatable.dart';

import '../models/dice_config.dart';

abstract class DiceConfigEvent extends Equatable {
  const DiceConfigEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiceConfigs extends DiceConfigEvent {}

class SaveDiceConfig extends DiceConfigEvent {
  final DiceConfig diceConfig;

  const SaveDiceConfig({required this.diceConfig});

  @override
  List<Object?> get props => [diceConfig];
}