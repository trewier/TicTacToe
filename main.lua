--[[ 
    Tic Tac Toe
    Author: Troy Revier
    Date: December 26, 2024

    This is my third attempt at making this, my last two were sadly lost to the void for various unfortunate events.
    Let's hope it fucking works :)

    12/28/24 - settling on this for my end version, not seeing much left to fix or improve

]]--

local PLAYER = "X"
local COMPUTER = "O"
local EMPTY = " "

local board = {EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY}
local WINNING_COMBOS = {
    {1, 2, 3}, {4, 5, 6}, {7, 8, 9}, -- Rows
    {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, -- Columns
    {1, 5, 9}, {3, 5, 7}             -- Diagonals
}

local gameRunning = true

local function printBoard()
    for i = 1, 9, 3 do
        print(string.format(" %s | %s | %s ", board[i], board[i + 1], board[i + 2]))
        if i < 7 then print("---+---+---") end
    end
end

local function getEmptyCells()
    local emptyCells = {}
    for i, cell in ipairs(board) do
        if cell == EMPTY then
            table.insert(emptyCells, i)
        end
    end
    return emptyCells
end

local function isWinningCombo(combo, symbol)
    for _, index in ipairs(combo) do
        if board[index] ~= symbol then return false end
    end
    return true
end

local function checkForWin(symbol)
    for _, combo in ipairs(WINNING_COMBOS) do
        if isWinningCombo(combo, symbol) then
            return true
        end
    end
    return false
end

local function checkForDraw()
    return #getEmptyCells() == 0
end

local function setBoardPosition(position, symbol)
    if board[position] == EMPTY then
        board[position] = symbol
        return true
    end
    return false
end

local function analyzeBoard(symbol)
    for _, combo in ipairs(WINNING_COMBOS) do
        local count = 0
        local emptyIndex = nil
        for _, index in ipairs(combo) do
            if board[index] == symbol then
                count = count + 1
            elseif board[index] == EMPTY then
                emptyIndex = index
            end
        end
        if count == 2 and emptyIndex then
            return emptyIndex
        end
    end
    return nil
end

local function chooseComputerMove()
    local move = analyzeBoard(COMPUTER)
    if move then return move end

    move = analyzeBoard(PLAYER)
    if move then return move end
    --[[
    Removing because it makes gameplay identical each game, ensures a draw

    if board[5] == EMPTY then return 5 end

    local corners = {1, 3, 7, 9}
    for _, corner in ipairs(corners) do
        if board[corner] == EMPTY then return corner end
    end
    ]]
    local oddCells = {1,3,5,7,9}
    for _, cell in ipairs(oddCells) do
        if board[cell] == EMPTY then return cell end
    end

    local emptyCells = getEmptyCells()
    if #emptyCells > 0 then
        return emptyCells[1]
    end
    return nil
end

local function playerTurn()
    while true do
        io.write("Enter your move (1-9): ")
        local input = tonumber(io.read())
        if input and input >= 1 and input <= 9 and setBoardPosition(input, PLAYER) then
            break
        end
        print("Invalid move. Try again.")
    end
end

local function computerTurn()
    local move = chooseComputerMove()
    if move then
        setBoardPosition(move, COMPUTER)
    end
end

local function playGame()
    print("=== Tic Tac Toe ===")
    while true do
        printBoard()
        playerTurn()
        if checkForWin(PLAYER) then
            printBoard()
            print("Congratulations! You win!")
            break
        elseif checkForDraw() then
            printBoard()
            print("It's a draw!")
            break
        end

        computerTurn()
        if checkForWin(COMPUTER) then
            printBoard()
            print("Computer wins! Better luck next time.")
            break
        elseif checkForDraw() then
            printBoard()
            print("It's a draw!")
            break
        end
    end
end

local function promptNewGame()
    while true do
        io.write("Would you like to play a new game? (y/n)")
        local input = tostring(io.read())
        if input then
            if string.upper(input) == "Y" then
                board = {EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY}
                playGame()
            elseif string.upper(input) == "N" then
                gameRunning = false
            end
        end
        print("Invalid input.")
    end
end

playGame()
while gameRunning do
    promptNewGame()
end