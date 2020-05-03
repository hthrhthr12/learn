"""exercises python course"""
import collections
import itertools
import json
import math
import random
import re

import more_itertools

# 2.2
# print between 0 to 100
print(list(range(101)))

# Print 0 to 100 that are divisible by 7
print([i for i in range(101) if not i % 7])

# Print 1-100 that are divisible by 5 but not by 3
print([i for i in range(1, 101) if not i % 7 if i % 3])

# Print for x = 2-20, all numbers that divide x, excluding 1 and x.
print([[j for j in range(2, x - 1) if not x % j] for x in range(2, 20)])
# 2.3
# print between 0 to 100
i = 0
while i <= 100:
    print(i)
    i += 1
# Print 0 to 100 that are divisible by 7
i = 0
while i <= 100:
    if not i % 7:
        print(i)
    i += 1

# 2.5, same as [lcm*x for x in range(1,21)]
number_found = 0
x = 5 * 7 * 11
lcm = x
while number_found < 20:
    if not x % lcm:
        print(x)
        number_found += 1
    x += 1

# 2.6 smallest number that is divisible by
# all integers between 1 and 10
found = False
num = 210
divisor = False
while not found:
    for divide in range(2, 11):
        if num % divide:
            divisor = False
            break
        if divide == 10:
            found = True
            print(num)
    # divide by all numbers up to 10
    num += 1

# 2.7: Collatz sequence
x = 103
while x != 1:
    if x % 2:  # x odd
        print(x)
        x = 3 * x + 1
    else:
        print(x)
        x //= 2

print(x)


# 3.1: Hello
def hello_world():
    """print hello"""
    print('Hello, world!')


def hello_name(name):
    """print hello for specific name"""
    print(f'Hello, {name}!')


# 3.2: Polynomial
def polynomial(x):
    """calculate polynomial: 3 * x ** 2 - x + 2"""
    print(3 * x ** 2 - x + 2)


# 3.3: Maximum
def max_if_else(x, y):
    """calculate max by if and else"""
    if x > y:
        return x
    else:
        return y


def max_if(x, y):
    """calculate max by if"""
    if x > y:
        return x
    return y


# 3.4: Primes
def is_prime(n):
    """return if is prime for natural numbers,
    assuming 1 is not prime"""
    if n == 1:
        return False
    if n < 4:
        return True
    """one of the factor must be smaller than square_root(n)"""
    for factor in range(2, math.floor(math.sqrt(n)) + 1):
        if not n % factor:
            return False
    return True


def is_prime_6k(n):
    """return is prime for natural numbers.
    prime numbers have the form 6k+/-1.
    assuming 1 is not prime"""
    if n == 1:
        return False
    if n < 4:
        return True
    if not n % 6 in [1, 5]:
        return False
    """one of the factor must be smaller than square_root(n)"""
    for factor in range(2, math.floor(math.sqrt(n)) + 1):
        if not n % factor:
            return False
    return True


def primes_up_to_n(n):
    """:return: primes up to n"""
    return [x for x in range(2, n + 1) if is_prime_6k(x)]


def first_n_primes(n):
    """returns the first n primes."""
    primes = []
    num_check = 1
    primes_until_now = 0
    while primes_until_now < n:
        if is_prime_6k(num_check):
            primes.append(num_check)
            primes_until_now += 1
        num_check += 1
    return primes


# 3.5: Root finding
def root(f, a_in, b_in):
    """calculate the root of the function between a and b
    assuming they have different signs.
    check by:
    root(lambda x:2*x+1,-3,3)
    """
    num_iterations = 1000
    a = min(a_in, b_in)
    b = max(a_in, b_in)
    f_a = f(a)
    f_b = f(b)
    if f_a == 0:
        return a
    if f_b == 0:
        return b
    if f_a * f_b > 0:
        print(f'function evals have same sign, f({a}):{f_a}, f({b}):{f_b}')
        return
    c = 0  # initialization
    for _ in range(num_iterations):
        c = (a + b) / 2
        f_c = f(c)
        if f_c == 0:
            return c
        if f_c * f_a > 0:
            # solution in [c,b]
            a = c
            f_a = f_c
        if f_c * f_b > 0:
            # solution in [a,c]
            b = c
            f_b = f_c
    return c


