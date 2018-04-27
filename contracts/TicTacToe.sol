pragma solidity ^0.4.17;

contract TicTacToe {
    address[2] public players;
    GameState public gameState;
    uint8[3][3] public board;

    enum GameState {
        NotStarted,
        Started,
        Cancelled,
        GameOver
    }

    address activePlayer; // contains the addres of the player who's turn it is

    event MoveMade (address byPlayer, uint8 x_coor, uint8 y_coor);
    event GameOver(address winner);

    modifier isPlayer() {
        require(msg.sender == players[0] || msg.sender == players[1]);
        _;
    }

    modifier isCreator() {
        require(msg.sender == players[0]);
        _;
    }

    modifier isActivePlayer() {
        require(msg.sender == activePlayer);
        _;
    }

    // test func
    function whoAmI() public view returns(address) {
        return msg.sender;
    }

    // Start a new game
    // The sender becomes player1
    function TicTacToe() public {
        players[0] = msg.sender;
        players[1] = 0;
        
        // initialize board values
        for(uint8 i = 0; i < 3; i++) {
            for (uint8 j = 0; j < 3; j++){
                board[i][j] = 0;
            }
        }

        gameState = GameState.NotStarted;
    }

    function getBoard() public view returns (uint8[3][3]) {
        return board;
    }

    function getPlayers() public view returns (address[2]) {
        return players;
    }

    // the first person to join the game becomes player 2
    function joinGame() public {
        // Can someone join?
        require(gameState == GameState.NotStarted);

        // Is there already a player2?
        require(players[1] == 0);

        // Don't play with yourself
        require(players[0] != msg.sender);        
        
        players[1] = msg.sender;
        activePlayer = players[0];
        gameState = GameState.Started;
    }

    // Cancel the game if it hasn't begun yet
    function cancelGameIfNotStarted() public isCreator {
        require(players[1] == 0);
        gameState = GameState.Cancelled;
    }

    // The board is a 3x3 board. Enter values between 
    // 0 and 2 for x_coor and y_coor, corresponding to
    // where you want to place your piece
    function makeMove(uint8 x_coor, uint8 y_coor) public isActivePlayer {
        require(gameState == GameState.Started);
        require(board[x_coor][y_coor] == 0);

        board[x_coor][y_coor] = getPlayerNumber();
        activePlayer = players[getPlayerNumber() % 2]; // get index of other player

        MoveMade(msg.sender, x_coor, y_coor);
    }

    function claimVictory() public isPlayer{
        require (haveIWon());
        
        gameState = GameState.GameOver;
        GameOver(msg.sender);
    }

    function getPlayerNumber() private view returns(uint8) {
        return msg.sender == players[0] ? 1 : 2;
    }

    function haveIWon() public view returns(bool) {
        return isPlayerVictorious(getPlayerNumber());
    }

    function isMyTurn() public view isPlayer returns(bool) {
        return activePlayer == msg.sender;
    }

    function isPlayerVictorious(uint8 playerNum) private view returns(bool) {

        if (board[0][0] == playerNum) {
            if (board[0][1] == playerNum && 
                board[0][2] == playerNum) {
                
                return true;
            }

            if (board[1][0] == playerNum && 
                board[2][0] == playerNum) {
                
                return true;
            }

            if (board[1][1] == playerNum &&
                board[2][2] == playerNum){

                return true;
            }
        }

        if (board[0][2] == playerNum)

        // check rows
        for (uint8 x = 0; x < 3; x++) {
            if (board[x][0] == playerNum){
                if (board[x][1] == playerNum && 
                    board[x][2] == playerNum) {
                        return true;
                }
            }
        }

        // check columns
        for (uint8 y = 0; y < 3; y++) {
            if (board[0][y] == playerNum){
                if (board[1][y] == playerNum && 
                    board[2][y] == playerNum) {
                        return true;
                }
            }
        }

        // check diagonal
        bool matchFound = true;
        for (uint8 i = 0; i < 3; i++) {
            if (board[i][i] != playerNum) {
                matchFound = false;
                break;
            }
        }
        if (matchFound) return true;

        // check the other diagonal
        matchFound = false;
        for (i = 0; i < 3; i++) {
            if (board[i][2-i] != playerNum) {
                matchFound = false;
                break;
            }
        }

        return matchFound;
    }
}