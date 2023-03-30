# Generate Monthly Rotating Wi-Fi Password Signage

1. Copy the _.env.example_ file to _.env_, and edit the NETWORK_NAME variable to match your desired SSID.
2. Run the _mkcsv.sh_ shell script to automatically generate a CSV file suitable for use in Adobe InDesign's _Data Merge_ tool.
3. Open the _qrcodes.indd_ file. In InDesign's Data Merge panel, choose **Select Data Source**, then choose the _passwords.csv_ file.
4. Choose **Create Merged Document**.

---

## Manually Create a CSV

If you don't have access to a Bash prompt, you can still use the .indd file as a template if you manually create the CSV file.

### Step 1: Generate Passwords

Use a password generator tool to generate 12 random passwords.

Here's the URL for a web-based password generator API:

```
https://makemeapassword.ligos.net/api/v1/alphanumeric/plain?c=12
```

Here is a Bash one-liner to achieve a similar result:

```
for i in {1..12}; do cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 8 | sed 1q; done
```

### Step 2: Update CSV file

Paste the newly-generated passwords into the Passwords column of the passwords.csv file in this repository.

WIFI:S:Your-SSID;T:WPA;P:hunter2;;