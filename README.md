# TicTacToeDapp
Simple Dapp to let two people play tic tac toe

One person sets up a game by deploying the contract and waiting for someone to join.

Any player can join the game by calling joinGame()

Players then take turns placing their piece on the game board by sending in the x,y coordinate corresponding to the square they wish to claim (where 0<=x,y<=2)

When a player wins he can call claimVictory() to claim the win. In the case of a draw claimDraw() can be called instead.

(This is a HW Assigment for TheSchool.ai)
