// Capitalizes the first letter of sWord and lowercases the rest.
// Examples: HELLO -> Hello, hello -> Hello, hElLo -> Hello
string GetStringSentenceCase(string sWord);

string GetStringSentenceCase(string sWord)
{
    string sFirst = GetStringLeft(sWord,1);
    string sRest = GetStringRight(sWord,GetStringLength(sWord)-1);
    return GetStringUpperCase(sFirst) + GetStringLowerCase(sRest);
}
