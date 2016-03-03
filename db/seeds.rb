# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: "TonyBlair", email: "tonyblair@gmail.com", password: "lovemycliq", password_confirmation: "lovemycliq")
User.create(username: "MargretThatcher", email: "MargretThatcher@gmail.com", password: "lovemycliq", password_confirmation: "lovemycliq")
User.create(username: "JohnMajor", email: "JohnMajor@gmail.com", password: "lovemycliq", password_confirmation: "lovemycliq")
User.create(username: "GordonBrown", email: "GordonBrown@gmail.com", password: "lovemycliq", password_confirmation: "lovemycliq")
User.create(username: "DavidCameron", email: "DavidCameron@gmail.com", password: "lovemycliq", password_confirmation: "lovemycliq")
p "Test users created"