class Confirmation extends Grid
{
    X = null
    Y = null
    constructor()
    {
        base.constructor(4,1)
        X = 20
        Y = 20
        size = 5
        nodes.top().r = Node()

        nodes[0].b = nodes[1]
        nodes[1].b = nodes[2]
        nodes[2].b = nodes.top()


        nodes[1].t = nodes[0]
        nodes[2].t = nodes[1]
        nodes.top().t = nodes[2]


        nodes[0].data = Digit(X+8,Y+10)
        nodes[1].data = Digit(X+8,Y+18)
        nodes[2].data = Digit(X+8,Y+26)

        nodes.top().data = Button(X+2,Y+34,[16,8],64)
        nodes.top().r.data = Button(X+22, Y+34,[16,8],66)
        nodes.top().r.l = nodes.top()
    }

    function Next()
    {
        base.Next()
        if (focus.data.getclass() == Digit)
            focus.data.Add()
    }

    function Prev()
    {
        base.Prev()
        if (focus.data.getclass() == Digit)
            focus.data.Sub()
    }

    function A(...)
    {
        if (focus == nodes.top())
        {
            local seed = nodes[0].data.value * 100
            seed += nodes[1].data.value * 10
            seed += nodes[2].data.value
            srand(seed)
            vargv[0].RandomBoard()
            STATE = 0
        }

        if (focus == nodes.top().r)
        {
            STATE = 0
        }
    }

    function Draw()
    {
        rect(X,Y,40,50,15)
        print("SEED:"X+2,Y+2,4)
        base.Draw()
    }

}