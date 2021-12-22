// script name: fw_halfdynamic
#include "amia_include"
#include "inc_lua"
#include "nwnx_areas"
#include "nwnx_dynres"

void IterateAllFiles(string filter, string script){
    string error = ExecuteLuaString(OBJECT_SELF,"Files('"+filter+"',function(path,file,folder) if (not folder) and file then nwn.SetLocalString(OBJECT_SELF,'path',path); nwn.SetLocalString(OBJECT_SELF,'file',file); nwn.ResetNWScriptTMI(); nwn.ExecuteScript('"+script+"',OBJECT_SELF); end end);");
    DeleteLocalString(OBJECT_SELF,"file");
    DeleteLocalString(OBJECT_SELF,"path");
    SetLocalInt(OBJECT_SELF, "halfdynloaded", 1);
    DelayCommand(0.1, ExecuteScript("mod_mod_load", OBJECT_SELF));
}

void main()
{
    string file = GetLocalString(OBJECT_SELF,"file");

    //When lua is calling this script this will contain the filename
    if(file != ""){

        //and this will contain the path
        string path = GetLocalString(OBJECT_SELF,"path");
        if(FindSubString(file, ".are", 1) != -1)
        {
            string sEntry = GetStringLowerCase( GetLocalString( OBJECT_SELF, "entry_resref" ) );
            string sResRef = GetStringLeft( file, FindSubString( file, "." ) );
            string sLRes = GetStringLowerCase( sResRef );

            if( sEntry == sLRes ){
                PrintString( "! skipping entry area: " + path+sResRef+".are" );
            }
            else if( DYNRES_AddFile( sResRef+".are", path+sResRef+".are" ) &&
                            DYNRES_AddFile( sResRef+".git", path+sResRef+".git" ) &&
                            DYNRES_AddFile( sResRef+".gic", path+sResRef+".gic" ) ){

                sLRes = GetStringLowerCase( sResRef );
                object oArea;
                int n = 0;
                oArea = AREAS_GetArea( n );
                while( GetIsObjectValid( oArea ) ){

                    if( GetStringLowerCase( GetResRef( oArea ) ) == sLRes ){
                        AREAS_DestroyArea( oArea );
                        PrintString( ". overriding existing area: " + sResRef );
                        break;
                    }
                    oArea = AREAS_GetArea( ++n );
                }
                if( GetIsObjectValid( AREAS_CreateArea( sResRef ) ) ){
                    PrintString( ". loaded area file: " + path+sResRef+".are" );
                }
                else
                    PrintString( "! unable to load area: " + path+sResRef+".are" );

            }
            else{
                PrintString( "! unable map area: " + path+sResRef+".are/gic/git" );
            }
        }
    }
    else{
		object oModule = GetModule();
		int iLoadRan = GetLocalInt(oModule, "iLoadRan");
		if(iLoadRan)
		{
			PrintString( "! Tried to iterate again!" );
			return;
		}
		SetLocalInt(oModule, "iLoadRan", TRUE);
        string sPath = NWNX_ReadStringFromINI( "AMIA", "AreaPath", "0", "./nwnx.ini" ) + "*.*";
        IterateAllFiles(sPath,"fw_halfdynamic");
    }
}
