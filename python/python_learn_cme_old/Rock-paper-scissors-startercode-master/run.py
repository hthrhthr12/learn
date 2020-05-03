'''
Rock-Paper-Scissors game
Starter code for Stanford CME 193
author: Sven Schmit
'''

from game import Game
from agent import InstructorAgent, MyAgent, HumanAgent


# We can specify which agents we want to play the game here
# Optional: pass this in using the command line
game = Game(InstructorAgent(), InstructorAgent())

# How many rounds do we want to play
# Optional: pass this in using the command line
number_rounds = 10
game.play(number_rounds)

# Print summary
game.summary()
