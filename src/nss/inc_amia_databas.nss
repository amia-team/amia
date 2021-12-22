/*
   Contains all of the needed functions for the new database system. Taking the
   sqlLite implementation of the default database for a spin.
   Even if the default database is a bust, we can change the implementation of
   these functions without having to redesign everything again.

   Author: ZoltanTheRed
   Editors: ZoltanTheRed
   Last Edit By: ZoltanTheRed
*/

#include "x0_i0_campaign"

void DB_SetPlayerDeity(object player,  string deityName);

string DB_GetPlayerDeity(object player);


// Wraps the functionality of setting a deity in a function so that people are
// encouraged to only do so from a single point of execution.
void DB_SetPlayerDeity(object player, string deityName)
{
    SetCampaignDBString(player, "deity", deityName);
}

// Wraps obtaining a deity in a function so that there is a single point of
// execution for obtaining a deity on a player.
string DB_GetPlayerDeity(object player)
{
  string deity = GetCampaignDBString(player, "deity");

  return deity;
}


