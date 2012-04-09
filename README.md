YEG Rubyists
===========
A project to display the yegrb rubyists activity

Installation
--------
Git clone
Update twitter oauth -> config/initializers/twitter.rb
Create a few users
Run rails console -> DataParser.update_data (should populate data based on users)

General Errors
--------
You need to have at least 1 item per column before backbone can pick up the items
DataParser.update_data's job is to populate the initial data

Column Errors:
--------
**Twitter column not showing up?**
Make sure you have the twitter oauth account setup correctly (and the keys updated)

**Blog column not showing up?**
Make sure the blog url is in Atom format (not RSS). IE: http://www.ryanonrails.com/feed/atom/

TODO
--------
See todo.txt