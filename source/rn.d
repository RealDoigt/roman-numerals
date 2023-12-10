module roman_numerals;
import std.string;
import std.regex;
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

auto toRoman(int num, bool isLowerCase = false, bool nFor0 = false)
{
    string result;

    if (num > 3999 || num < 0) result = "?";
    else if (num == 0) result = nFor0 ? "N" : "NULLA";

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

/* 
    This function is case insensitive.
    Explanation for params below:
    
    allowM: M (1000) was invented during medieval times, so the current usage doesn't reflect ancient times accurately. The option is there for validations that have to do with accurate historical usage.
    
    allowJ: In order to improve readability, J was often used at the end of lowercase combinations; like "iij" (3) for example. This function doesn't validate if the J is properly used however, it only offers the possibility to treat I and J as the same.
    
    allowU: Sometimes, the u shape was used for v, so "ui" is actually "vi" (6).
    
    form: Today, it is standard to write roman numerals using what we call the substractive form. Historically however, roman numbers were also written using the additive form, which allowed things like IIII instead of IV and LXXXX instead of XC. Sometimes, romans mixed substractive and additive forms because, contrarily to common belief, standardised roman numbers didn't really exist until modern times. Other forms existed too, which are covered by this function. for information on the other forms, I encourage the curious to look into roman numerals on their own time because this comment is getting long already and it is not the place to explain roman numerals in depth.
    
    For the vinculum forms, do note, that it is mostly impossible to write down digitally. An alternative is offered for validation instead. The numbers are arranged bit by bit so that you can do nice things like make yourself enums and do stuff like vinculum | substractive_form | additive_form
    * 1: substractive form
    * 2: additive form
    * 32: fasti form
    * 64: indescriminate substractive form
    * 96: french form (use the apostrophes ' around your middle XX)
    * 128: accounting form (spaces are mandatory)
    * 160: year form (2 pairs of numbers from I to XCIX and no spacing)
    * 4: vinculum bit (use apostrophes ' around your multiplied numbers for the thousands and | for the hundred thousands. Examples: 'I'CCXXXIV is 1,234 and |V| is 500,000
    * 8 : apostrophus bit (use parentheses or the ligature characters instead of C and Ↄ)
    * 16: fraction bit
    
    zero: Roman numerals don't have anyway to represent 0. Instead, ancient mathmaticians used the word "nulla" which means "none" or used a single letter N.
    * 0: 0 is not used
    * 1: NULLA
    * 2: N
*/
auto isValidRoman
(
    string number, 
    bool allowM = true, 
    bool allowJ = true, 
    bool allowU = false, 
    ubyte form = 1, 
    ubyte zero = 1
)
{
    number = number.toLower;
    auto validGlyphs = "[ivxlcd";
    
    if (allowM) validGlyphs ~= "m";
    if (allowJ) validGlyphs ~= "j";
    if (allowU) validGlyphs ~= "u";
    
    if (form & 128 == 128)
        validGlyphs ~= " ";
        
    if (form & 96 == 96 || form & 4 == 4)
        validGlyphs ~= "'";
        
    if (form & 4 == 4)
        validGlyphs ~= "|";
        
    if (form & 8 == 8)
        validGlyphs ~= `()ↀↁↂↇↈ`;
        
    if (form & 16 == 16)
        validGlyphs ~= ".·:∴∷⁙s";
        
    validGlyphs ~= "]+";
    
    if (zero == 1) validGlyphs ~= "|(nulla)";
    else if (zero == 2) validGlyphs ~= "|n";
    
    return true;
}
