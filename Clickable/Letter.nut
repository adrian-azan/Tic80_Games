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