module roman_numerals;
import std.string;
import std.stdio;
import std.conv;

package
{
    const romanFives = "VLD", romanUnits = "IXCM";
    
    auto buildRomanUnits(int num, int level)
    {
        string result;
        
        for (int i; i < num; ++i)
            result ~= romanUnits[level];
            
        return result;
    }
    
    auto buildRomanNumerals(int num, int level)
    {
        switch (num)
        {
            case 0: return "";
            case 9: return romanUnits[level].to!string ~ romanUnits[level + 1].to!string;
            case 5: return romanFives[level].to!string;
            case 4: return romanUnits[level].to!string ~ romanFives[level].to!string;
            
            default:
                
                if (num > 5)
                    return romanFives[level] ~ buildRomanUnits(num - 5, level);
                    
                return buildRomanUnits(num, level);
        }
    }
}

auto toRoman(int num, bool isLowerCase = false)
{
    string result;

    if (num > 3999 || num < 0) result = "?";
    else if (num == 0) result = "NULLA";

    else
    {
        auto numStr = num.to!string.split(""), index = 0;
        
        if (num >= 1000)
            result ~= buildRomanNumerals(numStr[index++].to!int, 3);

        if (num >= 100)
            result ~= buildRomanNumerals(numStr[index++].to!int, 2);

        if (num >= 10)
            result ~= buildRomanNumerals(numStr[index++].to!int, 1);

        result ~= buildRomanNumerals(numStr[index].to!int, 0);
    }

    return isLowerCase ? result.toLower : result;
}

void main()
{
    foreach(i; 0..10) i.toRoman.writeln;
    for(int i = 10; i < 100; i += 10) i.toRoman.writeln;
    for(int i = 100; i < 1000; i += 100) i.toRoman.writeln;
    
    4000.toRoman.writeln;
    3999.toRoman.writeln;
    2749.toRoman.writeln;
}
