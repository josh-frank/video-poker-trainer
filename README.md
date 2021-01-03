# Video Poker Trainer
---

## Summary

This Video Poker Trainer is a game to teach a new poker player how to calculate odds in five card draw. It was written as an exercise in using `tty-prompt` to create a simple CLI during my time at [Flatiron School](https://flatironschool.com/). Using `ActiveRecord`, this code can load/create a player and then save statistics of a player's speed/accuracy after play to track progress. It also features some cute ASCII hand graphics.

**This is NOT a gambling game! NO luck or betting is involved.** A player improves his/her score *only* by calculating odds quickly and accurately - *not* by drawing a valuable hand.

This code uses the `hand-rank` gem created by [Replay Gaming](https://www.replaypoker.com/), a British poker education company. It's the same code used in their online lessons and poker tournaments, an adaptation of the [TwoPlusTwo algorithm](https://github.com/tangentforks/TwoPlusTwoHandEvaluator) originally written by Ray Wotton. It uses a very large lookup table and extension (written in C) to assign each distinct hand a number, and then quickly calculate its value and strength relative to all 2.6 million other possible poker hands. I'm using it here because it's very fast - capable of evaluating around 8 million hands a second under ideal conditions. My own poker hand evaluator uses a binary histogram but it's much slower and can only evaluate around 150,000 hands a second, which would make this game unplayable.

## Instructions

After forking and cloning this repository, run `bundle install` in the terminal to install dependencies, then run it with `ruby bin/run.rb`.

After creating or loading a user, you will be taken to the game loop where you will be shown a random five-card hand like the one below:

```
╭─╴8╶─╮╭─╴9╶─╮╭─╴A╶─╮╭─╴Q╶─╮╭─╴9╶─╮
│♦   ♦││♠   ♠││ ╓─╖ ││  ♣  ││♣   ♣│
│♦   ♦││♠ ♠ ♠││ ║♠║ ││ ╭⍙╮ ││♣ ♣ ♣│
│♦   ♦││♠   ♠││ ║ ║ ││⎠◞⍣◟⎝││♣   ♣│
│♦   ♦││♠   ♠││ ╙─╜ ││ ╲¯╱ ││♣   ♣│
╰─────╯╰─────╯╰─────╯╰─────╯╰─────╯
```

The game will then show you a menu of cards from which you will choose cards to hold:

```
Your hold?  9 of Spades, 9 of Clubs
  ⬡ 8 of Diamonds
  ⬢ 9 of Spades
  ⬡ Ace of Spades
  ⬡ Queen of Clubs
‣ ⬢ 9 of Clubs
```

Then the game will tell you if you made the correct choice, or show you the best possible hold if you chose incorrectly. The game will also show you how many hands you've played and your speed in milliseconds. Your score is *not* simply the ratio of right holds to wrong holds, but rather how close you are to a perfect player. After each round you will be prompted to quit by entering `n` or `no`.

```
Correct!
Current score: 100.0%
1 out of 1 correct answers so far
Answered in 6.473 seconds - average time so far: 6.473 seconds
Keep playing? (y/n) (Y/n) 
```

After finishing play, the game will show you a statistics screen with your current score, total number of hands played, average response time, and an assessment of your improvement in speed.

```
╭─────╮╭─────╮╭─────╮╭─────╮╭─────╮
│▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞│
│▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞│
│▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞│
│▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞││▞▞▞▞▞│
╰─────╯╰─────╯╰─────╯╰─────╯╰─────╯
Progress successfully saved!

Today's score: 99.732%
7 correct answers out of 9 hands

1.891 sec. average response time this round.
Your average response time rose by 0.036 seconds.
Your new score: 98.027%

THANKS FOR PLAYING - UNTIL NEXT TIME!
```