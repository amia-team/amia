/*
--------------------------------------------------------------------------------
NAME: fw_headchanger
Description: This is a simple script that can be used to change head model.
LOG:
    Faded Wings [12/31/2015 - Born!]
    Jes [3/31/21 - Fixed Everything! Added blocker for empty head options.]
--------------------------------------------------------------------------------
*/

/* protypes */
int validateHead( object oPC, int iHead );
int emptyHead( object oPC, int iHead );

void main()
{
    object oPC = GetLastSpeaker();
    object oHeadChanger = OBJECT_SELF;
    int scriptState = GetLocalInt( oPC, "fw_headchanger" );
    string sLast = GetLocalString( oPC, "last_chat" );
    string sInvalidHeadList = GetLocalString( oHeadChanger, "disallowed" );

    if( scriptState == FALSE ) {
        SetLocalInt( oPC, "fw_headchanger", TRUE );
        string sHead = IntToString( GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) );
        SetCustomToken( 6127, sHead );
        DelayCommand( 0.1, ActionStartConversation( oPC, "headchanger", TRUE, FALSE ) );
    }

    else if ( scriptState == TRUE ) {
        if( sLast != "" ) {

            DeleteLocalInt( oPC, "fw_headchanger" );

            int newHead = StringToInt( sLast );

            if ( !validateHead( oPC, newHead ) ) {
                SendMessageToPC( oPC, "This head is only available through DM Approval!" );
                return;
            }

            if ( !emptyHead( oPC, newHead ) ) {
                SendMessageToPC( oPC, "This head is empty! Choose a different number!" );
                return;
            }

            SetCreatureBodyPart( CREATURE_PART_HEAD, newHead, oPC );
        }
        else {
            SendMessageToPC( oPC, "You have not spoken a number to change your head to!" );
            return;
        }
    }
}

