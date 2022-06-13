class Digit
{
    value = null
    X = null
    Y = null
    constructor(x, y)
    {
        value = 0
        X = x
        Y = y
    }

    function Add()
    {
        value++
        value %= 10
    }

    function Sub()
    {
        value--
        if (value < 0)
            value = 9
    }

    function Draw()
    {
        print(value,X,Y,11)
    }

    function DrawH()
    {
        print(value,X,Y,4)
    }
}