# Instant-Hotspot
Instant Hotspot Tool as Simple Application for Windows

## Notes: I created this script during the Windows 8 era and is compatible with older OSes like Windows XP and Windows 7 when the operating system did not have a built-in hotspot feature.

## Use Cases

- Use your Laptop (or PC with WiFi adapter) as a WiFi Hotspot to share internet.
- During power outages or when your router isn't working, use your laptop as a Hotspot to share internet with mobile devices.
- Share files on LAN or continue important chats on mobile during internet disruptions.
- Made using simple Windows Commands as an executable file, making it a cool hackish application.
- Also can use it as a WiFi to WiFi Extender.

## Features

- Create a Wi-Fi hotspot with a custom SSID and password.
- Start and stop the Wi-Fi hotspot.
- View the status and security information of the hotspot.
- List devices connected to the hotspot.
- Change the hotspot password.
- Option to set the hotspot as temporary or permanent.

## Usage

1. **Run the Script**: Double-click the batch file to run it. Make sure to run it as an administrator.
2. **Interactive Menu**: Follow the on-screen instructions to create, start, stop, or manage the hotspot.

## Menu Options

1. **Create Hotspot**: Set up a new hotspot with a custom SSID and password.
2. **Start Hotspot**: Start the previously created hotspot.
3. **Stop Hotspot**: Stop the running hotspot.
4. **Status and Security Info**: View the current status and security settings of the hotspot.
5. **List of Devices on Network**: Display a list of devices currently connected to the hotspot.
6. **Change Password**: Change the password for the hotspot.

## Requirements

- Windows operating system.
- Administrator privileges to run the script.

## Notes

- This script was created during the Windows 8 era when the operating system did not have a built-in hotspot feature.
- To share the internet connection, open Network and Sharing Center, select your working internet connection, go to Properties, switch to the Sharing tab, and select the created hotspot (Microsoft Hosted Virtual Adapter).
- The script uses `netsh` commands to manage the hotspot.

## License

This project is licensed under the MIT License.
