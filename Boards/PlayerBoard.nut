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