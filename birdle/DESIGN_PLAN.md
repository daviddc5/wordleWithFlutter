# Wordle-Style Game Plan

## Goal
Turn this tutorial project into a small, polished Wordle-style game that feels fun to use, easy to understand, and good enough to keep improving.

## Design Direction
- Keep the game playful and clean.
- Use one strong accent color, not too many competing colors.
- Make the board feel centered and intentional.
- Keep the UI simple enough that the game stays readable on mobile.

## Visual Style
- Use a darker app bar color like deep green or deep blue.
- Add a subtle background gradient behind the whole screen.
- Use rounded corners on tiles, the input field, and buttons.
- Keep the tile grid clear and evenly spaced.
- Use richer hit colors for green, yellow, and grey.

## Layout
- Put the title at the top.
- Add a short subtitle like "Guess the word in 5 tries".
- Center the board vertically on the screen.
- Keep the guess input and submit button together in one row.
- Place feedback text below the input.
- Place the restart button below the feedback text.

## Game Feel
- Keep the AnimatedContainer tile color transitions.
- Add a shake animation for invalid guesses.
- Add a small pop effect when a guess is accepted.
- Add a win banner when the player wins.
- Add a lose message that shows the hidden word.

## UX Improvements
- Auto-focus the input when the game starts.
- Keep the input focused after each guess.
- Show a message for illegal guesses.
- Disable input after the game ends.
- Make restart easy to find and tap.
- Show how many guesses are left.

## Fun Extras
- Add sound effects for submit, win, and invalid guesses.
- Add a small celebration effect on win.
- Add a score or streak counter later.
- Add daily challenge mode later.

## Suggested Build Order
1. Improve spacing, title, and background.
2. Add feedback text and a restart button.
3. Add win and lose banners.
4. Add shake animation for bad guesses.
5. Add sound and celebration polish.

## Flutter Widgets Likely Needed
- `Scaffold`
- `AppBar`
- `Container`
- `AnimatedContainer`
- `AnimatedOpacity`
- `AnimatedScale`
- `Row`
- `Column`
- `Padding`
- `Text`
- `IconButton`
- `TextButton`
- `SnackBar` or inline message text

## Notes
- Start with small visual changes before adding complex animations.
- Keep each improvement easy to test in Chrome.
- Do not add too many effects at once, or the game will feel busy.

## Play Store-Ready Feature List
- Daily hidden word challenge.
- Streak tracking so players want to come back.
- Shareable results card with no spoilers.
- Easy and hard modes for different players.
- Offline play support.
- Fast startup and small app size.
- Clean onboarding so new players understand the game quickly.
- Strong app branding with its own colors and identity.

## Publishing Cost Reality
- Google Play developer account requires a one-time signup fee.
- If you monetize with purchases or subscriptions, store service fees apply.
- Budget for optional costs like artwork, sound design, device testing, and analytics tools.

## Compete With Other Word Games
- Build a distinct identity, not just a basic Wordle clone.
- Focus on retention loops: daily puzzle, streaks, and return incentives.
- Add social shareability with spoiler-free score sharing.
- Keep gameplay readable and smooth on small screens.
- Prioritize speed and reliability: quick launch, no crashes, and clear feedback.

## Retention Features To Prioritize
- Daily puzzle mode.
- Streak and stats screen.
- End-of-round summary with next-step call to action.
- Share result card after each game.

## Differentiation Features
- Multiple modes: Daily, Practice, and Hard Mode.
- Optional hint system with fair limits.
- Strong visual theme and audio identity unique to your app.

## Store Growth Checklist
- App icon that is clear at small sizes.
- Screenshot set that explains game flow quickly.
- Short promo video showing the key interaction loop.
- Store listing copy with strong keywords and clear value.
- In-app rating prompt after successful rounds.

## Launch Roadmap
1. Phase 1 (ship-ready core): daily mode, streaks, share card, and polished UI.
2. Phase 2 (retention growth): hard mode, hint system, and improved onboarding.
3. Phase 3 (monetization and scale): optional ads or premium tier, deeper stats, and live events.