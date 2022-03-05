void main()
{
    object oCrate = OBJECT_SELF;
    int nCooldown = GetLocalInt(oCrate,"cooldown");

    if(nCooldown == 0)
    {
      AssignCommand(oCrate,ActionSpeakString("*As you get near the crate you see a giant rat bound across the boat, disappearing behind yet another crate!*"));
      SetLocalInt(oCrate,"cooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oCrate,"cooldown"));
    }
}
