# roman-numerals
This single-function library provides roman numerals for D. Roman numerals are useful for ordering lists and pages as well as for historical uses or appeal. It is also mandatory for implementing INTERCAL as roman numerals are used exclusively as that language's numeric output. This library doesn't support mathematical operations with roman numerals. It simply converts numbers into roman numerals.

To use this function, simply import roman_numerals then type `toRoman(<insert int here>)`. The function accepts all integers, but will return ? for negative numbers and numbers greater than 3999, it will also return NULLA for 0.
