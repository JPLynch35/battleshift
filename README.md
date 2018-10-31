# Battleshift

### Summary
This project is a back end API for the game Battleship.
A version of this API was already created as a player vs computer game, our aim was to create a player vs player version.

In order to play, both users must register by visiting the home page and clicking on the link in the verification email.
All game requests to the api will require the user's api key in the headers under X-API_Key: <your-api-key>

### Production Site (Back End API)
[https://battleshift19.herokuapp.com/](https://battleshift19.herokuapp.com/)

### EndPoints:
`POST /api/v1/games` - player_1 creates a game by sending over their API key and player_2's email address. Both players should already exist in the system.  
`POST /api/v1/games/:game_id/ships` - Place a ship on the requesting player's board. Player is determined by the API key sent. Should only allow players who are part of this game.  
`POST /api/v1/games/:game_id/shots` - Send a target coordinate to fire upon the opponents board. Sender is determined by the API key that is sent over. Should only allow players who are part of this game. Should not allow a user to fire when it is not their turn.  

### Collaborators:
* [JP Lynch](https://github.com/JPLynch35)
* [Angela Duran](https://github.com/duranangela)
