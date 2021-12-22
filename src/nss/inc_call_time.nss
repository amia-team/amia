#include "inc_sqlite_time"

// Time functions that will return real calendar time and not module time.
// 1 is to get Hour, 2 is to get Minute, 3 is to get Second. 999 is returned as error for any value not 1-3.
int ReturnTime(int n);


// Time functions that will return real calendar time and not module time.
// 1 is to get Month, 2 is to get Day, 3 is to get Year. 999 is returned as error for any value not 1-3.
int ReturnDate(int n);

// This will return the weeks since the start of Unix Time, Jan 1st 1970.
int ReturnCurrentWeek();

// This will return the days since the start of Unix Time, Jan 1st 1970.
int ReturnCurrentDay();

//void main(){}

// Time functions that will return real calendar time and not module time.
// 1 is to get Hour, 2 is to get Minute, 3 is to get Second. 999 is returned as error for any value not 1-3.
int ReturnTime(int n)
{
  string sTime =SQLite_GetSystemTime();

  if(n==1)
  {
    return StringToInt(GetSubString(sTime,0,2)); // Hour
  }
  else if(n==2)
  {
    return StringToInt(GetSubString(sTime,3,2)); // Minute
  }
  else if(n==3)
  {
    return StringToInt(GetSubString(sTime,6,2)); // Second
  }
  else
  {
    return 999; // Error return
  }
}


// Time functions that will return real calendar time and not module time.
// 1 is to get Month, 2 is to get Day, 3 is to get Year. 999 is returned as error for any value not 1-3.
int ReturnDate(int n)
{
  string sDate =SQLite_GetSystemDate();

  if(n==1)
  {
    return StringToInt(GetSubString(sDate,0,2)); // Month
  }
  else if(n==2)
  {
    return StringToInt(GetSubString(sDate,3,2)); // Day
  }
  else if(n==3)
  {
    return StringToInt(GetSubString(sDate,6,4)); // Year
  }
  else
  {
    return 999; // Error return
  }

}

// This will return the weeks since the start of Unix Time, Jan 1st 1970.
int ReturnCurrentWeek()
{
   int nWeek = SQLite_GetTimeStamp()/604800; // 604800 seconds in a week
   return nWeek;
}

// This will return the days since the start of Unix Time, Jan 1st 1970.
int ReturnCurrentDay()
{
   int nWeek = SQLite_GetTimeStamp()/86400; // 86400 seconds in a day
   return nWeek;
}
