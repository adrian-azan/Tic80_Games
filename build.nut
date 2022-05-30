//
// Bundle file
// Code changes will be overwritten
//

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


// [included Clickable.Clickable]

class Clickable
{
    size = null
    x = null
    y = null

    /*
        size - array of width and height
    */
    constructor(xpos,ypos,s)
    {
        x=xpos
        y=ypos
        size = s
    }

    function A(...)
    {
        return null
    }

    function B(...)
    {
        return null
    }

    function X(...)
    {
        return null
    }

    function Y(...)
    {
        return null
    }


    /*
      Return: 0,1,2,3
      0: No mouse click
      1: Left mouse click
      2: Middle mouse click
      3: Right mouse click
    */
    function Clicked(id)
    {
        return CONTROLLER.Input(id)
    }
}
// [/included Clickable.Clickable]
// [included Clickable.Letter]

class Letter extends Clickable
{
    text = null
    constructor(xpos, ypos,t,s)
    {
        base.constructor(xpos,ypos,s)
        text = t
    }

    function Draw()
    {
        print(text,x,y,0)
    }

    function DrawH()
    {
        print(text,x,y,4)
    }

    function A(...)
    {
        return text
    }
}
// [/included Clickable.Letter]
// [included Clickable.Player]

class Player extends Clickable
{
    text = null
    color = null

    points = null
    rename = null

    constructor(xpos,ypos,s,t,c)
    {
        base.constructor(xpos,ypos,s)
        text = t
        color = c

        points = 0
        rename = false
    }

    function A(...)
    {        
        vargv[0][color] = true

        color = clamp(color+1, MINCOLR, 16)
        while (vargv[0][color] == false)
            color = clamp(color+1, MINCOLR, 16)

        vargv[0][color] = false
    }

    function Y(...)
    {
        STATE = 1
    }

    function Draw()
    {
        rectb(x,y,size[0],size[1],color)
        print(text+": "+points,x+2,y+size[1]/3,0)
    }

    function DrawH()
    {
        rect(x,y,size[0],size[1],color)
        print(text+": "+points,x+2,y+size[1]/3,0)
    }   
}
// [/included Clickable.Player]
// [included Clickable.Tile]

class Tile extends Clickable
{
    text = null
    color = null
    owner = null

    constructor(xpos,ypos,s,t)
    {
        base.constructor(xpos,ypos,s)
        text = t
        color = BRDCOLR
    }

    function Draw()
    {
        if(owner != null)
            rect(x,y,size[0],size[1],owner.color)
        else
            rect(x,y,size[0],size[1],color)
        print(text,x+(size[0]/6),y+(size[1]/3),0)
    }

    function DrawH()
    {
        Draw()
        rectb(x-1,y-1,size[0]+2,size[1]+2,4)
    }    
}
// [/included Clickable.Tile]

// [included Buttons.Button]

class Button extends Clickable
{
    sprite = null
    constructor(xpos,ypos,s,sp)
    {
        base.constructor(xpos,ypos,s)
        sprite=sp
    }

    function Draw()
    {
        spr(sprite,x,y,-1,1,0,0,size[0]/8,size[1]/8)
    }

    function DrawH()
    {
        spr(sprite+32,x,y,-1,1,0,0,size[0]/8,size[1]/8)
    }
}
// [/included Buttons.Button]
// [included Buttons.AddPlayer]

class AddPlayer extends Button
{
    players = null
    constructor(s,sp,p)
    {
        base.constructor(0,0,s,sp)
        players = p
    }

    function A(...)
    {
        players.Push()
    }

    function B(...)
    {
        players.Pop()
    }

    function Draw()
    {
        base.Draw()
    }       

    function DrawH()
    {
        base.DrawH()
        
        print("A: Add",x,y+size[1]+2)
        print("B: Remove",x,y+size[1]+10)
    }
    
}
// [/included Buttons.AddPlayer]


// [included Boards.Grid]

class Node
{
    t = null
    b = null
    r = null
    l = null
    touched = null
    data = null

    constructor()
    {
        t = null
        b = null
        r = null
        l = null
        touched = false
        data = null
    }
}

