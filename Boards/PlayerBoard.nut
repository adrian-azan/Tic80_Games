class PlayerBoard extends Grid
{
    focus = null
    addPlayer = null
    randomize = null
    colors = null

    constructor()
    {
        base.constructor(1,1)
        size += 2
        nodes[0].data = Player(185,12,[50,10],"TEMP",MINCOLR)
        focus = nodes[0]

        addPlayer = Node()
        addPlayer.data = AddPlayer([16,16],0,this)

        randomize = Node()
        randomize.data = Randomize(0,0,[16,16],2)


        addPlayer.b = nodes[0]
        addPlayer.t = nodes[0]
        addPlayer.r = randomize

        randomize.b = nodes[0]
        randomize.t = nodes[0]
        randomize.l = addPlayer

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
        randomize.t = end

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
        focus.data.A(colors,vargv[0])
    }

    function B(...)
    {
        focus.data.B(this)
    }

    function Y(...)
    {
        focus.data.Y(vargv[0])
    }

    function PopPlayer(target)
    {
        local current = nodes[0].b
        while(current != addPlayer)
        {
            if (current.data == target)
            {
                current.t.b = current.b
                current.b.t = current.t

                focus = current.t
                colors[current.data.color] = true
                size -= 1
                break
            }
            current = current.b
        }

        while(current != addPlayer)
        {
            current.data.y -= 12
            current = current.b
        }
    }

    function Move()
    {
        addPlayer.data.x = addPlayer.t.data.x
        addPlayer.data.y = addPlayer.t.data.y + 20

        randomize.data.x = addPlayer.data.x + 20
        randomize.data.y = addPlayer.data.y
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