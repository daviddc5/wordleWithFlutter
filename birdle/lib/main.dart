import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MainApp());
}

// Main app widget which sets up the app and shows the game page. The game page will show the guesses, and each guess will show the tiles.
class MainApp extends StatelessWidget {
  // This specifically is a const constructor, which means that the widget can be created at compile time, and won't be rebuilt unnecesarily. This is a good practice for stateless widgets, as it can improve performance.
  const MainApp({super.key});

  @override
  // build is called whenever widget needs to be rebuilt, which can happen for a variety of reasons. In this case, since MainApp is a stateless widget, it will only be built once, when the app starts. The build method returns a widget tree, which is what will be rendered on the screen.
  Widget build(BuildContext context) {
    // Material app is a widget that provides a lot of the basic functionality for a Flutter app, such as theming, navigation, and more. It also sets up the app to use Material Design, which is a design language developed by Google. The home property is the widget that will be shown when the app starts, and in this case it's a Scaffold, which is a basic layout widget that provides an app bar and a body.
    return MaterialApp(
      //Scaffold is a widget that provides a basic layout for the app, with an app bar and a body. The app bar is a horizontal bar at the top of the screen that typically contains the title of the app and some actions. The body is the main content of the app, and in this case it's a GamePage, which will show the guesses and tiles.
      home: Scaffold(
        //App bar is a widget that provides a horizontal bar at the top of the screen, which typically contains the title of the app and some actions. In this case, we're just showing the title of the app, which is 'Birdle'.
        appBar: AppBar(
          // title is the widget that will be shown in the app bar, and in this case it's a Text widget that shows 'Birdle'. The Align widget is used to align the title to the left, which is a common design choice for app bars.
          title: Align(alignment: Alignment.centerLeft, child: Text('Birdle')),
        ),
        // The body of the scaffold is the main content of the app, and in this case it's a GamePage, which will show the guesses and tiles. The Center widget is used to center the GamePage in the middle of the screen.
        body: Center(child: GamePage()),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in guess)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: Tile(letter.char, letter.type),
                  ),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                _game.guess(guess);
              });
            },
          ),
        ],
      ),
    );
  }
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    onSubmitGuess(_textEditingController.text.trim());
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              onSubmitted: (_) => _onSubmit(),
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit,
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    // replace container with widget
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
