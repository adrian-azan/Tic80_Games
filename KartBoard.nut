// title:   game title
// author:  game developer, email, etc.
// desc:    short description
// site:    website link
// license: MIT License (change this to your license of choice)
// version: 0.1
// script:  squirrel


/*###################################
#                                   #
#   GLOBALS                         #
#                                   #
###################################*/
local BCKGRND = 11
local BRDCOLR = 13
local MINCOLR = 1

local clicked = null
local playerHead = null
local racerNames = null
local players = null
local letterBoard = null


local STATE = 0
local CONTROLLER = null
local GAME = null


racerNames = array(6)
racerNames[0] = ["MAR","LUI","PEA","DAI",
            "ROS","TAR","TEA"]
racerNames[1] = ["YOS","TOA","KOO","SHY",
            "LAK","TDE","BOO"]
racerNames[2] = ["BAR","BUI","BEA","BAI",
            "BOS","MMA","MPE"]
racerNames[3] = ["WAR","WAL","DON","BOW",
            "DRY","BJR","DBO"]
racerNames[4] = ["LEM","LAR","WEN","LUD",
            "IGG","ROY","MOR"]
racerNames[5] = ["SQG","SQB","LNK","VIB",
            "VIG","ISA","MII"]



/*###################################
#                                   #
#   FUNCTIONS                       #
#                                   #
###################################*/
function clamp(x,min,max)
{
    if (x < min)
        return min
    if (x >= max)
        return min
    return x
}


include("Clickable.Clickable")
include("Clickable.Letter")
include("Clickable.Player")
include("Clickable.Tile")

include("Buttons.Button")
include("Buttons.AddPlayer")


include("Boards.Grid")
include("Boards.LetterBoard")
include("Boards.PlayerBoard")
include("Boards.RacerBoard")





class Controller
{
    function Input(id)
    {
        if (clicked == true)
            return false

        local md = mouse()
        local hover = false//md[0] > x && md[0] < x+size[0] && md[1] > y && md[1] < y+size[1]
        local gamePad = (btnp(id,120,30) && focus == true)

        //A
        if ( id == 4 && ((md[2] == true && hover) || gamePad))
            return true

        //X
        if ( id == 6 && ((md[3] == true && hover) || gamePad))
            return true

        //B
        if ( id == 5 && ((md[4] == true && hover)  || gamePad))
            return true

        //UP
        if ( id == 0 && ( key(58+id)  || btnp(id,120,10) ))
            return true
        //DOWN
        if ( id == 1 && ( key(58+id)  || btnp(id,120,30) ))
            return true
        //LEFT
        if ( id == 2 && ( key(58+id)  || btnp(id,120,30) ))
            return true
        //RIGHT
        if ( id == 3 && ( key(58+id)  || btnp(id,120,30) ))
            return true
        return false
    }
}




class Game
{
    players = null
    letters = null
    board = null
    focus = null
    constructor()
    {
        players = PlayerBoard()
        letters = LetterBoard()
        board = RacerBoard()

        focus = players
        players.Push()
    }

    function Draw()
    {
        if (STATE == 0)
        { 
            players.CalcPoints(board)
            players.Draw(true)
            board.Draw(board == focus)
        }

        if (STATE == 1)
        {
            letters.Draw()
        }
    }

    function UPDATE()
    {
        if (btnp(0,30,15))
        {
            focus.Asc()
        }

        if (btnp(1,30,15))
        {
            focus.Des()
        }

        if (btnp(2,30,15))
        {
            focus.Prev()
        }

        if (btnp(3,30,15))
        {
            focus.Next()
        }

        if (btnp(4))
        {            
            focus.A(board,players)
        }

        if (btnp(5))
        {
            focus.B()
        }

        if (btnp(7))
        {
            if (focus == players)
            {
                focus = letters
                letters.name = players.focus.data.text
                STATE = 1
            }

            else if (focus == letters)
            {
                focus = players
                players.focus.data.text = letters.name
                STATE = 0
            }
        }

        if (btnp(6))
        {
            if (focus == players)
            {
                focus = board
            }
            else if (focus == board)
            {
                focus = players
            }
        }
    }
}



GAME = Game()

function TIC()
{
    cls(BCKGRND)

    GAME.UPDATE()
    GAME.Draw()
 
}



// <TILES>
// 000:ffffffffffffffffff000000ff000006ff000006ff000006ff000006ff066666
// 001:ffffffffffffffff000000ff600000ff600000ff600000ff600000ff666660ff
// 002:ffffffffffffffffff000000ff000000ff000000ff000000ff000000ff000000
// 003:ffffffffffffffff000000ff000000ff000000ff000000ff000000ff000000ff
// 016:ff066666ff000006ff000006ff000006ff000006ff000000ffffffffffffffff
// 017:666660ff600000ff600000ff600000ff600000ff000000ffffffffffffffffff
// 018:ff000000ff000000ff066006ff066006ff000000ff000000ffffffffffffffff
// 019:000000ff000000ff600660ff600660ff000000ff000000ffffffffffffffffff
// 032:eeeeeeeeeeeeeeeeee000000ee000006ee000006ee000006ee000006ee066666
// 033:eeeeeeeeeeeeeeee000000ee600000ee600000ee600000ee600000ee666660ee
// 034:eeeeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000
// 035:eeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000ee
// 048:ee066666ee000006ee000006ee000006ee000006ee000000eeeeeeeeeeeeeeee
// 049:666660ee600000ee600000ee600000ee600000ee000000eeeeeeeeeeeeeeeeee
// 050:ee000000ee000000ee066006ee066006ee000000ee000000eeeeeeeeeeeeeeee
// 051:000000ee000000ee600660ee600660ee000000ee000000eeeeeeeeeeeeeeeeee
// </TILES>

// <PALETTE>
// 000:16171a7f0622d62411ff8426ffd100fafdffff80a4ff267494216a43006723497568aed4bfff3c10d275007899002859
// </PALETTE>