class Grid
{
    nodes = null
    focus = null
    size = null

    constructor()
    {
        nodes = []
        focus = null
        size = 0
    }

    constructor(rows,cols)
    {
        size = 0
        nodes = array(rows)

        local current;
        for (local r = 0; r < rows; r++ )
        {
            nodes[r] = Node()
            size += 1
            current = nodes[r]
            for (local c = 0; c < cols-1; c++ )
            {
                current.r = Node()
                size += 1
                current.r.l = current
                current = current.r
            }
        }

        focus = nodes[0]
    }

    function Draw(focused = true)
    {
        local original = size
        DrawHelp(nodes[0],focused)
        size = original
    }

  

    function DrawHelp(current,focused)
    {
        if (size == 0 || current == null || current.data == null || current.touched == true)
            return null

        if (current == focus && focused)
            current.data.DrawH()
        else
            current.data.Draw()

        current.touched = true
        size -= 1
        DrawHelp(current.t,focused)
        DrawHelp(current.r,focused)
        DrawHelp(current.b,focused)
        DrawHelp(current.l,focused)
        current.touched = false
    }   

    function A(...)
    {
        return null
    }

    function B(...)
    {
        return null
    }

    function X(...)
    {
        return null
    }

    function Y(...)
    {
        return null
    }

    function Des()
    {
        if (focus.b != null)
            focus = focus.b
    }

    function Asc()
    {
        if (focus.t != null)
            focus = focus.t
    }

     function Next()
    {
        if (focus.r != null)
            focus = focus.r
    }
    
    function Prev()
    {
        if (focus.l != null)
           focus = focus.l
    }
}
// [/included Boards.Grid]
// [included Boards.LetterBoard]

class LetterBoard extends Grid
{
    name = null

    constructor()
    {
        local height = 6
        local width = 5
        local letter = 65

        base.constructor(height,width)        
        name = ""

        //Setup letters A-Z
        for (local r = 0; r < height; r++)
        {
            local current = nodes[r]
            for (local c = 0; current.r != null; c++)
            {
                current.data = Letter((c+1)*8,(r+1)*10,letter.tochar(),[5,5])
                current = current.r
                letter++
            }

            current.data = Letter((width)*8,(r+1)*10,letter.tochar(),[5,5])
            current.r = nodes[r]
            nodes[r].l = current

            letter++
        }


        //Set up symbols, return and backspace
        local r = height
        local b = nodes.top()

        b = b.r
        b.data = Letter(2*8,10*r,"!",[5,5])

        b = b.r
        b.data = Letter(3*8,10*r,"#",[5,5])

        b = b.r
        b.data = Letter(4*8,10*r,"$",[5,5])

        b = b.r
        b.data = Letter(5*8,10*r,"*",[5,5])

        b.r = Node()
        b.r.l = b
        b = b.r
        b.data = Letter(55,10*r,"<-",[10,5])

        b.r = Node()
        b.r.l = b
        b = b.r
        b.data = Letter(70,10*r,"Enter",[25,5])

        b.r = nodes.top()
        nodes.top().l = b

        size += 2

        //Setup top and bottom connections between rows
        for (local r = 1; r < height; r++ )
        {
           local above = nodes[r-1]
           local current = nodes[r]
            for (local c = 0; c < width; c++ )
            {
                above.b = current
                current.t = above

                above = above.r
                current = current.r
            }
        }

        //Setup for top and bottom row wrapping up and down
        local above = nodes[0]
        local current = nodes.top()
        for (local c = 0; c < width; c++ )
        {
            above.t = current
            current.b = above

            above = above.r
            current = current.r
        }
    }

    function A(...)
    {
        local result = focus.data.A()

        if (result == "<-" && name.len() > 0)
            name = name.slice(0,-1)
        else if (result == "Enter")
            trace("Entered")
        else if (name.len() <= 5 && result != "<-")
            name += focus.data.A()
    }

    function B(...)
    {
        if (name.len() > 0)
            name = name.slice(0,-1)
    }

