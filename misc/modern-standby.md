# Modern standby 

I received a new Dell XPS 15 2023 and installed openSUSE Leap 15.5 on it.
Installation went mostly smoothly.

What came out as annoying is the fact that this computer does not support "classical" S3 Standby, but instead provides "Modern Standby" which puts the OS into a low power mode, allowing it to wake up instantly, and performing background tasks on demand (like downloading Windows updates...). The consequence is that in modern standby mode, the battery is drained quite significantly, and the laptop heats up.

First thought was to use hibernation instead of standby (During installation I did prepare a large swap partition for this purpose), but this option didn't show up in the KDE power management configuration. The only choices e.g. for the action attached to closing the lid were "Standby" --  modern standby --
and shutdown.

After spending a few hours with googling, I learned two things:


a) Modern standby has two modes: connected and disconnected. If the laptop lid is closed with AC power on, 
   connected mode is entered with the consequenced described above. If the lid is closed with AC power off,
   the disconnected mode is entered with less background activity.

https://www.linkedin.com/pulse/understanding-configuring-modern-standby-improved-device-palmer/
    
    I didn't find evidence that this works with my system.

b) When investigating the hibernation issue, I tested hibernation using `sudo systemctl hibernate` which
   resulted in the error message `systemctl hibernate sleep verb not supported`. From further investigation
   I learned that now, by default, hibernation is disabled by default when UEFI  secure boot is enabled.
   Which disabling UEFI secure boot in the BIOS, hibernate and "hybrid sleep" option appeard in the 
   KDE power management configruation options.
   
   
   
