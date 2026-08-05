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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F5C4B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1F5C4B),
          foregroundColor: Colors.white,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Birdle',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F7F3), Color(0xFFE7EFE9)],
            ),
          ),
          child: const Center(child: GamePage()),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final Game _game = Game();
  String? _message;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool get _isGameOver => _game.didWin || _game.didLose;

  int get _guessesLeft => _game.guessesRemaining;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -10.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 10.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 10.0, end: -8.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -8.0, end: 8.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 8.0, end: -4.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -4.0, end: 4.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 4.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerInvalidGuessShake() {
    _shakeController.forward(from: 0.0);
  }

  void _restartGame() {
    setState(() {
      _game.resetGame();
      _message = null;
    });
  }

  void _handleSubmitGuess(String guess) {
    setState(() {
      if (_isGameOver) {
        _message = 'Game over. Tap restart to play again.';
        return;
      }

      if (!_game.isLegalGuess(guess)) {
        _message = 'That is not a legal 5-letter guess.';
        _triggerInvalidGuessShake();
        return;
      }

      _game.guess(guess);

      if (_game.didWin) {
        _message = 'You won!';
      } else if (_game.didLose) {
        _message =
            'You lost. The word was ${_game.hiddenWord.toString().toUpperCase()}.';
      } else {
        _message = null;
      }
    });
  }

  Widget _buildGuessRow(Word guess) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var letter in guess)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Tile(letter.char, letter.type),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Guess the word in 5 tries',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F5C4B),
                    ),
              ),
              const SizedBox(height: 6.0),
              Text(
                'Use the clues to narrow it down.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 18.0),
              for (var guess in _game.guesses) _buildGuessRow(guess),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    avatar: const Icon(Icons.timer_outlined, size: 18),
                    label: Text('$_guessesLeft guesses left'),
                    backgroundColor: const Color(0xFFEAF2EC),
                    side: BorderSide.none,
                  ),
                  const SizedBox(width: 8.0),
                  if (_isGameOver)
                    Chip(
                      avatar: Icon(
                        _game.didWin ? Icons.emoji_events : Icons.close,
                        size: 18,
                      ),
                      label: Text(_game.didWin ? 'You won' : 'Game over'),
                      backgroundColor: _game.didWin
                          ? const Color(0xFFDDF3E1)
                          : const Color(0xFFF4E0E0),
                      side: BorderSide.none,
                    ),
                ],
              ),
              const SizedBox(height: 10.0),
              AnimatedBuilder(
                animation: _shakeController,
                child: GuessInput(
                  enabled: !_isGameOver,
                  onSubmitGuess: _handleSubmitGuess,
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
              ),
              const SizedBox(height: 8.0),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _message == null
                    ? const SizedBox.shrink()
                    : Padding(
                        key: ValueKey(_message),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5FAF6),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFD8E6DC)),
                          ),
                          child: Text(
                            _message!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF1F5C4B),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10.0),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1F5C4B),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
                onPressed: _restartGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess, required this.enabled});

  final void Function(String) onSubmitGuess;
  final bool enabled;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    if (!enabled) {
      return;
    }

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
              enabled: enabled,
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
          onPressed: enabled ? _onSubmit : null,
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        color: switch (hitType) {
          HitType.hit => const Color(0xFF4FAF63),
          HitType.partial => const Color(0xFFE0B84E),
          HitType.miss => const Color(0xFF8A98A6),
          _ => const Color(0xFFF9FAF7),
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: switch (hitType) {
                  HitType.none => const Color(0xFF1F5C4B),
                  _ => Colors.white,
                },
              ),
        ),
      ),
    );
  }
}
