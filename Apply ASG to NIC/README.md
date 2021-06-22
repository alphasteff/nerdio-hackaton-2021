# Apply ASG to NIC
Below is the information that I transmitted when I submitted my work.

1. Name and last name\
Stefan Beckmann

2. Skill level\
Advanced

3. Category (Freestyle/Set Challenge)\
Freestyle

4. If Set Challenge, please specify Set Challenge\
No challenge

5. Submission\
https://github.com/alphasteff/nerdio-hackaton-2021/blob/main/Apply%20ASG%20to%20NIC/Apply%20ASG%20to%20NIC.ps1

6. Detailed description\
This script assigns one or more Application Security Groups to a VM. It chooses to match Application Security Group by the full or unique parts of names within a comma-separated list.\
In order for this script to work, the ApplicationSecurityGroups custom tag must be filled with a comma-separated list with the names or parts of the names of the Application Security Groups (must be unique).\
If the tag should not be called ApplicationSecurityGroups, then you must change this in the variable.\
The whole system is subject to all the constraints and requirements that Application Security Groups bring with them. For example, only Application Security Groups from the same region can be assigned in the same subscription.\
If you want to use this script in Nerdio, comment or remove the param section!

7. Additional information\
The script can be used as a Runbook or Script. I have also tested the code with Cloud Shell. The following is required:
- Azure VM
- Application Security Groups (for testing a minimum of 2 are recommended)
- On the Azure VM a tag with part of the names of the Application Security Groups, separated by a comma): ApplicationSecurityGroups (the name of the tag can be customized)

8. Evidence of script running successfully\
You can find a short video in the same directory.
https://github.com/alphasteff/nerdio-hackaton-2021/blob/main/Apply%20ASG%20to%20NIC/Apply%20ASG%20to%20NIC.mp4
