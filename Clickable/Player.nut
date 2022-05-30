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