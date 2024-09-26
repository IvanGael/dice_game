import '../models/dice_config.dart';

class DiceConfigRepository {
  final Map<String, DiceConfig> _diceConfigs = {};

  List<DiceConfig> getDiceConfigs() {
    return _diceConfigs.values.toList();
  }

  void saveDiceConfig(DiceConfig diceConfig) {
    _diceConfigs[diceConfig.id] = diceConfig;
  }
}