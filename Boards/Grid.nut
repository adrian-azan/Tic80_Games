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