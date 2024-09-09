// ignore_for_file: sort_child_properties_last, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:quickalert/quickalert.dart';

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'cube_to_die_widget.dart';
import 'custom_search_delegate.dart';
import 'dice_config.dart';
import 'dice_faces_customization.dart';


class DiceGameBoard extends StatefulWidget {
  const DiceGameBoard({super.key});

  @override
  _DiceGameBoardState createState() => _DiceGameBoardState();
}

class _DiceGameBoardState extends State<DiceGameBoard> {
  List<DiceConfig> dices = [];
  Color currentCubeColor = Colors.white;
  Color currentOutlineColor = Colors.black;
  Color currentDotColor = Colors.black;
  double currentSize = 100;
  late AudioPlayer _audioPlayer;
  String winningCondition = 'All dice must roll 6';


  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _playAudio() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('dice-rolling.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: [
        Expanded(
          child: GestureDetector(
            child: Container(
              color: Colors.lightBlue[50],
              child: dices.isEmpty
                  ? _buildEmptyState()
                  : Stack(
                      children: dices.map((dice) => _buildDraggableDice(dice)).toList(),
                    ),
            ),
          ),
        ),
        _buildControlPanel(),
      ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: _playGame,
        child: const Icon(Icons.casino),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Life Dice',
            style: GoogleFonts.delaGothicOne(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          Image.asset(
            'assets/cbh4.png',
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableDice(DiceConfig dice) {
    return Positioned(
      left: dice.position.dx,
      top: dice.position.dy,
      child: GestureDetector(
        onDoubleTap: () => setState(() => dices.remove(dice)),
        onLongPress: () => _showDiceContextMenu(dice),
        child: Draggable(
          child: CubeToDieWidget(
            size: dice.size,
            cubeColor: dice.cubeColor,
            outlineColor: dice.outlineColor,
            dotColor: dice.dotColor,
            faceValue: dice.faceValue,
            isRolling: dice.isRolling,
            isCustomizing: dice.isCustomizing,
            customFace: dice.customFaces[dice.faceValue - 1],
          ),
          feedback: CubeToDieWidget(
            size: dice.size,
            cubeColor: dice.cubeColor,
            outlineColor: dice.outlineColor,
            dotColor: dice.dotColor,
            faceValue: dice.faceValue,
            isRolling: dice.isRolling,
            isCustomizing: dice.isCustomizing,
            customFace: dice.customFaces[dice.faceValue - 1],
          ),
          childWhenDragging: Container(),
          onDragEnd: (details) => _updateDicePosition(dice, details.offset),
        ),
      ),
    );
  }

  void _showDiceContextMenu(DiceConfig dice) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.history_edu),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              _navigateToDiceFaceCustomization(dice);
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_copy),
            title: const Text('Duplicate'),
            onTap: () {
              Navigator.pop(context);
              _duplicateDice(dice);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              setState(() {
                dices.remove(dice);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToDiceFaceCustomization(DiceConfig dice) async {
    final customFaces = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => DiceFaceCustomizationScreen(diceConfig: dice),
      ),
    );

    if (customFaces != null) {
      setState(() {
        dice.customFaces = customFaces;
      });
    }
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ggg.png")
                  )
                ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildColorPicker('Plain', currentCubeColor, (color) => setState(() => currentCubeColor = color)),
              _buildColorPicker('Border', currentOutlineColor, (color) => setState(() => currentOutlineColor = color)),
              _buildColorPicker('Dot', currentDotColor, (color) => setState(() => currentDotColor = color)),
            ],
          ),
          Slider(
            value: currentSize,
            min: 50,
            max: 150,
            divisions: 10,
            label: currentSize.round().toString(),
            onChanged: (value) => setState(() => currentSize = value),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigoAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            onPressed: () => _addDice(null),
            child: const Text(
              'Add Dice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _buildWinningConditionSelector(),
        ],
      ),
    );
  }

  Widget _buildColorPicker(String label, Color currentColor, Function(Color) onColorChanged) {
    return Column(
      children: [
        Text(label),
        GestureDetector(
          onTap: () => _showColorPicker(currentColor, onColorChanged),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: currentColor,
              shape: BoxShape.circle,
              border: Border.all(color: currentColor == Colors.white ? Colors.black : Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(Color currentColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Pick a color',
          style: TextStyle(
            fontSize: 12
          ),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
            labelTypes: const [],
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildWinningConditionSelector() {
    return ElevatedButton(
      onPressed: () async {
        final selectedCondition = await showSearch<String?>(
          context: context,
          delegate: CustomSearchDelegate(),
        );

        if (selectedCondition != null) {
          setState(() {
            winningCondition = selectedCondition;
          });
        }
      },
      child: Text(
        'Winning Condition: $winningCondition',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _addDice(Offset? position) {
    setState(() {
      dices.add(DiceConfig(
        position: position ?? _getRandomPosition(),
        size: currentSize,
        cubeColor: currentCubeColor,
        outlineColor: currentOutlineColor,
        dotColor: currentDotColor,
      ));
    });
  }

  Offset _getRandomPosition() {
    final random = math.Random();
    return Offset(
      random.nextDouble() * (MediaQuery.of(context).size.width - currentSize),
      random.nextDouble() * (MediaQuery.of(context).size.height - currentSize - 200),
    );
  }

  void _updateDicePosition(DiceConfig dice, Offset newPosition) {
    setState(() {
      dice.position = newPosition;
    });
  }

  void _duplicateDice(DiceConfig originalDice){
    final clonedDice = DiceConfig(
      position: _getOffsetPositionForClone(originalDice.position),
      size: originalDice.size,
      cubeColor: originalDice.cubeColor,
      outlineColor: originalDice.outlineColor,
      dotColor: originalDice.dotColor,
      faceValue: originalDice.faceValue,
      isCustomizing: originalDice.isCustomizing,
      customFaces: List<String>.from(originalDice.customFaces),
    );

    setState(() {
      dices.add(clonedDice);
    });
  }

  Offset _getOffsetPositionForClone(Offset originalPosition) {
    // Offset the clone slightly to make it visible
    const offset = 20.0;
    return Offset(originalPosition.dx + offset, originalPosition.dy + offset);
  }

  void _playGame() {
    if (dices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add some dice to play!')));
      return;
    }

    setState(() {
      for (var dice in dices) {
        dice.isRolling = true;
      }
    });

    _playAudio();

    Future.delayed(const Duration(seconds: 3), () {
      List<int> results = dices.map((dice) => _rollDice()).toList();
      bool hasWon = _evaluateWinningCondition(results);

      setState(() {
        for (int i = 0; i < dices.length; i++) {
          dices[i].isRolling = false;
          dices[i].faceValue = results[i];
        }
      });

      QuickAlert.show(
        context: context,
        type: hasWon ? QuickAlertType.info : QuickAlertType.error,
        title: hasWon ? 'You Win!' : 'You Lose',
        text: hasWon ? 'Congratulations!' : 'Better luck next time!',
        confirmBtnText: 'Retry',
        confirmBtnColor: Colors.indigoAccent,
      );
    });
  }

  int _rollDice() {
    return math.Random().nextInt(6) + 1;
  }

  bool _evaluateWinningCondition(List<int> results) {
    switch (winningCondition) {
      case 'All dice must roll 6':
        return results.every((result) => result == 6);
      case 'Sum of dice must be 18':
        return results.reduce((a, b) => a + b) == 18;
      case 'Any dice must roll 1':
        return results.contains(1);
      default:
        return false;
    }
  }
}