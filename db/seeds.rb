# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

["User", "Team", "Stock"].each do |entity|
  Entity.find_or_create_by!(entity_name: entity, entity_type: entity.downcase)
end

Account.create({ name: "Rendy", email: "rendyreynaldy@yopmail.com", password: "password" })
Account.create({ name: "Steve", email: "steve@yopmail.com", password: "password" })
