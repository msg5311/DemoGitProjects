Select GenericName, Store, UnitPrice
from Food_demo.Item_prices
where GenericCategory = "Chicken"
Order by UnitPrice DESC
;