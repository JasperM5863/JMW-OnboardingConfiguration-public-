# JMW-OnboardingConfiguration-public-
The official version is a private repository, so I've created a public version that showcases what the original one does. This won't run everything the same since some software is proprietary, but this should demo what it's supposed to do. 

**Run this in powershell with:**

    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-RestMethod -Uri "https://github.com/JasperM5863/JMW-OnboardingConfiguration-public-" | Invoke-Expression
   
Once a provisioned device logs in (as the new user) and has local admin (should automatically be done with NinjaOne), run this powershell script AS ADMINISTRATOR to install programs.
There are two columns:

**Customize allows the IT guy to manually select the following settings:**    

    * Install Google Chrome (opens setting window to allow the IT admin to set as default browser)
    * Install Google Drive
    * Install Bluebeam Revu (choice to either install the version on the domain controller, or the newest from the internet)
    * Install Viewpoint Vista (install the version on the domain controller)
    * Install Microsoft ODBC Driver for SQL Server (prereq for Vista) (from domain ctrl or internet)
    * Install .NET Framework 4.8 (prereq for Vista) (from domain ctrl or internet)
    * Install SAP Crystal Reports (prereq for Vista) (domain only)
    * Install VC++ Redistributable (prereq for Bluebeam) (from domain controller or internet)
    * Run Windows 11 debloater which removes
        * "Microsoft.WindowsCamera", "Clipchamp.Clipchamp", "Microsoft.WindowsAlarms",
        "Microsoft.WindowsFeedbackHub", "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsMaps", "Microsoft.ZuneMusic", "Microsoft.BingNews",
        "Microsoft.Todos", "Microsoft.ZuneVideo", "Microsoft.MicrosoftOfficeHub",
        "Microsoft.People", "Microsoft.PowerAutomateDesktop", "MicrosoftCorporationII.QuickAssist",
        "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsSoundRecorder",
        "Microsoft.BingWeather", "Microsoft.Xbox.TCUI", "Microsoft.GamingApp",
        "Microsoft.BingSearch", "Microsoft.Windows.Ai.Copilot.Provider",
        "Microsoft.Windows.Copilot", "Microsoft.Copilot"
    * Clean and install Office LTSC 2024
    * Allow windows updates to be delayed (features for 365 days, security updates for 4 days, no drivers updates to be installed)
    *Rename the PC (creates one by default, can be changed in text boxes if needed)
    
**Preset runs all the processes in customize with some differences:**

    * Doesn't delay windows updates (keeps default)
    * Defaults to the domain controller for all apps/software

The script to run the program is in the Onboarding doc (Technology -> Onboarding). It has some sensative information so it isn't pasted here (private tokenn)
    
