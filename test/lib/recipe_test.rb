require 'test_helper'

describe Recipe do
  let (:recipe_name) {'teriyaki chicken'}
  let (:recipe_uri) {'www.edamam.com/a_recipe'}
  let (:recipe_ingredients) { ['some', 'ingredients'] }
  let (:recipe_image) { 'www.edamam.com/image' }
  let (:dietary_info) {  }
  let (:recipe_url) { 'www.food.com/another_recipe' }

  describe 'initialize' do
    it 'creates an instance of recipe with all required fields' do
      recipe = Recipe.new(
        name: recipe_name,
        uri: recipe_uri,
        ingredients: recipe_ingredients,
        image: recipe_image,
        dietary_info: dietary_info,
        url: recipe_url
      )

      recipe.must_be_instance_of Recipe
      recipe.name.must_equal recipe_name
      recipe.uri.must_equal recipe_uri
      recipe.ingredients.must_equal recipe_ingredients
      recipe.image.must_equal recipe_image
      recipe.dietary_info.must_equal dietary_info
    end

    it 'raises an error for invalid data' do
      proc { Recipe.new(name: nil, uri: nil, image: nil, ingredients: nil, dietary_info: nil, url: nil) }.must_raise ArgumentError

      proc { Recipe.new(name: nil, uri: recipe_uri, image: nil, ingredients: nil, dietary_info: nil, url: nil) }.must_raise ArgumentError

      proc { Recipe.new(name: recipe_name, uri: nil, image: nil, ingredients: nil, dietary_info: nil, url: nil) }.must_raise ArgumentError

      proc { Recipe.new(name: '', uri: recipe_uri, image: nil, ingredients: nil, dietary_info: nil, url: nil) }.must_raise ArgumentError

      proc { Recipe.new(name: recipe_name, uri: '', image: nil, ingredients: nil, dietary_info: nil, url: nil) }.must_raise ArgumentError
    end
  end

  describe 'from_api' do
    it 'must create a new instance of recipe with good data' do
      raw_recipe = {
        'label' => recipe_name,
        'uri' => recipe_uri,
        'ingredientLines' => recipe_ingredients,
        'image' => recipe_image,
        'url' => recipe_url,
        'dietLabels' => ['all free'],
        'healthLabels' => ['not healthy']
      }

      result = Recipe.from_api(raw_recipe)
      result.name.must_equal raw_recipe['label']
      result.uri.must_equal raw_recipe['uri']
    end
  end
end
