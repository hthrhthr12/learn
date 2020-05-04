"""avocado prices analysis"""
import matplotlib.pyplot as plt
import pandas as pd

avocado = pd.read_csv("avocado.csv")[['region', 'Date', 'AveragePrice']]
avocado.index = pd.to_datetime(avocado['Date'])
mean_data = avocado.groupby('region')['AveragePrice'].agg(
    lambda group: pd.DataFrame(group.resample('90D').mean()))

fig, ax = plt.subplots()
mean_data.map(lambda country: country.plot(ax=ax, legend=False))
plt.show()

plt.figure()
sum_prices = avocado.resample('90D')['AveragePrice'].sum()
sum_prices.plot()
plt.title('avocado total price')
