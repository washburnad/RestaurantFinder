# RestaurantFinder

A simple restaurant finder api that wraps around google restaurant search.

## Installation

Pull the latest image from Docker Hub and run.

```
docker pull washburnad/restaurant-finder:latest
docker run -dp 3000:3000 washburnad/restaurant-finder:latest
```

## Usage

- obtain an `API-key` for api access
- make a request to create a user

```
curl --location -g --request POST 'http://localhost:3000/users?user[email]=firt.last@example.com&user[password]=password&user[password_confirmation]=password' \
--header 'API-key: api-key'
```

- search by latitude & longitude (required) and keyword (optional)

```
curl --location --request POST 'http://localhost:3000/search' \
--header 'Content-Type: application/json' \
--header 'API-Key: api-key' \
--header 'Authorization: Basic user-auth' \
--data-raw '{
    "keyword": "ashmont",
    "latitude": 42.28,
    "longitude": -71.07
}'
```

response is an array of google restaurant search results with an added boolean field to note `user_favorite`

```
[
  {
    "business_status"=>"OPERATIONAL",
    "geometry"=> {
      "location"=> {
        "lat"=>42.2860648, 
        "lng"=>-71.0647658
      },
      "viewport"=> {
        ...
      },
    "place_id"=>"ChIJrdK_zI9744kRTIhS6ZqbSQQ",
...
    "user_favorite": false
  },
  ...
]
```

- add a user favorite by posting the `place_id` along with the user basic auth credentials

```
curl --location --request POST 'http://localhost:3000/favorites' \
--header 'Content-Type: application/json' \
--header 'API-Key: api-key' \
--header 'Authorization: Basic user-auth' \
--data-raw '{
    "place_id": "ChIJrdK_zI9744kRTIhS6ZqbSQQ"
}'


```

- remove user favorite by deleting the `place_id`

```
curl --location --request DELETE 'http://localhost:3000/favorites/ChIJrdK_zI9744kRTIhS6ZqbSQQ' \
--header 'Content-Type: application/json' \
--header 'API-Key: api-key' \
--header 'Authorization: Basic user-auth'
```