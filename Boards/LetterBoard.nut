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