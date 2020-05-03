""" exercise 4 for cme193"""

import collections

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
import numpy.random as rnd
import scipy.special
import scipy.special
import sympy as smp
from numpy import zeros
from scipy.optimize import minimize


def create_poly(array_polynomial):
    """:returns polynomial form
    e.g.
    create_poly([1,2,3])=x**2+2x+3
    """
    order = len(array_polynomial) - 1
    return sum([array_polynomial[k] * x ** (order - k)
                for k in range(order + 1)])


polynomials = np.random.rand(10, 6)
numerical_integration = [np.diff(np.polyval(
    np.polyint(polynomials[k, :]), [0, 1]))
    for k in range(10)]

x = smp.symbols('x')

analytical_integration = [smp.integrate(create_poly(polynomials[k, :]), (x, 0, 1))
                          for k in range(10)]
print(max(np.abs(np.array(analytical_integration) - np.squeeze(numerical_integration))))

# Compute one minima for each polynomial
minimize_points = [minimize(lambda x1: np.polyval(polynomial, x1), np.array(0)).x
                   for polynomial in polynomials]

derivatives = [np.polyval(np.polyder(polynomial), x1)
               for polynomial, x1 in zip(polynomials, minimize_points)]
print(derivatives)
"""Randomly sample the polynomials in the range from
 0 to 1, and see if you can recover
 the original coefficients by trying to fit a 5th order polynomial to the samples."""
polynomial = polynomials[0]
x = rnd.randn(100)
sample_polynomial = np.polyval(polynomial, x)
np.polyfit(x, sample_polynomial, int(5))

p = 0.5
num_average = 100000
N = 50
sum_degrees = zeros(N, )
values = []
for _ in range(num_average):
    G = nx.erdos_renyi_graph(N, p)
    degrees = G.degree
    values += [degrees[value] for value in range(len(G))]

frequencies = {value: counter / (N * num_average) for value, counter in collections.Counter(values).items()}
frequencies = sorted(frequencies.items())
a = [scipy.special.binom(N - 1, k) * p ** k * (1 - p) ** (N - 1 - k) for k in range(N)]

graphs = np.zeros((len(frequencies), 2))

for k, (index, frequency) in enumerate(frequencies):
    graphs[k, :] = [frequency, a[index]]
plt.plot(graphs)
