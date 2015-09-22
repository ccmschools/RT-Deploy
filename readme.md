RT-Deploy
=========

This system allows you to provision Surface RTs with various settings: 
local group policy, scheduled tasks, scripts, registry files, time settings, 
unattend.xml, sysprep, local files, etc

After provisioning you can manage the Surfaces through powershell login and startup scripts.

This solution has been adapted from technet here: https://technet.microsoft.com/en-us/library/dn645488.aspx

There's still some things to be refined and documented, however the solution has good foundations to build it on.

Initial Configuration
---------------------

Copy the files to a file server and name the share "rt-deploy$".

Create a user "rt-deploy" that has read only permissions to this share.
Restrict the user from accessing the "scripts\provision", 
"scripts\capture", and "resources\sysprep" directories to prevent any
breaches in confidentiality (although minor).

Give your IT staff read-only access to all files, and your systems admin full access.

Rename the file "sample_settings.config" to "settings.config" and fill it with info related to your environment.

Set up a DNS record for "rt-deploy" to your file server with the "rt-deploy$" share.

Capture Steps
-------------

	ToDo

Provisioning Steps
------------------

	1. Copy the file "scripts\provision\provision.cmd" to a USB drive.

	2. Ensure the device is in a clean / reset state (instructions to do this here: http://www.microsoft.com/surface/en-au/support/warranty-service-and-recovery/refresh-or-reset-surface-rt?os=windows-8.1-rt-update-3#resetRT10)
	
	3. Put the device into audit mode at the OOBE screen by pressing Ctrl+Shift+F3 (on the surface keyboards you need to press the "fn" key too).
	
	4. Connect the device to your network to access your rt-deploy$ share
	
	5. Insert the USB and run the provision.cmd script. Input your IT staff account details when asked and let the script run.
	
	6. The device will restart, then shutdown ready for delivery to a user

Management Steps
----------------

	ToDo