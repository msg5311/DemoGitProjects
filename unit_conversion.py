

def solid_weight_conv(amount,recipe, base):
    ## assumes all recipes convert to 'oz' for now.
    factors = {
        "oz": 1.0000,
        "g": 0.0400,
        "lb": 16.0000
    }
    
    """
    Converts solid-weight amounts to base units.

    Args:
        amount: The amount of the ingredient.
        recipe: The unit the recipe/sold in.
        base: the base unit of this ingredient.

    Returns:
        The converted amount.

    """
    oz = amount * factors[recipe]

    result = oz / factors[base]
    
    return result

a = solid_weight_conv(5,'lb', 'g')

##result = solid_weight_conv(amount, recipe, base)

print(a)


def liquid_vol_conv(amount,recipe, base):
    factors = {
        "fl oz": 1.0000,
        "tsp": 0.1700,
        "tbs": 0.5000,
        "ml": 0.0300,
        "c": 8.0000,
        "gal": 128.0000
    }

    fl_oz = amount * factors[recipe]

    result = fl_oz / factors[base]

    return result

b = liquid_vol_conv(3, 'c', 'gal')

print(b)