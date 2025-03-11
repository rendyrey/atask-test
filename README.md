# Simple Wallet Transaction System

version: 1.0.0 by Rendy Reynaldy A.

## Features
- Login with JWT
- Top-up, Withdraw, Transfer transactions
- At the end of the day or at 23:00 everyday, all the account wallets will be recalculate to update the balance by looking all transactions.

## Tech Used
- [Ruby on Rails](https://rubyonrails.org/)
- [SQLite]

## Installation
- Download or clone this repository
- Go to project root directory & run this command for installing dependencies:
```sh
bundle install
```
- run this command to migrate database:
```sh
rails db:migrate
rails db:seed
RAILS_ENV=test rails db:migrate
RAILS_ENV=test rails db:seed
```
- after migration successfull, run this command to run the server in your local machine:
```sh
rails s
```
- By default the url will be: <code>localhost:3000</code>

- If you want to test the controller, you can use Rspec with this command:
```sh
rspec spec/requests/api/v1 --format documentation
```

## Postman Collection
- [Link to Postman Collection & Environment](https://drive.google.com/file/d/17Lrzx_m_-hnv8Cz7NnEdRhSuGcjREZNw/view?usp=sharing)
