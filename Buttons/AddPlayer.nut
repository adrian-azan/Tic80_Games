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