C:\Users\claiv\Documents\Virtual Machines\Ubuntu 64-bit

```bash

1. Using Windows Features:
Open Control Panel.
Go to Programs > Programs and Features.
Click Turn Windows features on or off.
Locate and expand Hyper-V.
Uncheck Hyper-V Hypervisor and any other related Hyper-V features.
Click OK and restart your computer. 
2. Using Command Prompt (as Administrator):
Open Command Prompt as Administrator, Run the command: bcdedit /set hypervisorlaunchtype off, and Restart your computer.
3. Using PowerShell (as Administrator):
Open PowerShell as Administrator, Run the command: Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All, and Restart your computer.
4. Disabling Hypervisor in Core Isolation Settings (in Windows 11):
Open Settings and go to System > Core Isolation, Turn off Memory integrity, and Restart your computer.
5. Checking if Hyper-V is disabled:
After restarting, you can check if Hyper-V is disabled by running bcdedit /enum {current} in an elevated Command Prompt. Look for the hypervisorlaunchtype setting, which should be off. 
You can also check the System Information (msinfo32.exe) and see if Virtualization-based security is running. 
Important Notes:
Disabling Hyper-V can affect other features that rely on it, such as Windows Sandbox and WSL (Windows Subsystem for Linux). 
If you need Hyper-V for other tasks, you can re-enable it using the same methods, but with the opposite commands (e.g., bcdedit /set hypervisorlaunchtype auto, or Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All). 
Some users have reported issues with disabling Hyper-V, especially in Windows 11. If you encounter problems, consult online forums and resources for troubleshooting specific to your situation, according to Broadcom community forums. 
```

