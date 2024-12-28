--[[ 
    Tic Tac Toe
    Author: Troy Revier
    Date: December 26, 2024

    This is my third attempt at making this, my last two were sadly lost to the void for various unfortunate events.
    Let's hope it fucking works :)

    Game Initialization
        Create the game board as a 3x3 array or a 1D array of 9 elements.
        Define player symbols (e.g., "X" for the player, "O" for the AI).
        Initialize variables to track the current turn and game state (ongoing, win, draw).

    Display the Board
        Write a function to print the game board to the console.
        Ensure the board updates and displays after each move.

    Player Input
        Write a function to handle player input:
            Prompt the player for a move (e.g., a number from 1–9).
            Validate that the input is within range and the cell is empty.
            Update the board with the player's symbol.

    AI Logic
        Write a function to determine the AI's move:
            Start with random moves on empty cells.
            Optional: Add logic to prioritize winning moves or block the player.
            Optional: Implement strategic moves (e.g., choose the center or corners).

    Game State Check
        Write a function to check for win conditions:
            Check rows, columns, and diagonals for three matching symbols.
        Write a function to check for a draw:
            Ensure all cells are filled and there's no winner.

    Game Loop
        Create a loop to alternate turns between the player and the AI:
            Display the board at the start of each turn.
            Check if the game has been won or is a draw.
            Execute the current turn's move (player input or AI logic).
            Switch turns.

    End Game
        Display a message indicating the winner or a draw.
        Offer an option to restart or exit the game.

    Optional Enhancements:
        Allow row/column input (e.g., A1, B2) for moves.

]]--

local gameBoard = {" "," "," "," "," "," "," "," "," "}

local winningCombos = {
    {1,2,3},
    {4,5,6},
    {7,8,9},
    {1,5,9},
    {3,5,7},
    {1,4,7},
    {2,5,8},
    {3,6,9}
}

local gameRunning = true
local gameOver = false
local gameWinner = nil
local gameDraw = false
local currentPlayer = nil
local moveNumber  = 1
local PLAYER_SYMBOL = "X"
local COMPUTER_SYMBOL = "O"

local function initGame()
    gameBoard = {" "," "," "," "," "," "," "," "," "}
    gameOver = false
    gameWinner = nil
    gameDraw = false
    currentPlayer = "player"
    moveNumber = 1
end

local function printBoard()
    local headerMessage = string.format("\n=== Tic Tac Toe ===\nCurrent Player: %s\n", gameWinner or currentPlayer or "Player")
    local boardMessage = string.format(
        " %s | %s | %s \n" ..
        "---|---|---\n" ..
        " %s | %s | %s \n" ..
        "---|---|---\n" ..
        " %s | %s | %s \n",
        gameBoard[1], gameBoard[2], gameBoard[3],
        gameBoard[4], gameBoard[5], gameBoard[6],
        gameBoard[7], gameBoard[8], gameBoard[9]
    )
    print(headerMessage)
    print(boardMessage)
end

local function promptInput()
    while true do
        print("Enter your move (1-9):")
        local input = io.read()
        local position = tonumber(input)

        if position and position >= 1 and position <= 9 then
            if gameBoard[position] == " " then
                return position
            else
                print("That cell is already occupied. Try again.")
            end
        else
            print("Invalid input. Please enter a number between 1 and 9.")
        end
    end
end

local function promptNewGame()
    while true do
        print("Would you like to play a new game? (y/n)")
        local input = io.read()
        local playerResponse = tostring(input)
        if playerResponse == "y" or playerResponse == "Y" then
            return true
        elseif playerResponse == "n" or playerResponse == "N" then
            gameRunning = false
            return false
        else
            print("Invalid input. Please enter y/n")
        end
    end
    
end

local function setBoardPosition(position)
    local currentSymbol = "#"
    if currentPlayer == "player" then 
        currentSymbol = PLAYER_SYMBOL
    else
        currentSymbol = COMPUTER_SYMBOL
    end

    if position and position >= 1 and position <= 9 then
        if gameBoard[position] == " " then
            gameBoard[position] = currentSymbol
            moveNumber = moveNumber + 1
        end
    end
end

local function isCellEmpty(cellToCheck)
    if gameBoard[cellToCheck] == " " then
        return true
    end
    return false
end

local function analyzeBoard()
    for key, combo in pairs(winningCombos) do
        local a, b, c = gameBoard[combo[1]], gameBoard[combo[2]], gameBoard[combo[3]]
        if a == b and a ~= " " and c == " " then
            return combo[3]
        elseif a == c and a ~= " " and b == " " then
            return combo[2]
        elseif b == c and b ~= " " and a == " " then
            return combo[1]
        end
    end

    return nil
end

--[[
    Essentially creates a better starting move for the computer 
    without weighting cells 1 or 9 over eachother
]]
local function randomOdd()
    local rand = 2
    while rand % 2 == 0 do
        rand = math.random(1,9)
    end
    return rand
end

local function chooseComputerMove()
    while true do
        local rand
        if moveNumber < 3 then
            rand = randomOdd() 
        else
            rand = math.random(1,9)
        end
        local position = analyzeBoard() or rand
        if position and position >= 1 and position <= 9 then
            if gameBoard[position] == " " then
                return position
            end
        end
    end
end

local function checkForDraw()
    if moveNumber > 9 then
        gameOver = true
        gameDraw = true
    end
end

local function checkForWin()
    if moveNumber < 4 then return false end --It's impossible to win before move 5, so let's skip checking
    for key, combo in pairs(winningCombos) do
        if gameBoard[combo[1]] == gameBoard[combo[2]] and gameBoard[combo[2]] == gameBoard[combo[3]] and gameBoard[combo[1]] ~= " " then
            gameOver = true
            gameWinner = currentPlayer
            return true
        end
    end
end

local function doNextMove()
    if currentPlayer == "player" then
        setBoardPosition(promptInput())
        checkForWin()
        checkForDraw()
        currentPlayer = "computer"
    else
        setBoardPosition(chooseComputerMove())
        checkForWin()
        checkForDraw()
        currentPlayer = "player"
    end
    printBoard()
end
while gameRunning do
    initGame()
    printBoard()
    while not gameOver do
        doNextMove()
    end
    if gameDraw then
        print("Game ended in a draw!")
    else
        print(string.format("%s won!",gameWinner))
    end
    promptNewGame()
end