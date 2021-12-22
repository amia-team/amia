//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_td_irltime
//description: Brings IRL time to nwn
//used as: library
//date:    06/27/08
//author:  Terra

//-----------------------------------------------------------------------------
// Notes
//-----------------------------------------------------------------------------
/*
NWNX uses char arrays instead of strings which means there has to be
memspace for them which is why the "..." are there.
Currently there is two functions:
TIME
CURRENTSECOND
They're called by setting a localstring on the module using:
SetLocalString()

TIME: is a directlink to the C++ function strftime() which can be found in
ctime.h. Calling TIME looks like this
SetLocalString( GetModule( ) ,"NWNX!SYSTEMDATA!TIME", param);

strftime() params can be found here: http://www.cplusplus.com/reference/clibrary/ctime/strftime.html

The setlocalstring works as a call and to get the desired time you'll have to
get a localstring with the same varname:
GetLocalString( GetModule( ), "NWNX!SYSTEMDATA!TIME" );

ALSO! Due to the char arrays the functions cannot return longer strings then
the param its gotten hance the dots as filling they will also be returned to
nwn but can be filtered out with substring functions.

CURRENTSECOND: uses the time() function from the same library as TIME
see GetCurrentSecond() in this library for information works like TIME.

GETRUNTIME: This function returns the amount of seconds that has passed
since swissarmyknife plugin was started which starts when the server does
*/
//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Returns the amount of seconds that has passed since module start
int GetModuleRuntime();

//Returns the amount of seconds that has passed since January 1, 1970
int GetFullTimestamp();

//Returns the amount of seconds that has passed since 1 jan 2008, 9:00
int GetShortTimestamp();

//Return date followed by the current time
//ex: 06/27/08 09:59:56
string GetTimeStamp();

//Get weekday
//iParam = 0 ex: Thu
//iParam = 1 ex: Thursday
string GetWeekDay(int iParam = 0);

//Get the current month
//iParam = 0 ex: Aug
//iParam = 1 ex: August
string GetMonth(int iParam = 0);

//Return the rawtime in a string format
//ex: Thu Aug 23 14:55:02 2001
string GetRawTime();

//Return the current day
//ex: 23 (01-31)
string GetDayOfTheMonth();

//Return the current hour
//iParam = 0 ex: 14 (00-23)
//iParam = 1 ex: 02 (01-12)
string GetCurrentHour(int iParam = 0);

//Return the current day of the year
//ex: 235 (001-366)
string GetDayOfTheYear();

//Return the current day of the year
//ex: 08 (01-12)
string GetCurrentMonth();

//Returns minutes, hours or seconds as a int
//iParam = 0 seconds ex: 14 (00-61)
//iParam = 1 minutes ex: 02 (00-59)
int Time(int iParam = 0);

//Returns AM or PM designation
string PM_AM();

//Returns the current week
//iParam = 0 ex: 33 (00-53) Sunday as fisrt day of the week
//iParam = 1 ex: 33 (00-53) Monday as fisrt day of the week
int GetWeekNumber(int iParam = 0);

//Returns a time or date stamp
//iParam = 0 seconds ex: 08/23/01
//iParam = 1 minutes ex: 14:55:02
string TimeStamp(int iParam = 0);

//Return the current day of the year
//ex: 4 (0-6)
//note: sunday is 0
int GetWeekDayNumber();

//Returns the year
//iParam = 0 ex: 08 (00-99)
//iParam = 1 ex: 2008
string Year(int iParam = 0);

//Returns the timezone
//ex: CDT
string GetTimeZone();

//Test all the time functions
//feedback is send to oTarget as messages
void TestTime(object oTarget);

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
int GetFullTimestamp()
{
object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!CURRENTSECOND", "...................................");

string sSec = GetLocalString(oObject, "NWNX!SYSTEMDATA!CURRENTSECOND");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!CURRENTSECOND");

return StringToInt(sSec);
}
//-----------------------------------------------------------------------------
string GetTimeStamp()
{
object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%x %X............");

string sStamp = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

return sStamp;
}
//-----------------------------------------------------------------------------
string GetWeekDay(int iParam = 0)
{
object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%a.............");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%A.............");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
string GetMonth(int iParam = 0)
{
object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%b.............");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%B.............");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;
}
//-----------------------------------------------------------------------------
string GetRawTime()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%c.....................");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
string GetDayOfTheMonth()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%d");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

//sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
string GetCurrentHour(int iParam = 0)
{

object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%H");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%I");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
string GetDayOfTheYear()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%j.");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

//sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
string GetCurrentMonth()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%m");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

//sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
int Time(int iParam = 0)
{

object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%S");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%M");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

return StringToInt(sString);

}
//-----------------------------------------------------------------------------
string PM_AM()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%p");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

//sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
int GetWeekNumber(int iParam = 0)
{

object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%U");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%W");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

return StringToInt(sString);

}
//-----------------------------------------------------------------------------
int GetWeekDayNumber()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%w");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

sString = GetSubString(sString, 0, 1);

return StringToInt(sString);

}
//-----------------------------------------------------------------------------
string TimeStamp(int iParam = 0)
{

object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%x......");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%X......");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

return sString;

}
//-----------------------------------------------------------------------------
string Year(int iParam = 0)
{

object oObject = GetModule();

if(!iParam)
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%y");

else
SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%Y..");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

return sString;

}
//-----------------------------------------------------------------------------
string GetTimeZone()
{

object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!TIME", "%Z..............................................");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!TIME");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return sString;

}
//-----------------------------------------------------------------------------
int GetModuleRuntime()
{
object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!GETRUNTIME", "..............................................");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!GETRUNTIME");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!GETRUNTIME");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return StringToInt(sString);

}
//-----------------------------------------------------------------------------
int GetShortTimestamp()
{
object oObject = GetModule();

SetLocalString(oObject, "NWNX!SYSTEMDATA!GETTIMESTAMP", "..............................................");

string sString = GetLocalString(oObject, "NWNX!SYSTEMDATA!GETTIMESTAMP");

DeleteLocalString(oObject, "NWNX!SYSTEMDATA!GETTIMESTAMP");

sString = GetSubString(sString, 0, FindSubString(sString, "."));

return StringToInt(sString);

}
//-----------------------------------------------------------------------------
void TestTime(object oTarget)
{

SendMessageToPC(oTarget,"GetFullTimestamp: "+ IntToString(GetFullTimestamp()));

SendMessageToPC(oTarget,"GetTimeStamp: "+ GetTimeStamp());

SendMessageToPC(oTarget,"GetWeekDay(0): "+ GetWeekDay(0));
SendMessageToPC(oTarget,"GetWeekDay(1): "+ GetWeekDay(1));

SendMessageToPC(oTarget,"GetMonth(0): "+ GetMonth(0));
SendMessageToPC(oTarget,"GetMonth(1): "+ GetMonth(1));

SendMessageToPC(oTarget,"GetRawTime: "+ GetRawTime());

SendMessageToPC(oTarget,"GetDayOfTheMonth: "+ GetDayOfTheMonth());

SendMessageToPC(oTarget,"GetCurrentHour(0): "+ GetCurrentHour(0));
SendMessageToPC(oTarget,"GetCurrentHour(1): "+ GetCurrentHour(1));

SendMessageToPC(oTarget,"GetDayOfTheYear: "+ GetDayOfTheYear());

SendMessageToPC(oTarget,"GetCurrentMonth: "+ GetCurrentMonth());

SendMessageToPC(oTarget,"Time(0): "+ IntToString(Time(0)));
SendMessageToPC(oTarget,"Time(1): "+ IntToString(Time(1)));

SendMessageToPC(oTarget,"PM_AM: "+ PM_AM());

SendMessageToPC(oTarget,"GetCurrentHour(1): "+ GetCurrentHour(1));

SendMessageToPC(oTarget,"GetWeekNumber(0): "+ IntToString(GetWeekNumber(0)));
SendMessageToPC(oTarget,"GetWeekNumber(1): "+ IntToString(GetWeekNumber(1)));

SendMessageToPC(oTarget,"TimeStamp(0): "+ TimeStamp(0));
SendMessageToPC(oTarget,"TimeStamp(1): "+ TimeStamp(1));

SendMessageToPC(oTarget,"GetWeekDayNumber: "+ IntToString(GetWeekDayNumber()));

SendMessageToPC(oTarget,"Year(0): "+ Year(0));
SendMessageToPC(oTarget,"Year(1): "+ Year(1));

SendMessageToPC(oTarget,"GetTimeZone: "+ GetTimeZone());

SendMessageToPC(oTarget,"GetModuleRuntime: "+ IntToString(GetModuleRuntime()));

SendMessageToPC(oTarget,"GetShortTimestamp: "+ IntToString(GetShortTimestamp()));
}

