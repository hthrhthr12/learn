"""
To generate sentences, we first construct a so-called Markov chain based on actual text data.
 This is a very basic language model.
  We can then sample paths from this Markov chain to create new phrases.
This is actually easier than it sounds:
A Markov chain consists of states, and transition probabilities between states:
 i.e. when I am in state A, what is the probability that I'll go to state B?
We focus on the simple case where the state will be the current word.
 Consider the example sentence
`the fire and the wind.' Then, the states that we move through are
BEGIN ! the ! fire ! and ! the ! wind. ! END
where `BEGIN' and `END' are special states for the beginning and the end of the sentence.
 To find the transition probabilities,
 we go over a large body of text and record current word and the next word.
 In the above example, `BEGIN' is followed by `the', and `the' is followed by `fire'
   and `wind'.
We won't be computing actual probabilities.
 Instead, we create a dictionary that, for every word,
contains all the words that follow it.
To generate a phrase, we start at the `BEGIN' state, and pick
randomly one word from the list of words that follows the `BEGIN' state.
 Then we look up which words
follow that word, and again pick one word at random,
 until we hit the `END' state, which signals that we are done.
"""
import random
import re
import sys


def process_line(line, num_words_per_state):
    """
    Process a line of text to extract (state, new_word) pairs.
    Note that we remove uppercase letters in this example, though
    you don't have to.
    one can replace "word1 word2" -->["word1", "word2"]
    Example:
    process_line("In winter I get up at night",num_words_per_state=3) =
    [('BEGIN', 'in winter'),
     ('in winter', 'i'),
     ('winter i', 'get'),
     ('i get', 'up'),
     ('get up', 'at'),
     ('up at', 'night'),
     ('at night', 'END')]
    Example:
    process_line("In winter I get up at night",num_words_per_state=4) =
    [('BEGIN', 'in winter i'),
     ('in winter i', 'get'),
     ('winter i get', 'up'),
     ('i get up', 'at'),
     ('get up at', 'night'),
     ('up at night', 'END')]

    Example:
    process_line("In winter I get up at night",2) =
    [('BEGIN', 'in'),
     ('in', 'winter'),
     ('winter', 'i'),
     ('i', 'get'),
     ('get', 'up'),
     ('up', 'at'),
     ('at', 'night'),
     ('night', 'END')]
     We add the BEGIN and END keywords so that we can initialize the
    sentence and know when the line ends.
    """
    words = line.lower().split()
    if not words:
        return
    # apply for num_words_per_state=2:
    # [('BEGIN', words[0])] + list(zip(words[:], words[1:])) + [(words[-1], 'END')]
    first_column_tuple = [" ".join([words[j] for j in range(i - num_words_per_state + 1, i)])
                          for i in range(num_words_per_state - 1, len(words) + 1)]
    # not include the index num_words_per_state - 1
    tuple_words = [('BEGIN', " ".join(words[:num_words_per_state - 1]))] + \
                  list(zip(first_column_tuple, words[num_words_per_state - 1:])) + \
                  [(" ".join(words[1 - num_words_per_state:]), 'END')]
    return tuple_words


def process_text_file(filename, num_words_per_state):
    """
    Creates a dictionary with transition pairs
    based on a file provided

    For the first part of the assignment, we use a
    placeholder text that you will have to replace
    at some point.

    Based on the placeholder text, the dictionary
    should contain the following key-value pairs:

    'blue,': ['END']
    'by': ['yellow', 'day.', 'day?']
    'still': ['hopping', 'going']
    e.g.
    process_text_file("filename")
    """
    dictionary_whole_text = {}

    # Placeholder until we add File I/O in part two
    # Overwrite the following lines with your code:
    # text from http://www.bygosh.com/Features/082000/rhymes.htm
    #     article = '''In winter I get up at night
    # And dress by yellow candle-light.
    # In summer quite the other way,
    # I have to go to bed by day.
    #
    # I have to go to bed and see
    # The birds still hopping on the tree,
    # Or hear the grown-up people's feet
    # Still going past me in the street.
    #
    # And does it not seem hard to you,
    # When all the sky is clear and blue,
    # And I should like so much to play,
    # To have to go to bed by day?
    # '''.split('\n')

    with open(filename) as f:
        article = f.read()
    # see: https://regex101.com/, removes characters:
    article = re.sub(pattern=r'[^A-Za-z0-9,?!;" \'\n\-.]+', repl='', string=article)
    for sentence in article.split('.'):  # replace by '\n'
        pairs_words = process_line(sentence, num_words_per_state)
        if not sentence:  # empty sentence
            continue
        if not pairs_words:  # empty pairs_words, needed for sentence='\n'
            continue

        for pair_adjacent in pairs_words:
            if dictionary_whole_text.get(pair_adjacent[0]):
                dictionary_whole_text[pair_adjacent[0]] += [pair_adjacent[1]]
            else:
                dictionary_whole_text.update({pair_adjacent[0]: [pair_adjacent[1]]})
    return dictionary_whole_text


def generate_line(dictionary_whole_text, num_words_per_state):
    """
    Generates a random sentence based on the dictionary
    with transition pairs

    Note that the first state is BEGIN but that we
    obviously do not want to return BEGIN

    Some sample output based on the placeholder text:
    'i have to go to go to go to go to play,'

    Hint: use random.choice to select a random element from a list
    """
    sentence = random.choice(dictionary_whole_text['BEGIN'])
    last_words = sentence
    is_finished = False
    while not is_finished:
        new_word = random.choice(dictionary_whole_text[last_words])
        if new_word == 'END':
            return sentence
        sentence += ' ' + new_word
        last_words = " ".join(sentence.split()[1 - num_words_per_state:])
    return sentence


def main():
    """main execution"""
    if len(sys.argv) != 2:
        print('ERROR: Run as python markov.py <filename>')
        exit()
    num_words_per_state = 3
    dictionary = process_text_file(sys.argv[1], num_words_per_state)
    print(generate_line(dictionary, num_words_per_state))


if __name__ == '__main__':
    main()
