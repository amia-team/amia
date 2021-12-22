/*  djinn_chest_shop

--------
Verbatim
--------
Generic shop opener

---------
Changelog
---------

Date       Name        Reason
------------------------------------------------------------------
12/05/2020 Jes         New Script
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetPCSpeaker () ;
    object chestore = GetObjectByTag("chest_djinn_1");

    OpenStore ( chestore , oPC );
    DelayCommand ( 0.5, ExecuteScript ( "getmerchinvchest" ) );
}
