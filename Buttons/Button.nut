class Button extends Clickable
{
    sprite = null
    constructor(xpos,ypos,s,sp)
    {
        base.constructor(xpos,ypos,s)
        sprite=sp
    }

    function Draw()
    {
        spr(sprite,x,y,-1,1,0,0,size[0]/8,size[1]/8)
    }

    function DrawH()
    {
        spr(sprite+size[1]*2,x,y,-1,1,0,0,size[0]/8,size[1]/8)
    }
}