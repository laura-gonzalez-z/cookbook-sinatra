require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get "/" do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  @recipes = cookbook.all
  erb :index
end

get "/new" do
  erb :create
end

post '/recipe' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  name = params[:recipeName]
  description = params[:recipeDescription]
  rating = params[:recipeRating]
  prep_time = params[:recipePrepTime]
  recipe = Recipe.new(name: name, description: description, rating: rating, prep_time: prep_time, done: false)
  cookbook.add_recipe(recipe)
  redirect to "/"
end
