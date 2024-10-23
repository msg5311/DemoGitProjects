Select GenericName, Store, UnitPrice
from Food_demo.Item_prices
where GenericCategory = "Beef"
Order by UnitPrice DESC
;