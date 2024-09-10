// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'constants.dart';
import 'cube_to_die_widget.dart';
import 'dice_config.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class DiceFaceCustomizationScreen extends StatefulWidget {
  final DiceConfig diceConfig;

  const DiceFaceCustomizationScreen({super.key, required this.diceConfig});

  @override
  _DiceFaceCustomizationScreenState createState() => _DiceFaceCustomizationScreenState();
}

class _DiceFaceCustomizationScreenState extends State<DiceFaceCustomizationScreen> {
  late List<String> customFaces;

  bool _showCustomizationInput = false;
  int _elementIndex = 0;

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _emojiShowing = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the current custom faces instead of new numbers
    customFaces = List.from(widget.diceConfig.customFaces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Faces customization',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
          icon: const Icon(Icons.arrow_back_ios)
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showCustomizationConfirmation();
            },
            icon: const Icon(Icons.beenhere)
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCustomizationInput = true;
                      _elementIndex = index;
                    });
                  },
                  child: Card(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _elementIndex == index ?  AppConstants.white : AppConstants.transparent,
                        width: _elementIndex == index ? 2 : 1
                      )
                    ),
                    child: Center(
                      child: CubeToDieWidget(
                        size: 100,
                        cubeColor: widget.diceConfig.cubeColor,
                        outlineColor: widget.diceConfig.outlineColor,
                        dotColor: widget.diceConfig.dotColor,
                        faceValue: index + 1,
                        isRolling: false,
                        isCustomizing: widget.diceConfig.isCustomizing,
                        customFace: customFaces[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if(_showCustomizationInput == true)
          _showFaceCustomizationInputContent(_elementIndex),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget _showFaceCustomizationInputContent(int faceIndex) {
    return Column(
            children: [
              Row(
                children: [
                  IconButton(
                          onPressed: () {
                            setState(() {
                              _emojiShowing = !_emojiShowing;
                            });
                          },
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: AppConstants.white,
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        scrollController: _scrollController,
                        decoration: const InputDecoration(
                          hintText: "Enter emoji, symbol, or text",
                          border: OutlineInputBorder()
                        )
                      ),
                    )
                  ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(AppConstants.white)
                    ),
                  onPressed: () {
                    setState(() {
                          customFaces[faceIndex] = _controller.text;
                          widget.diceConfig.isCustomizing = true;
                          _controller.clear();
                        });
                  },
                  icon: Icon(Icons.check, color: AppConstants.black,),
                              ),
                ],
              ),
              Offstage(
                offstage: !_emojiShowing,
                child: EmojiPicker(
                  textEditingController: _controller,
                  scrollController: _scrollController,
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
                    ),
                    swapCategoryAndBottomBar: false,
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: AppConstants.primarycolor,
                      iconColor: AppConstants.black,
                      iconColorSelected: AppConstants.secondarycolor,
                      indicatorColor: AppConstants.secondarycolor
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: AppConstants.primarycolor,
                      buttonColor: AppConstants.primarycolor,
                      buttonIconColor: AppConstants.black
                    ),
                    searchViewConfig: SearchViewConfig(
                      backgroundColor: AppConstants.primarycolor,
                      buttonIconColor: AppConstants.black,
                      inputTextStyle: TextStyle(
                        color: AppConstants.black
                      ),
                      hintTextStyle: TextStyle(
                        color: AppConstants.grey
                      )
                    ),
                  ),
                ),
              )
            ],
          );
  }

  void _showCustomizationConfirmation() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Customization"),
      content: const Text("Are you sure you want to save these custom faces?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
         TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pop(context, customFaces);
          },
          child: const Text("Confirm"),
        ),
      ],
    ),
  );
}

}