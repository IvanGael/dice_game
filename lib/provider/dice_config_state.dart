import 'package:equatable/equatable.dart';

import '../models/dice_config.dart';


abstract class DiceConfigState extends Equatable {
  const DiceConfigState();

  @override
  List<Object?> get props => [];
}

class DiceConfigLoading extends DiceConfigState {}

class DiceConfigLoaded extends DiceConfigState {
  final List<DiceConfig> diceConfigs;

  const DiceConfigLoaded({required this.diceConfigs});

  @override
  List<Object?> get props => [diceConfigs];
}

class DiceConfigError extends DiceConfigState {}
