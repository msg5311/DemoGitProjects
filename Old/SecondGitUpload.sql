Select GenericName, Store, Avg(UnitPrice) as AvgPrice
from Food_demo.Item_prices
GROUP BY GenericName, Store
Order by AvgPrice DESC
;