# 4.1: Short questions
def print_list(list_name):
    """print list"""
    print(list_name)


def print_list_reversed(list_name):
    """print list reversed"""
    # list_name.reverse() #modifies the list
    # print(list_name)
    # print(list(reversed(list_name)))
    print(list_name[::-1])


def list_len(list_name):
    """calculate length of a list"""
    copy = list_name[:]
    length = 0
    while copy:  # copy not empty
        length += 1
        copy.pop()
    return length


# 4.2: Copying lists
def set_first_elem_to_zero(list_name):
    """sets its first entry to zero"""
    list_name[0] = 0


# 4.4: Lists and functions
def nullify_elem_to_zero(list_name, index):
    """sets list entry to zero"""
    list_name[index] = 0


# 4.6: List comprehensions
def create_lists(n):
    """
    (a) Generate a list with elements [i,j].
    (b) Generate a list with elements [i,j] with i < j
    (c) Generate a list with elements i + j with both i and j prime and i > j.
    :return:
    """
    i_j_list = [[i, j] for i in range(1, n + 1) for j in range(1, n + 1)]
    i_smaller_j_list = [[i, j] for i in range(1, n + 1) for j in range(1, n + 1) if i < j]
    i_plus_j_prime = [i + j for i in range(1, n + 1) for j in range(1, n + 1) if i > j
                      and is_prime_6k(i) and is_prime_6k(j)]
    return i_j_list, i_smaller_j_list, i_plus_j_prime


def polynomial_evaluation(coefficients, x):
    """enumerate contains list of indices and values
    :returns polynomial evaluation"""
    return sum([a0 * x ** n for n, a0 in enumerate(coefficients)])


def my_filter(boolean_function, list_name):
    """filter implementation
    :returns generator by generator comprehension
    list(my_filter(lambda x: x < 0, [1,2,-1]))
    same as: list(filter(lambda x: x < 0, [1,2,-1]))
    """
    return (x for x in list_name if boolean_function(x))


# 4.8: Flatten a list of lists
def flatten(list_of_lists):
    """takes list of lists, and returns a list with as
     elements the elements of the sub lists.
     e.g.
     flatten([[1,3], [3,6]])
     """
    # equivalent solutions:
    # return sum(list_of_lists, [])
    return [item for sublist in list_of_lists for item in sublist]


# 4.9: Finding the longest word
def longest_word(sentence):
    """returns the longest word in a variable text that contains a sentence.
    Split the sentence by non word characters, excluding `'`.
    e.g.
    longest_word('Hello, how was the football match earlier today???')
    In ties take the first longest word.
    """
    return max(re.split('[^\w\']+', sentence), key=len)


# 4.10: Collatz sequence
def collatz_sequence(x):
    """returns its Collatz sequence as a list"""
    sequence = []
    while x != 1:
        if x % 2:  # x odd
            sequence.append(x)
            x = 3 * x + 1
        else:
            sequence.append(x)
            x //= 2
    sequence.append(x)
    return sequence


# finds the integer x that leads to the longest Collatz sequence with x < n.
def longest_collatz(n):
    """
    :param n: integer n
    :return:
    map(collatz_sequence, range(1, n) evaluates the Collatz sequence
    max find the maximal sequence
    for the integer x that leads to the longest Collatz sequence,
    we take the first element in the sequence
    e.g.
    longest_collatz(int(1e6)) #837799
    faster implementation can store only the length of the series in collatz_sequence()
    """
    return max(map(collatz_sequence, range(1, n)), key=len)[0]


# 4.11: Pivots
def pivots(x, list_ys):
    """takes a value x and a list ys,
    and returns a list that contains the value x and all
    elements of ys such that all values y in ys
    that are smaller than x come first,
     then we element x and
    then the rest of the values in ys
    pivots(3, [6, 4, 1, 7]) # [1, 3, 6, 4, 7]
    """
    list_ordered = [element for element in list_ys if element < x]
    list_ordered.append(x)
    for element in list_ys:
        if not element < x:
            list_ordered.append(element)
    return list_ordered


