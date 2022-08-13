require "csv"
require_relative "recipe"

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    read_csv
  end

  def all
    @recipes
  end

  def find(index)
    @recipes[index]
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_to_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save_to_csv
  end

  def delete_all
    @recipes = []
    save_to_csv
  end

  def mark_as_done(index)
    @recipes[index].mark_as_done!
    save_to_csv
  end

  private

  def read_csv
    CSV.foreach(@csv_file_path) do |row|
      @recipes << Recipe.new({ name: row[0], description: row[1], rating: row[2], prep_time: row[3], done: row[4] })
    end
  end

  def save_to_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.done?]
      end
    end
  end
end