int validateHead( object oPC, int newHead ) {
    int iBaseRace = GetAppearanceType( oPC );
    int iGender = GetGender( oPC );

    //Dwarf male
    if( iGender == GENDER_MALE && iBaseRace == 0 ) {
                if( newHead == 138 ) return FALSE;
                if( newHead == 156 ) return FALSE;
}
        //Elf male
        else if( iGender == GENDER_MALE && iBaseRace == 1 ) {
                if( newHead == 23 ) return FALSE;
                if( newHead == 30 ) return FALSE;
                if( newHead == 31 ) return FALSE;
                if( newHead == 103 ) return FALSE;
                if( newHead == 104 ) return FALSE;
                if( newHead == 119 ) return FALSE;
                if( newHead == 120 ) return FALSE;
                if( newHead == 121 ) return FALSE;
                if( newHead == 122 ) return FALSE;
                if( newHead == 123 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
                if( newHead == 181 ) return FALSE;
                if( newHead == 189 ) return FALSE;
                if( newHead == 190 ) return FALSE;
                if( newHead == 191 ) return FALSE;
                if( newHead == 192 ) return FALSE;
                if( newHead == 193 ) return FALSE;
}
        //Gnome male
        else if( iGender == GENDER_MALE && iBaseRace == 2 ) {
                if( newHead == 27 ) return FALSE;
                if( newHead == 112 ) return FALSE;
                if( newHead == 113 ) return FALSE;
                if( newHead == 114 ) return FALSE;
                if( newHead == 115 ) return FALSE;
                if( newHead == 116 ) return FALSE;
                if( newHead == 117 ) return FALSE;
                if( newHead == 118 ) return FALSE;
                if( newHead == 119 ) return FALSE;
                if( newHead == 120 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
}
        //Halfling male
        else if( iGender == GENDER_MALE && iBaseRace == 3 ) {
                if( newHead == 33 ) return FALSE;
                if( newHead == 34 ) return FALSE;
                if( newHead == 37 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 168 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
                if( newHead == 181 ) return FALSE;
                if( newHead == 189 ) return FALSE;
                if( newHead == 190 ) return FALSE;
                if( newHead == 191 ) return FALSE;
                if( newHead == 192 ) return FALSE;
                if( newHead == 193 ) return FALSE;
}
        //Half-elf male
        else if( iGender == GENDER_MALE && iBaseRace == 4 ) {
                if( newHead == 42 ) return FALSE;
                if( newHead == 48 ) return FALSE;
                if( newHead == 49 ) return FALSE;
                if( newHead == 114 ) return FALSE;
                if( newHead == 115 ) return FALSE;
                if( newHead == 116 ) return FALSE;
                if( newHead == 117 ) return FALSE;
                if( newHead == 118 ) return FALSE;
                if( newHead == 119 ) return FALSE;
                if( newHead == 120 ) return FALSE;
                if( newHead == 121 ) return FALSE;
                if( newHead == 122 ) return FALSE;
                if( newHead == 123 ) return FALSE;
                if( newHead == 128 ) return FALSE;
                if( newHead == 129 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 133 ) return FALSE;
                if( newHead == 134 ) return FALSE;
                if( newHead == 135 ) return FALSE;
                if( newHead == 136 ) return FALSE;
                if( newHead == 137 ) return FALSE;
                if( newHead == 138 ) return FALSE;
                if( newHead == 139 ) return FALSE;
                if( newHead == 178 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
                if( newHead == 181 ) return FALSE;
                if( newHead == 182 ) return FALSE;
                if( newHead == 183 ) return FALSE;
                if( newHead == 184 ) return FALSE;
                if( newHead == 185 ) return FALSE;
                if( newHead == 186 ) return FALSE;
                if( newHead == 187 ) return FALSE;
                if( newHead == 188 ) return FALSE;
                if( newHead == 189 ) return FALSE;
                if( newHead == 190 ) return FALSE;
                if( newHead == 191 ) return FALSE;
                if( newHead == 192 ) return FALSE;
                if( newHead == 193 ) return FALSE;
                if( newHead == 194 ) return FALSE;
                if( newHead == 195 ) return FALSE;
                if( newHead == 196 ) return FALSE;
                if( newHead == 197 ) return FALSE;
                if( newHead == 201 ) return FALSE;
                if( newHead == 205 ) return FALSE;
                if( newHead == 207 ) return FALSE;
                if( newHead == 208 ) return FALSE;
                if( newHead == 232 ) return FALSE;
                if( newHead == 236 ) return FALSE;
}
        //Half-orc male
        else if( iGender == GENDER_MALE && iBaseRace == 5 ) {
                if( newHead == 34 ) return FALSE;
                if( newHead == 35 ) return FALSE;
                if( newHead == 101 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 132 ) return FALSE;
                if( newHead == 133 ) return FALSE;
                if( newHead == 134 ) return FALSE;
                if( newHead == 135 ) return FALSE;
                if( newHead == 138 ) return FALSE;
                if( newHead == 151 ) return FALSE;
                if( newHead == 152 ) return FALSE;
                if( newHead == 153 ) return FALSE;
                if( newHead == 154 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 158 ) return FALSE;
                if( newHead == 159 ) return FALSE;
                if( newHead == 194 ) return FALSE;
}
        //Human male
        else if( iGender == GENDER_MALE && iBaseRace == 6 ) {
                if( newHead == 42 ) return FALSE;
                if( newHead == 48 ) return FALSE;
                if( newHead == 49 ) return FALSE;
                if( newHead == 114 ) return FALSE;
                if( newHead == 115 ) return FALSE;
                if( newHead == 116 ) return FALSE;
                if( newHead == 117 ) return FALSE;
                if( newHead == 118 ) return FALSE;
                if( newHead == 119 ) return FALSE;
                if( newHead == 120 ) return FALSE;
                if( newHead == 121 ) return FALSE;
                if( newHead == 122 ) return FALSE;
                if( newHead == 123 ) return FALSE;
                if( newHead == 128 ) return FALSE;
                if( newHead == 129 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 133 ) return FALSE;
                if( newHead == 134 ) return FALSE;
                if( newHead == 135 ) return FALSE;
                if( newHead == 136 ) return FALSE;
                if( newHead == 137 ) return FALSE;
                if( newHead == 138 ) return FALSE;
                if( newHead == 139 ) return FALSE;
                if( newHead == 178 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
                if( newHead == 181 ) return FALSE;
                if( newHead == 182 ) return FALSE;
                if( newHead == 183 ) return FALSE;
                if( newHead == 184 ) return FALSE;
                if( newHead == 185 ) return FALSE;
                if( newHead == 186 ) return FALSE;
                if( newHead == 187 ) return FALSE;
                if( newHead == 188 ) return FALSE;
                if( newHead == 189 ) return FALSE;
                if( newHead == 190 ) return FALSE;
                if( newHead == 191 ) return FALSE;
                if( newHead == 192 ) return FALSE;
                if( newHead == 193 ) return FALSE;
                if( newHead == 194 ) return FALSE;
                if( newHead == 195 ) return FALSE;
                if( newHead == 196 ) return FALSE;
                if( newHead == 197 ) return FALSE;
                if( newHead == 201 ) return FALSE;
                if( newHead == 205 ) return FALSE;
                if( newHead == 207 ) return FALSE;
                if( newHead == 208 ) return FALSE;
                if( newHead == 232 ) return FALSE;
                if( newHead == 236 ) return FALSE;
                if( newHead == 240 ) return FALSE;
}
        //Dwarf female
        else if( iGender == GENDER_FEMALE && iBaseRace == 0 ) {
                if( newHead == 156 ) return FALSE;
}
        //Elf female
        else if( iGender == GENDER_FEMALE && iBaseRace == 1 ) {
                if( newHead == 27 ) return FALSE;
                if( newHead == 38 ) return FALSE;
                if( newHead == 56 ) return FALSE;
                if( newHead == 112 ) return FALSE;
                if( newHead == 120 ) return FALSE;
                if( newHead == 121 ) return FALSE;
                if( newHead == 122 ) return FALSE;
                if( newHead == 154 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 157 ) return FALSE;
                if( newHead == 158 ) return FALSE;
                if( newHead == 160 ) return FALSE;
                if( newHead == 161 ) return FALSE;
                if( newHead == 162 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 192 ) return FALSE;
                if( newHead == 196 ) return FALSE;
}
        //Gnome female
        else if( iGender == GENDER_FEMALE && iBaseRace == 2 ) {
                if( newHead == 17 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 158 ) return FALSE;
                if( newHead == 161 ) return FALSE;
                if( newHead == 179 ) return FALSE;
}
        //Halfling female
        else if( iGender == GENDER_FEMALE && iBaseRace == 3 ) {
                if( newHead == 25 ) return FALSE;
                if( newHead == 26 ) return FALSE;
                if( newHead == 27 ) return FALSE;
                if( newHead == 28 ) return FALSE;
                if( newHead == 29 ) return FALSE;
                if( newHead == 32 ) return FALSE;
                if( newHead == 34 ) return FALSE;
                if( newHead == 54 ) return FALSE;
                if( newHead == 60 ) return FALSE;
                if( newHead == 61 ) return FALSE;
                if( newHead == 62 ) return FALSE;
                if( newHead == 63 ) return FALSE;
                if( newHead == 155 ) return FALSE;
                if( newHead == 158 ) return FALSE;
                if( newHead == 160 ) return FALSE;
                if( newHead == 168 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 194 ) return FALSE;
}
        //Half-elf female
        else if( iGender == GENDER_FEMALE && iBaseRace == 4 ) {
                if( newHead == 26 ) return FALSE;
                if( newHead == 27 ) return FALSE;
                if( newHead == 39 ) return FALSE;
                if( newHead == 40 ) return FALSE;
                if( newHead == 41 ) return FALSE;
                if( newHead == 55 ) return FALSE;
                if( newHead == 57 ) return FALSE;
                if( newHead == 101 ) return FALSE;
                if( newHead == 175 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
                if( newHead == 181 ) return FALSE;
                if( newHead == 183 ) return FALSE;
                if( newHead == 182 ) return FALSE;
                if( newHead == 184 ) return FALSE;
}
        //Half-orc female
        else if( iGender == GENDER_FEMALE && iBaseRace == 5 ) {
                if( newHead == 13 ) return FALSE;
                if( newHead == 133 ) return FALSE;
                if( newHead == 134 ) return FALSE;
                if( newHead == 151 ) return FALSE;
                if( newHead == 152 ) return FALSE;
                if( newHead == 163 ) return FALSE;
}
        //Human female
        else if( iGender == GENDER_FEMALE && iBaseRace == 6 ) {
                if( newHead == 26 ) return FALSE;
                if( newHead == 27 ) return FALSE;
                if( newHead == 39 ) return FALSE;
                if( newHead == 40 ) return FALSE;
                if( newHead == 41 ) return FALSE;
                if( newHead == 55 ) return FALSE;
                if( newHead == 57 ) return FALSE;
                if( newHead == 101 ) return FALSE;
                if( newHead == 175 ) return FALSE;
                if( newHead == 179 ) return FALSE;
                if( newHead == 180 ) return FALSE;
                if( newHead == 181 ) return FALSE;
                if( newHead == 183 ) return FALSE;
                if( newHead == 182 ) return FALSE;
                if( newHead == 184 ) return FALSE;
                if( newHead == 214 ) return FALSE;
}
    return TRUE;
}

int emptyHead( object oPC, int newHead ) {
    int iBaseRace = GetAppearanceType( oPC );
    int iGender = GetGender( oPC );

        //Dwarf male
        if( iGender == GENDER_MALE && iBaseRace == 0 ) {
                if( ( newHead > 33 ) && ( newHead < 101 ) ) return FALSE;
                if( ( newHead > 101 ) && ( newHead < 131 ) ) return FALSE;
                if( ( newHead > 132 ) && ( newHead < 138 ) ) return FALSE;
                if( ( newHead > 138 ) && ( newHead < 155 ) ) return FALSE;
                if( newHead > 155 ) return FALSE;
}
        //Elf male
        else if( iGender == GENDER_MALE && iBaseRace == 1 ) {
                if( ( newHead > 49 ) && ( newHead < 103 ) ) return FALSE;
                if( newHead == 105 ) return FALSE;
                if( newHead == 116 ) return FALSE;
                if( newHead == 117 ) return FALSE;
                if( newHead == 118 ) return FALSE;
                if( ( newHead > 123 ) && ( newHead < 130 ) ) return FALSE;
                if( newHead == 131 ) return FALSE;
                if( ( newHead > 132 ) && ( newHead < 150 ) ) return FALSE;
                if( ( newHead > 50 ) && ( newHead < 155 ) ) return FALSE;
                if( ( newHead > 155 ) && ( newHead < 179 ) ) return FALSE;
                if( ( newHead > 180 ) && ( newHead < 189 ) ) return FALSE;
                if( newHead > 193 ) return FALSE;
}
        //Gnome male
        else if( iGender == GENDER_MALE && iBaseRace == 2 ) {
                if( ( newHead > 41 ) && ( newHead < 112 ) ) return FALSE;
                if( ( newHead > 120 ) && ( newHead < 123 ) ) return FALSE;
                if( ( newHead > 123 ) && ( newHead < 130 ) ) return FALSE;
                if( newHead == 131 ) return FALSE;
                if( ( newHead > 132 ) && ( newHead < 155 ) ) return FALSE;
                if( ( newHead > 155 ) && ( newHead < 179 ) ) return FALSE;
                if( ( newHead > 180 ) && ( newHead < 194 ) ) return FALSE;
                if( newHead > 199 ) return FALSE;
}
        //Halfling male
        else if( iGender == GENDER_MALE && iBaseRace == 3 ) {
                if( newHead == 111) return FALSE;
                if( ( newHead > 103 ) && ( newHead < 112 ) ) return FALSE;
                if( ( newHead > 112 ) && ( newHead < 130 ) ) return FALSE;
                if( newHead == 131 ) return FALSE;
                if( ( newHead > 132 ) && ( newHead < 145 ) ) return FALSE;
                if( ( newHead > 146 ) && ( newHead < 155 ) ) return FALSE;
                if( newHead == 156 ) return FALSE;
                if( newHead == 157 ) return FALSE;
                if( ( newHead > 168 ) && ( newHead < 179 ) ) return FALSE;
                if( ( newHead > 180 ) && ( newHead < 189 ) ) return FALSE;
                if( newHead > 194 ) return FALSE;
}
        //Half-elf male
        else if( iGender == GENDER_MALE && iBaseRace == 4 ) {
                if( ( newHead > 49 ) && ( newHead < 82 ) ) return FALSE;
                if( newHead == 142 ) return FALSE;
                if( newHead == 198 ) return FALSE;
                if( newHead == 199 ) return FALSE;
                if( newHead == 200 ) return FALSE;
                if( newHead == 202 ) return FALSE;
                if( newHead == 222 ) return FALSE;
                if( newHead == 223 ) return FALSE;
                if( newHead > 239 ) return FALSE;
}
        //Half-orc male
        else if( iGender == GENDER_MALE && iBaseRace == 5 ) {
                if( ( newHead > 41 ) && ( newHead < 101 ) ) return FALSE;
                if( ( newHead > 101 ) && ( newHead < 130 ) ) return FALSE;
                if( ( newHead > 135 ) && ( newHead < 138 ) ) return FALSE;
                if( ( newHead > 138 ) && ( newHead < 149 ) ) return FALSE;
                if( newHead == 157 ) return FALSE;
                if( ( newHead > 159 ) && ( newHead < 194 ) ) return FALSE;
                if( newHead > 194 ) return FALSE;
}
        //Human male
        else if( iGender == GENDER_MALE && iBaseRace == 6 ) {
                if( ( newHead > 49 ) && ( newHead < 82 ) ) return FALSE;
                if( newHead == 142 ) return FALSE;
                if( newHead == 198 ) return FALSE;
                if( newHead == 199 ) return FALSE;
                if( newHead == 202 ) return FALSE;
                if( newHead == 222 ) return FALSE;
                if( newHead == 223 ) return FALSE;
                if( newHead > 239 ) return FALSE;
}
        //Dwarf female
        else if( iGender == GENDER_FEMALE && iBaseRace == 0 ) {
                if( ( newHead > 29 ) && ( newHead < 153 ) ) return FALSE;
                if( newHead > 155 ) return FALSE;
}
        //Elf female
        else if( iGender == GENDER_FEMALE && iBaseRace == 1 ) {
                if( ( newHead > 58 ) && ( newHead < 100 ) ) return FALSE;
                if( newHead == 114 ) return FALSE;
                if( newHead == 123 ) return FALSE;
                if( newHead == 137 ) return FALSE;
                if( ( newHead > 141 ) && ( newHead < 154 ) ) return FALSE;
                if( newHead == 156 ) return FALSE;
                if( ( newHead > 163 ) && ( newHead < 179 ) ) return FALSE;
                if( ( newHead > 179 ) && ( newHead < 191 ) ) return FALSE;
                if( newHead > 195 ) return FALSE;
}
        //Gnome female
        else if( iGender == GENDER_FEMALE && iBaseRace == 2 ) {
                if( ( newHead > 21 ) && ( newHead < 139 ) ) return FALSE;
                if( ( newHead > 139 ) && ( newHead < 155 ) ) return FALSE;
                if( newHead == 156 ) return FALSE;
                if( newHead == 157 ) return FALSE;
                if( newHead == 159 ) return FALSE;
                if( newHead == 160 ) return FALSE;
                if( ( newHead > 161 ) && ( newHead < 179 ) ) return FALSE;
                if( newHead > 179 ) return FALSE;
}
        //Halfling female
        else if( iGender == GENDER_FEMALE && iBaseRace == 3 ) {
                if( ( newHead > 63 ) && ( newHead < 139 ) ) return FALSE;
                if( ( newHead > 139 ) && ( newHead < 155 ) ) return FALSE;
                if( newHead == 156 ) return FALSE;
                if( newHead == 157 ) return FALSE;
                if( newHead == 159 ) return FALSE;
                if( ( newHead > 160 ) && ( newHead < 168 ) ) return FALSE;
                if( ( newHead > 168 ) && ( newHead < 179 ) ) return FALSE;
                if( ( newHead > 179 ) && ( newHead < 193 ) ) return FALSE;
                if( newHead > 193 ) return FALSE;
}
        //Half-elf female
        else if( iGender == GENDER_FEMALE && iBaseRace == 4 ) {
                if( newHead == 58 ) return FALSE;
                if( newHead == 78 ) return FALSE;
                if( newHead == 94 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 131 ) return FALSE;
                if( newHead == 132 ) return FALSE;
                if( newHead == 133 ) return FALSE;
                if( newHead == 134 ) return FALSE;
                if( newHead == 176 ) return FALSE;
                if( newHead == 177 ) return FALSE;
                if( newHead == 182 ) return FALSE;
                if( newHead > 213 ) return FALSE;
}
        //Half-orc female
        else if( iGender == GENDER_FEMALE && iBaseRace == 5 ) {
                if( ( newHead > 22 ) && ( newHead < 133 ) ) return FALSE;
                if( ( newHead > 133 ) && ( newHead < 150 ) ) return FALSE;
                if( ( newHead > 154 ) && ( newHead < 163 ) ) return FALSE;
                if( newHead > 163 ) return FALSE;
}
        //Human female
        else if( iGender == GENDER_FEMALE && iBaseRace == 6 ) {
                if( newHead == 58 ) return FALSE;
                if( newHead == 78 ) return FALSE;
                if( newHead == 94 ) return FALSE;
                if( newHead == 130 ) return FALSE;
                if( newHead == 131 ) return FALSE;
                if( newHead == 132 ) return FALSE;
                if( newHead == 133 ) return FALSE;
                if( newHead == 134 ) return FALSE;
                if( newHead == 176 ) return FALSE;
                if( newHead == 177 ) return FALSE;
                if( newHead > 215 ) return FALSE;
}
    return TRUE;
}
