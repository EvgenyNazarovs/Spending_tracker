# Spending_tracker

An easy-to-use app that allows users to enter transactions, add tags and merchants, and break down their spending by month, tag, or merchant.

# Getting Started

This is app runs on your local server, from your terminal. You must have Ruby, Sinatra, and PSQL installed on your computer.

First, create a database on your machine called spending tracker by typing in: createdb spending_tracker.

Second, enter in your terminal from the root directory of the project 

psql -d spending_tracker -f db/spending_tracker.sql

This should set up the database environment for the app. From now, you can access the app database by typing psql -d spending_tracker form anywhere on your computer.

Finally, navigate to the root directory of the project in your terminal and type in 

ruby app.rb

This should start the server. You can now access the app by loading http://localhost:4567/

# Running the Tests

Run ruby db/seeds.rb in your terminal. It will populate the database with some test data and open up the pry environment in the terminal, which can be used to test methods from any class.

# Built With

Sinatra - The web framework used;
Ruby

# Author

Eugene Nazarovs

# Acknowledgments

Thank you to our instructors!



