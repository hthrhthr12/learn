'''
Rock-Paper-Scissors game
Starter code for Stanford CME 193
author: Sven Schmit
'''

import random

class Agent:
    def getMove(self, moves_other, moves_self):
        pass


class InstructorAgent(Agent):
    def __init__(self):
        p_rock = random.random()
        p_scissors = random.random()
        p_paper = random.random()
        p_total = p_rock + p_scissors + p_paper

        self.p_rock = p_rock / p_total
        self.p_scissors = self.p_rock + p_scissors / p_total

    def getMove(self, moves_other, moves_self):
        random_move = random.random()
        if random_move < self.p_rock:
            return 'r'
        elif random_move < self.p_scissors:
            return 's'
        else:
            return 'p'


class MyAgent(Agent):
    def getMove(self, moves_other, moves_self):

        # YOUR CODE HERE

        pass


class HumanAgent(Agent):
    def getMove(self, moves_other, moves_self):

        # YOUR CODE HERE

        pass
