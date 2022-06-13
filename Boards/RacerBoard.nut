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

    function RandomBoard()
    {
        for (local i = 0; i < 500; i ++)
        {
            local sourceRow = rand() % racerNames.len()
            local sourceCol = rand() % racerNames[sourceRow].len()

            local targetRow = rand() % racerNames.len()
            local targetCol = rand() % racerNames[targetRow].len()

            local temp = racerNames[targetRow][targetCol]
            racerNames[targetRow][targetCol] = racerNames[sourceRow][sourceCol]
            racerNames[sourceRow][sourceCol] = temp
        }

        Rename()
    }

    function Rename()
    {
        local current = null
        for (local r=0; r < 6; r++)
        {
            current = nodes[r]
            for (local c=0; c < 7;c++)
            {
                current.data.text = racerNames[r][c]
                current = current.r
            }
        }
    }

    function Draw(focused = true)
    {
        Rename()
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