    function Draw(focused = true)
    {
        base.Draw(focused)

        local x = nodes.top().data.x
        local y = nodes.top().data.y

        local enter = nodes.top().l.data
        local back = nodes.top().l.l.data

        print(name,x,y+10)
        print("Y",enter.x+enter.size[0]/2, y-enter.size[1]-2,1)
        print("B",back.x+back.size[0]/2, y-back.size[1]-2,1)
    }
}
// [/included Boards.LetterBoard]
// [included Boards.PlayerBoard]

class PlayerBoard extends Grid
{
    focus = null
    addPlayer = null    
    colors = null

    constructor()
    {
        base.constructor(1,1)
        size += 2
        nodes[0].data = Player(185,12,[50,10],"TEMP",MINCOLR)
        focus = nodes[0]

        addPlayer = Node()
        
        addPlayer.data = AddPlayer([16,16],0,this)      

   
        addPlayer.b = nodes[0]
        addPlayer.t = nodes[0]
      
        nodes[0].t = addPlayer
        nodes[0].b = addPlayer


        colors = {}
        for (local i = 1; i < 16; i++)
        {
            colors[i] <- true
        }

        colors[11] = false
        colors[13] = false
        nodes[0].data.A(colors)
    }

    function Draw(focused = true)
    {
        Move()
        base.Draw(focused)
    }

    function Push()
    {
        if (size >= 11)
            return null
            
        local end = addPlayer.t
        end.b = Node()
        end.b.t = end;

        end = end.b
        end.b = addPlayer

        addPlayer.t = end       

        end.data = Player(end.t.data.x,end.t.data.y+12,[50,10],"TEMP",MINCOLR)
        end.data.A(colors)

        size += 1
    }

    function Pop()
    {
        if (nodes[0].b == addPlayer)
            return null

        local end = addPlayer.t
        end.t.b = addPlayer
        addPlayer.t = end.t
 
        colors[end.data.color] = true

        end = null

        size -= 1
    }

    function A(...)
    {       
        focus.data.A(colors)
    }

    function B(...)
    {
        focus.data.B()
    }

    function Y(...)
    {
        focus.data.Y()
    }

    function Move()
    {
        addPlayer.data.x = addPlayer.t.data.x
        addPlayer.data.y = addPlayer.t.data.y + 20      
    }

    function CalcPoints(board)
    {
        local player = nodes[0]
        local racer = null
        trace(board.nodes.len())
        while (player != nodes[0].t)
        {
       
            player.data.points = 0
            for (local r = 0; r < board.nodes.len(); r++)
            {
                //start off at second racer in row
                racer = board.nodes[r].r
              
                while(racer != null && racer != board.nodes[r])
                {
                    
                    if (player.data == racer.data.owner)
                       player.data.points += 1
                    racer = racer.r
                }
            }
            player = player.b
        }
    }
}
// [/included Boards.PlayerBoard]
// [included Boards.RacerBoard]

class RacerBoard extends Grid
{
    constructor()
    {
        base.constructor(6,7)

        local height = 6
        local width = 7

        local current = null
        for (local r=0; r < 6; r++)
        {
            current = nodes[r]
            for (local c=0; c < 7;c++)
            {
                local size = [25,20]
                local buffx = size[0]+1
                local buffy = size[1]+1
                current.data = Tile(2+c*buffx,2+r*buffy,size,racerNames[r][c])
                current = current.r
            }
        }

         for (local r = 1; r < height; r++ )
        {
           local above = nodes[r-1]
           local current = nodes[r]
            for (local c = 0; c < width; c++ )
            {
                above.b = current
                current.t = above

                above = above.r
                current = current.r
            }
        }

        //Setup for top and bottom row wrapping up and down
        local above = nodes[0]
        local current = nodes.top()
        for (local c = 0; c < width; c++ )
        {
            above.t = current
            current.b = above

            above = above.r
            current = current.r
        }
    }

    function Draw(focused = true)
    {
        base.Draw(focused)
    }

    function A(...)
    {
        local playerFocus = vargv[1].focus.data
        if (playerFocus.getclass() == Player)
            focus.data.owner = playerFocus
    }

    function B(...)
    {
        focus.data.owner = null
    }
}
// [/included Boards.RacerBoard]





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

