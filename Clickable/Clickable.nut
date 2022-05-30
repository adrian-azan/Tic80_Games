class Clickable
{
    size = null
    x = null
    y = null

    /*
        size - array of width and height
    */
    constructor(xpos,ypos,s)
    {
        x=xpos
        y=ypos
        size = s
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


    /*
      Return: 0,1,2,3
      0: No mouse click
      1: Left mouse click
      2: Middle mouse click
      3: Right mouse click
    */
    function Clicked(id)
    {
        return CONTROLLER.Input(id)
    }
}