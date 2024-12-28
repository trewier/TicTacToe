--[[ 
    Tic Tac Toe
    Author: Troy Revier
    Date: December 26, 2024

    This is my third attempt at making this, my last two were sadly lost to the void for various unfortunate events.
    Let's hope it fucking works :)

    12/28/2024 - It works, time for some refactoring.

    REFACTOR TODO: 
        Cleanup redundant variables
        Print board
        Would like to cleanup game loop
]]--
local gameRunning = true
local gameOver = false
local gameWinner = nil
local gameDraw = false
local currentPlayer = nil
local moveNumber  = 1
local PLAYER = "X"
local COMPUTER = "O"
local EMPTY = " "

local gameBoard = {}

local winningCombos = {
    {1,2,3},{4,5,6},{7,8,9}, --Rows
    {1,4,7},{2,5,8},{3,6,9}, --Columns
    {1,5,9},{3,5,7}          --Diagonals
}


local function initGame()
    gameBoard = {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY}
    gameOver = false
    gameWinner = nil
    gameDraw = false
    currentPlayer = "player"
    moveNumber = 1
end

local function getCurrentSymbol()
    if currentPlayer == "player" then
        return PLAYER
    else
        return COMPUTER
    end
end

local function printBoard()
    local headerMessage = "\n=== Tic Tac Toe ===\n"

    for key, value in pairs(gameBoard) do
        
    end

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
            if gameBoard[position] == EMPTY then
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
    local currentSymbol = getCurrentSymbol()
    if position and position >= 1 and position <= 9 then
        if gameBoard[position] == EMPTY then
            gameBoard[position] = currentSymbol
            moveNumber = moveNumber + 1
        end
    end
end

local function isCellEmpty(cellToCheck)
    if gameBoard[cellToCheck] == EMPTY then
        return true
    end
    return false
end

local function analyzeBoard()
    local winningMoves = {}
    local blockingMoves = {}
    for key, combo in pairs(winningCombos) do
        local a, b, c = gameBoard[combo[1]], gameBoard[combo[2]], gameBoard[combo[3]]
        if a == b and a ~= EMPTY and c == EMPTY then
            if a == getCurrentSymbol() then
                table.insert(winningMoves,combo[3])
            else
                table.insert(blockingMoves,combo[3])
            end
        elseif a == c and a ~= EMPTY and b == EMPTY then
            if a == getCurrentSymbol() then
                table.insert(winningMoves,combo[2])
            else
                table.insert(blockingMoves,combo[2])
            end
        elseif b == c and b ~= EMPTY and a == EMPTY then
            if b == getCurrentSymbol() then
                table.insert(winningMoves,combo[1])
            else
                table.insert(blockingMoves,combo[1])
            end
        end
    end

    if #winningMoves > 1 then
        return winningMoves[1]
    else
        return blockingMoves[1]
    end

    return nil
end

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
            if gameBoard[position] == EMPTY then
                return position
            end
        end
    end
end

local function checkForDraw()
    local tableFull = true
    for key, cell in pairs(gameBoard) do
        if cell == EMPTY then
            tableFull = false
        end
    end
    --TODO We could refactor this into a function that ends the game for us, save some lines over multiple functions
    if tableFull then
        gameDraw = true
        gameOver = true
    end
    return tableFull
end

local function checkForWin()
    if moveNumber < 4 then return false end --It's impossible to win before move 5, so let's skip checking
    for key, combo in pairs(winningCombos) do
        if gameBoard[combo[1]] == gameBoard[combo[2]] and gameBoard[combo[2]] == gameBoard[combo[3]] and gameBoard[combo[1]] ~= EMPTY then
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