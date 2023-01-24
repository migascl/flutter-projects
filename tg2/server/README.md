# Database

The ```db``` folder contains backups of the database. 
```main.sql``` contains the basic structure of the database and **must be imported beforehand**, while ```examples.sql``` contains example entries for demonstration purposes.\
*Some entries in the database were purposely inserted incorrectly (missing images or paths) for demonstration purposes.*

# API

>### Headers
> - **Content type**: ```application/json; charset=UTF-8```

## Endpoints

>### ```/```
>Root endpoint primarily used to verify connection with the API.
>#### Methods
>- **GET**

>### ```/country```
>Endpoint for Country entity.
>#### Methods
> - **GET**

>### ```/stadium```
>Endpoint for Stadium entity.
>#### Methods
>- **GET**

>### ```/club```
>Endpoint for Club entity.
>#### Methods
>- **GET**

>### ```/match```
>Endpoint for Match entity.
>#### Methods
>- **GET**

>### ```/player```
>Endpoint for Player entity.
>#### Methods
>- **GET**

>### ```/schooling```
>Endpoint for Schooling entity.
>#### Methods
>- **GET**

>### ```/exam```
>Endpoint for Exam entity.
>#### Methods
>- **GET**
>- **POST**
>  ```json
>  {
>    "player_id": 4,
>    "date": "2023-01-02",
>    "result": true
>  }
>  ```
>- **PATCH**
>  ```json 
>  {
>     "id": 0,
>     "player_id": 4,
>     "date": "2023-01-02",
>     "result": true
>  }
>  ```
>- **DELETE**
>  ```json 
>  {
>     "id": 0
>  }
>  ```

>### ```/position```
>Endpoint for Position entity.
>#### Methods
>- **GET**

>### ```/contract```
>Endpoint for Contract entity.
>#### Methods
>- **GET**
