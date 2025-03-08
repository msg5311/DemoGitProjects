## Unit conversion



def standardize_units(from_unit):

    UNITS = {
    "tsp": "TSP",
    "teaspoon": "TSP",
    "teaspoons": "TSP",
    "tbs": "TBS",
    "tablespoon": "TBS",
    "tablespoons": "TBS",
    "cup": "c",
    "cups": "c",
    "pound": "lbs",
    "pounds": "lbs",
    "lb": "lbs"
}

    a = UNITS[from_unit]
    return print(a)

standardize_units('teaspoon')