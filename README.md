# Endpoint Hunt Package
The endpoint hunt package is used to be an install script for endpoint monitoring tools. Sysmon and the Splunk Universal forwarder are written into the script. The `install.bat` script is prepped for Carbon Black but none of the installation files are included. Feel free to modify and include any other tools you wish (EDR, etc.).

The supplied batch script is the more flexible option for installation of the agents across a customer's enterprise. This package applies to a Windows environment.

## Usage
There are three scripts included in this repo:

```
- setup.ps1
- install.bat
- uninstall.bat
```

Run the `setup.ps1` script to download the latest [Sysmon package](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon), Sysmon configuration file ([Olaf Hartong's](https://github.com/olafhartong/sysmon-modular)), and [Splunk Universal Forwarder](https://www.splunk.com/en_us/download.html).

The PowerShell script will create the necessary folders and place the install files in their respective folders.

If you have issues running the setup script, make sure you unblock the file and set the execution policy as necessary:

```PowerShell
PS C:\> Unblock-File -Path.\setup.ps1
PS C:\> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
PS C:\>.\setup.ps1
```

## Edits
PRIOR TO RUNNING THE BATCH SCRIPT, you MUST edit the `splunk_dep_svr` variable in the `install.bat` file to reflect the accessible IP from the perspective of the host that will have the UF installed on. For example, if network traffic must past through a firewall coming from the host to the Splunk server (and port forwarding is configured), the variable would be set to the address of the FW. Change the ports used as necessary.

Be sure to run the installation in a TEST environment before running in production.

## Deployment
Once the `setup.ps1` script has been run appropriate edits made to the `install.bat` script, the `HuntPkg` folder can be delivered to your customer for deployment. 

There are a few methods of deployment:

### 1. DEPLOYMENT via GPO:

- Stage the `HuntPkg` folder on a shared drive that is available and mapped to all hosts that will receive the agents.
- Create a GPO that will configure a Scheduled Task
- Configure the scheduled task to run the `install.bat` script immediately.

### 2. DEPLOYMENT via PowerShell:

This method can be accomplished via the `Enter-PsSession` cmdlet or psexec. The use of `Enter-PsSession` requires `PSRemoting` to be enabled in the environment.

### 3. Misc

Other possible methods of deployment can be achieved using SCCM or configuration management software like Ansible. The not-so-preferred method, but will get the job done is to walk around with a thumbdrive.

## Uninstall

Uninstallation of agents are straightforward, nothing should be edited in the scripts unless changes were made to the `install.bat` script. Use the same deployment method and reference the `uninstall.bat` script.