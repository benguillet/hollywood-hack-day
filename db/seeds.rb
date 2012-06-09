# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Content.create( :user_id => '1', :url => 'http://www.youtube.com/embed/u1zgFlCw8Aw', :rate_up => 0, :rate_down =>  0, :source => 'youtube')
Content.create( :user_id => '1', :url => 'http://www.youtube.com/embed/A8IVASo0umU', :rate_up => 0, :rate_down =>  0, :source => 'youtube')
Content.create( :user_id => '1', :url => 'http://player.vimeo.com/video/43708825', :rate_up => 0, :rate_down =>  0, :source => 'vimeo')