# 4.12: Prime challenge
def primes_to_n(n):
    """ return a list with all prime numbers up to n"""
    'take the numbers if the set of divisors is empty.'
    return [x for x in range(2, n + 1) if not [t for t in range(2, x) if not x % t]]
    # equivalent to:
    # we remove from the list nums the numbers, which divide by i
    # nums = range(2, n)
    # for i in range(2, math.floor(math.sqrt(n)) + 1):
    #     nums = list(filter(lambda x: x == i or x % i, nums))
    # return nums


# 5.1: Swapping two values
def swap_variables(a, b):
    """swap variables by tuple"""
    a, b = b, a
    return a, b


# 5.2: Zip
def zip_unzip(x, y):
    """a list with the coordinates (x,y) as a tuple."""
    zipped = list(zip(x, y))
    x2, y2 = zip(*zipped)
    return list(x2), list(y2)


# 5.3: Distances
def l1(x, y):
    """compute the l1 distance between x and y."""
    return sum([abs(x_element - y_element) for x_element, y_element in zip(x, y)])


def l2(x, y):
    """compute the l2 distance between x and y."""
    return math.sqrt(sum([(x_element - y_element) ** 2
                          for x_element, y_element in zip(x, y)]))


# 6.1: Printing a dictionary
def print_dictionary(dictionary):
    """prints key-value pairs of a dictionary.
    e.g.
    print_dictionary({'key1':'value1','key2':'value2'})
    """
    print(*dictionary.items(), sep='\n')


# 6.2: Histogram
def occurrences(list_name):
    """dictionary with keys the elements of the list and as
    value the number of occurrences of that element in the list.
    e.g.
    occurrences([1,2,3,4,2,1])
    """
    return collections.Counter(list_name)
    # equivalent code:
    # dictionary = {}
    # for element in list_name:
    #     dictionary.update({element: len([x for x in list_name if x == element])})
    # return dictionary


# 6.3: Get method
def occurrences_get(list_name):
    """dictionary with keys the elements of the list and as
    value the number of occurrences of that element in the list.
    e.g.
    occurrences_get([1,2,3,4,2,1])
    """
    dictionary = {}
    for element in list_name:
        if dictionary.get(element):
            dictionary[element] += 1
        else:
            dictionary.update({element: 1})
    return dictionary


# 6.5: Vector functions
def add_dense(x, y):
    """adds two (dense) vectors
    e.g. add_vectors([1,1],[1,2])
    """
    return [x_val + y_val for x_val, y_val in itertools.zip_longest(x, y, fillvalue=0)]


def multiply_dense(x, y):
    """multiplies (i.e. inner product) two (dense) vectors
    e.g. inner_product([1,1],[1,2])
    assuming the arrays are of the same lengths
    """
    return sum((x_val * y_val for x_val, y_val in zip(x, y)))


def add_sparse(x, y):
    """adds two sparse vectors.
    e.g.
    add_sparse({0:1, 1: 2, 2: 4},{0:1, 1: 2, 3: 4})
    """
    sum_sparse = {**x, **y}
    for index in sum_sparse:
        if x.get(index) and y.get(index):
            sum_sparse[index] = x[index] + y[index]
    # sort dictionary by the key
    return {k: v for k, v in sorted(sum_sparse.items())}


def multiply_sparse(x, y):
    """multiplies two sparse vectors
    e.g.
    multiply_sparse({0:1, 1: 2, 2: 4},{0:1, 1: 2, 3: 4})
    assuming the arrays are of the same lengths
    """
    return sum((x_val * y_val for (x_key, x_val), (y_key, y_val)
                in zip(x.items(), y.items()) if x_key == y_key))


def sparse_to_dense(x):
    """convert sparse vector to dense vector"""
    length = max(x) + 1
    dense_vector = [0] * length
    for key in x:
        dense_vector[key] = x[key]
    return dense_vector


def dense_to_sparse(x):
    """convert dense vector to sparse vector"""
    sparse_vector = {}
    index = 0
    for value in x:
        if value != 0:
            sparse_vector.update({index: value})
        index += 1
    return sparse_vector


def add_sparse_dense(dense, sparse, return_type='dense'):
    """adds a sparse vector and a dense vector,
    :returns dense/sparse vector, depends on the return type value
    """
    if return_type == 'dense':
        return add_dense(dense, sparse_to_dense(sparse))
    return add_sparse(sparse, dense_to_sparse(dense))


