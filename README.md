# Battleshift

#### Collaborators: JP Lynch and Angela Duran

### Summary
This project is a back end version of the game Battleship. It is hosted at https://battleshift19.herokuapp.com/.
This has been an assignment for Module 3 of the Back End Program at the Turing School for Software and Design.

In order to play a game, both users must register by visiting the home page and responding to the verification email.
All game requests to the api will require the users api key in the headers under X-API_Key: <your-api-key>

#### EndPoints:
`POST /api/v1/games` - player_1 creates a game by sending over their API key and player_2's email address. Both players should already exist in the system.  
`POST /api/v1/games/:game_id/ships` - Place a ship on the requesting player's board. Player is determined by the API key sent. Should only allow players who are part of this game.  
`POST /api/v1/games/:game_id/shots` - Send a target coordinate to fire upon the opponents board. Sender is determined by the API key that is sent over. Should only allow players who are part of this game. Should not allow a user to fire when it is not their turn.  
