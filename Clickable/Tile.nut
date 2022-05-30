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