def multiply_sparse_dense(dense, sparse, algorithm_type='dense'):
    """multiplies a sparse vector and a dense vector,
    :returns inner product, depends on the algorithm type value
    """
    if algorithm_type == 'dense':
        return multiply_dense(dense, sparse_to_dense(sparse))
    return multiply_sparse(sparse, dense_to_sparse(dense))


# 6.6: Reverse look-up
def reverse_look_up(dictionary, value):
    """returns the key
    associated with this value.
    Find the keys associated with this value, if exists.
    e.g.
    reverse_look_up({1:22,2:22,3:324,33:32},22)
    """
    return [key for key, val in dictionary.items() if value == val]


# 7.1: Open a file
def print_line_by_line(file_name):
    """opens a file (input: filename), and prints the file line by line.
    e.g.
    print_line_by_line("Markov-chain-startercode\data\metamorphosis.txt")
    """
    with open(file_name) as f:
        for line in f:
            print(line)
        f.close()


# 7.2: Wordcount
def common_words():
    """Split the sentence by non word characters, excluding `'`.
    Take the words in lowercase format and find the 20 common words
    """
    # there is no need to call file.close() when using with statement.
    with open("shakespeare.txt") as f:
        counter = collections.Counter(re.split('[^\w\']+', f.read().lower()))

    common_20_words = counter.most_common(20)
    # remove counts of common words:
    common_20_words = [word for word, _ in common_20_words]
    # more_itertools.ilen counts the length of a generator
    num_unique = more_itertools.ilen((value for value, count in counter.items() if count == 1))
    num_used_at_least_5 = more_itertools.ilen((value for value, count in counter.items() if count >= 5))
    common_200_words = counter.most_common(200)
    with open("common_200_words.txt", 'w') as common_words_file:
        common_words_file.write(str(common_200_words))
    return common_20_words, num_unique, num_used_at_least_5


# 7.4: Sum of lists
def write_random(n, a, b, file_name):
    """takes three integers, n, a and b and a filename and writes to the file
    a list with n random integers between a and b"""
    with open(file_name, 'w') as file_handle:
        json.dump([random.randint(a, b) for _ in range(n)], file_handle)


def read_list(file_name):
    """takes a filename and reads the file to a list"""
    with open(file_name) as file_handle:
        return json.load(file_handle)


def two_sum(file1, file2, target):
    """given two file names and an integer target,
     finds all u and v such that u + v = k, and u is an element of the first list
      and v is a member of the second list."""
    list1 = read_list(file1)
    list2 = read_list(file2)
    results = []
    list2_dict = {n: 1 for n in list2}
    for number in list1:
        if list2_dict.get(target - number):
            results.append([number, target - number])
    return results


def test_random():
    """Test your functions by generating 2 files with n = 2000,
     a = 1, b = 10000 and k = 5000 and k = 12000."""
    n = 2000
    a = 1
    b = 10000
    k1 = 5000
    k2 = 12000
    file1 = "file1.txt"
    file2 = "file2.txt"
    write_random(n, a, b, file1)
    write_random(n, a, b, file2)
    print(two_sum(file1, file2, k1))
    print(two_sum(file1, file2, k2))


# 8.1: Rational numbers
def gcd(a, b):
    """calculate the greatest common divisor"""
    while b:
        a, b = b, a % b
        print(f"{a} {b}")
    return a


class Rational:
    """Rational class"""

    def __init__(self, nominator=1, denominator=1):
        g = gcd(nominator, denominator)
        self.p = nominator // g
        self.q = denominator // g

    def __str__(self):
        return f"{self.p}/{self.q}"

    def __add__(self, other):
        p = self.p * other.q + other.p * self.q
        q = self.q * other.q
        return Rational(p, q)

    def __sub__(self, other):
        p = self.p * other.q - other.p * self.q
        q = self.q * other.q
        return Rational(p, q)

    def __mul__(self, other):
        return Rational(self.p * other.p, self.q * other.q)

    def __div__(self, other):
        return Rational(self.p * other.q, self.q * other.p)

    def __cmp__(self, other):
        return self.p * other.q - other.p * self.q

    def __float__(self):
        return self.p / self.q

    def __abs__(self):
        return Rational(abs(self.p), abs(self.q))

    def minus(self):
        """:returns
        minus the number"""
        return Rational(-self.p, self.q)

# 8.2: Rock Paper Scissors
