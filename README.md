# Fix-HotsRez
A script that auto-changes the Heroes of the Storm resolution to ultra-wide and other non-standard resolutions.


# Instructions

- Download the repo files by clicking the green Code button and select "Download ZIP".
- Copy Fix-HotSRez.ps1 and HotSRez.cmd to the same direcory/folder in an easy to access location, like C:\Temp.
- Windows will treat these files as untrusted and block execution, you will need to unblock/trust the scripts to run them.
  - Right-click on the Fix-HotSRez.ps1 file and select Properties.
  - Check the Unblock box.
  - OK

<img width="259" alt="{E6B9A8B5-371C-4937-89EA-537855C34A57}" src="https://github.com/user-attachments/assets/03042d0f-d4e8-4f16-aeca-6b633c74b877">

- Repeat the unblock process for the HotSRez.cmd file.
- Run PowerShell as Administrator and enable script execution.
  - Type in PowerShell in the search bar. Open the Windows/Start menu if you don't have search on the taskbar.

<img width="122" alt="{0855A88A-09F3-4578-A3A5-AA7D6885CD66}" src="https://github.com/user-attachments/assets/a93d9b11-6d71-4d4d-be2b-ef85cadf98ca">

  - Select "Run as Administrator"

<img width="282" alt="{4F356809-21C0-404D-9C28-3D1FA8B17F0B}" src="https://github.com/user-attachments/assets/a577c943-bbf6-4147-8e5b-0a4e9998530d">

  - Run this command:

```powershell
Set-ExecutionPolicy RemoteSigned -Force
```

- The script defaults to 5120x1440. To change the resolution:
  - Edit Fix-HotSRez.ps1.
  - Edit the $height and $width variables on lines 6 and 7.
  - Save and close the file.
- Create a shortcut to HotSRez.cmd on your desktop by right-click dragging the file to your desktop, then select "Create shortcut here".
- [Optional] Rename the shortcut.
- Double-click the shortcut to change resolution and launch HotS.
