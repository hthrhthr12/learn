"""
Conway's game of Life
"""
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import animation
from matplotlib.pyplot import ion

ion()


def conway_game_of_life():
    """run the game"""
    size = 100
    fig = plt.figure()
    x = (np.random.rand(size, size) > 0.5).astype(int)
    img = plt.imshow(x)
    plt.show()
    ims = []

    for _ in range(10):
        img = plt.imshow(x)
        plt.show()
        plt.pause(0.01)  # It is necessary for the plot to update for some reason
        new_state = x
        for i in range(size):
            for j in range(size):
                neighbors_element = neighbors(x, i, j)
                if x[i, j] and (neighbors_element < 2 or neighbors_element > 3):  # live
                    new_state[i, j] = 0
                elif not x[i, j] and neighbors_element == 3:
                    new_state[i, j] = 1
        x = new_state
        ims.append([img])
    ani = animation.ArtistAnimation(fig, list(ims))

    ani.save('demo.mp4', writer='ffmpeg', fps=2)


def neighbors(x, i, j):
    """return number of neighbors"""
    return sum([element(x, k1, k2) for k1 in range(i - 1, i + 2)
                for k2 in range(j - 1, j + 2) if not (k1 == i and k2 == j)])


def element(x, k1, k2):
    """:returns
    array element
    """
    rows, columns = x.shape
    if k1 in range(rows) and k2 in range(columns):
        return x[k1, k2]
    return 0


conway_game_of_life()
