# ~~MoneyTracker Go API~~ (Deprecated)

**Migrated to FireStore Database and FireBase Google Authentication.**

## Hexagonal Architecture Web API
- [**Fiber**](https://github.com/gofiber/fiber) as Web Framework
- **MySQL** as a Database consists of User Table _"usertbl"_ and Transaction Table _"transactiontbl"_
- Use [**sqlx**](https://github.com/jmoiron/sqlx) or [**GORM**]() to access database 
- Use [**Viper**](https://github.com/spf13/viper) for configuration

## Available Routes
**Transaction Table**
- **GET** Request
  - */transaction/%username%/* - Get all transaction from username with dated format
  - */transaction/%username%/id/%id%* - Get a transaction from username and id
  - */transaction/%username%/date* - Get All Transaction from ranged date and username with dated format ("from" as start date and "to" as end date in query parameters)
- **POST** Request
  - */transaction/%username%/* - Create a transaction to user by JSON formatted request body
- **PUT** Request
  - */transaction/%username%/* - Update a transaction to user by JSON formatted request body
- **DELETE** Request
  - */transaction/%username%/%id%* - Delete a transaction from user by ID

**User Table**
- **GET** Request
  - */user/%username%* - Get a user from usernamefrom 
- **POST** Request
  - */user* - Create a user by JSON formatted request body
- **PUT** Request
  - */user* - Update a user data by JSON formatted request body
- **DELETE** Request
  - */user/%username%* - Delete a user from username

  




