// Module spell components - run from m_spellhook
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050314   jking            Initial release.
// 20130210   PoS              Dummied out all spell component spells
//


int CheckForSpellComponent()
{
    object oCaster = OBJECT_SELF;
    int    iSpell  = GetSpellId();
    string sTagReq;

    switch (iSpell) {
        //case SPELL_ISAACS_GREATER_MISSILE_STORM: sTagReq = "MagesMissileComponents"; break;
        //case SPELL_FIREBRAND:                    sTagReq = "MagesFireDust"; break;
        //case SPELL_TIME_STOP:                    sTagReq = "SandsofTime"; break;
        default:                                 sTagReq = ""; break;
    }

    if (sTagReq != "") {
        if (GetIsPC(oCaster) && !GetIsDM(oCaster)) {
            object oComponent = GetItemPossessedBy( oCaster, sTagReq );
            if ( !GetIsObjectValid(oComponent) )
                return FALSE;                   // player doesn't have component
            else
                DestroyObject( oComponent );
        }
    }

    return TRUE;
}
