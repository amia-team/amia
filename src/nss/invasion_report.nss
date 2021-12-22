void main()
{
   object oModule = GetModule();
   object oNPC = OBJECT_SELF;
   string sResRef = GetResRef(oNPC);
   int nGobs = GetLocalInt(GetModule(),"invasiongobs");
   int nBeast = GetLocalInt(GetModule(),"invasionbeastmen");
   int nOrcs = GetLocalInt(GetModule(),"invasionorcs");
   int nTrolls = GetLocalInt(GetModule(),"invasiontrolls");

   string nGobsTime = IntToString(GetLocalInt(GetModule(),"invasiongobstime"));
   string nBeastTime = IntToString(GetLocalInt(GetModule(),"invasionbeastmentime"));
   string nOrcsTime = IntToString(GetLocalInt(GetModule(),"invasionorcstime"));
   string nTrollsTime = IntToString(GetLocalInt(GetModule(),"invasiontrollstime"));


   if(sResRef == "invasion_dm_repo")
   {//start


    SpeakString("One moment please.");


     if(nGobs == 1)
     {
      DelayCommand(1.0,SpeakString("There will be a goblin invasion in " + nGobsTime + " minutes after the server started."));

     }

     if(nBeast == 1)
     {
      DelayCommand(1.5,SpeakString("There will be a beastmen invasion in " + nBeastTime + " minutes after the server started."));

     }

     if(nOrcs == 1)
     {
       DelayCommand(2.0,SpeakString("There will be an orc invasion in " + nOrcsTime + " minutes after the server started."));

     }

     if(nTrolls == 1)
     {
       DelayCommand(2.5,SpeakString("There will be a troll invasion in " + nTrollsTime + " minutes after the server started."));

     }

     if((nGobs != 1) && (nBeast != 1) && (nOrcs != 1) && (nTrolls != 1))
     {
       DelayCommand(1.0,SpeakString("No invasions this reset."));
     }


   } //end
   else
   { // start

   SpeakString("Hello there. You wish to see the most recent scouting report? Very well. Let me see.... *Begins to flip through some notes*");


     if(nGobs == 1)
     {
       DelayCommand(1.0,SpeakString("The goblins have been working themselves up lately and could pose a threat soon."));

     }

     if(nBeast == 1)
     {
       DelayCommand(1.5,SpeakString("Hmm. The Beastmen have been fairly active recently outside of their caves. Keep an eye out."));

     }

     if(nOrcs == 1)
     {
       DelayCommand(2.0,SpeakString("The orcs have been busy doing something in the frontier. I would be careful if I were you."));

     }

     if(nTrolls == 1)
     {
       DelayCommand(2.5,SpeakString("*Frowns* The Trolls have been fairly active of late. A scout swore that he saw a large troll getting the others worked up in their breeding grounds."));

     }

     if((nGobs != 1) && (nBeast != 1) && (nOrcs != 1) && (nTrolls != 1))
     {
       DelayCommand(1.0,SpeakString("Everything has been quiet."));
     }

   }  // end
}
