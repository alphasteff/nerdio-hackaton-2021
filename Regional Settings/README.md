# Regional Settings
Below is the information that I transmitted when I submitted my work.

1. Name and last name\
Stefan Beckmann

2. Skill level\
Advanced

3. Category (Freestyle/Set Challenge)\
Set Challenge

4. If Set Challenge, please specify Set Challenge\
#1: "Configure regional settings and language on session hosts, with different language per host pool, but using the same image"

5. Submission\
https://github.com/alphasteff/nerdio-hackaton-2021/blob/main/Regional%20Settings/Set-RegionalSettings.ps1

6. Detailed description\
This script is used to configure the Regional Settings specified in the Tag. Keyboar layouts, Geo Id, MUI and User Locale are configured.\
If the tag should not be called RegionalSettings, then you must change this in the variable.\
The parameters to be defined are stored within the tag in JSON format.\
If you want to use this script in Nerdio, comment or remove the param section!

7. Additional information\
The script can be used as a Runbook or Script. I have also tested the code with Cloud Shell. The following is required:
- A VM with Windows 10 Enterprise or Multi Session
- Install thn needed language packs:  https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs
- In addition to an administrator account for testing, create another user who does not yet have a profile.

8. Evidence of script running successfully\
You can find a short video in the same directory.
https://github.com/alphasteff/nerdio-hackaton-2021/blob/main/Apply%20ASG%20to%20NIC/Apply%20ASG%20to%20NIC.mp4
