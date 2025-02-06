-- Input the recipes you want to make this week:
SELECT "MEP".recipe_select_sp('{Penne vodka, Chicken stock pasta}'::character varying[]);
-- Creates grocery list of items that are needed:
call "MEP".grocery_list_sp();
-- After grocery shopping, stocks pantry with new items:
call "MEP".stock_pantry_sp();
-- User enters recipe into this SP when they are cooking that recipe. Ingredients are then deducted from the pantry:
call "MEP".test_recipe('asdf');