# Compliance Prioritizer Setup Guide

This guide helps you prepare for using the `compliance-prioritizer` agent with different data sources.

## Option 1: Export File (Easiest)

### From Tenable.io UI:
1. Navigate to **Scans** → Select your compliance scan
2. Click **Export** → Choose format:
   - **CSV** (recommended) - Easy to parse
   - **JSON** - Full detail
   - **XML** - Alternative format
3. Download the file
4. Note the file path for the agent

### From Tenable.sc UI:
1. Navigate to **Scan Results** → Select compliance scan
2. Click **Export** → Choose format
3. Download and save locally

**Usage:**
```
Agent: "Analyze compliance scan from /path/to/export.csv"
```

---

## Option 2: Tenable API

### A. Create Read-Only API Keys

#### For Tenable.io (Cloud):
1. Log in to https://cloud.tenable.com
2. Navigate to **Settings** (gear icon) → **My Account** → **API Keys**
3. Click **Generate** or **Create API Key**
4. **Name:** "Compliance Prioritizer - Read Only"
5. **Permissions:** Select these minimum permissions:
   - ✅ Read Scans
   - ✅ Read Assets
   - ✅ Read Compliance
6. Copy both:
   - **Access Key** (starts with similar pattern to: `abc123...`)
   - **Secret Key** (longer, keep secure)
7. Store securely (password manager, encrypted note)

#### For Tenable.sc (SecurityCenter):
1. Log in to your SecurityCenter instance
2. Navigate to **Users** → Your username → **API Keys**
3. Click **Generate API Key**
4. **Name:** "Compliance Prioritizer"
5. **Permissions:** Read-only role
6. Copy Access Key and Secret Key
7. Note your SecurityCenter URL (e.g., `https://tenable.company.com`)

### B. Using the API Keys

The agent will prompt you step-by-step:

**For Tenable.io:**
```
1. Platform: io
2. Access Key: [paste your access key]
3. Secret Key: [paste your secret key]
4. What to analyze: 
   - Scan ID (found in scan URL or scan list)
   - Asset UUID (from asset details)
   - Asset group name
```

**For Tenable.sc:**
```
1. Platform: sc
2. Instance URL: https://your-sc-instance.com
3. Access Key: [paste]
4. Secret Key: [paste]
5. Scan Result ID or Asset ID
```

### C. Finding Scan/Asset IDs

#### Tenable.io Scan ID:
- Navigate to scan in UI
- URL shows: `https://cloud.tenable.com/scans/12345`
- Scan ID = `12345`

#### Tenable.io Asset UUID:
- Navigate to **Assets** → Click asset
- URL shows: `https://cloud.tenable.com/.../{uuid}`
- Or use API: `GET /assets` to list

#### Tenable.sc Scan Result ID:
- Check scan result properties
- Or use API: `GET /scanResult` to list

---

## Option 3: Tenable MCP Server

### A. Check if MCP Server is Connected

From Claude Code, the agent will automatically check if your Tenable MCP server is available.

### B. If Not Connected, Set Up MCP Server

MCP servers are configured in your Claude Code settings:

1. Open `~/.claude/config.json` or use Claude Code settings UI
2. Add Tenable MCP server configuration:

```json
{
  "mcpServers": {
    "tenable": {
      "command": "tenable-mcp-server",
      "args": [],
      "env": {
        "TENABLE_ACCESS_KEY": "your-access-key",
        "TENABLE_SECRET_KEY": "your-secret-key",
        "TENABLE_URL": "https://cloud.tenable.com"
      }
    }
  }
}
```

3. Restart Claude Code
4. MCP server will auto-connect with stored credentials

**Note:** MCP server setup is one-time. After configuration, the agent can use it without asking for credentials each time.

---

## Comparison: Which Method to Use?

| Method | Pros | Cons | Best For |
|--------|------|------|----------|
| **Export File** | Simple, no API setup, works offline | Manual export, no real-time data | One-time analysis, air-gapped environments |
| **API** | Real-time data, can query any scan/asset, automated | Requires API keys, network access | Regular analysis, automation, multiple assets |
| **MCP Server** | One-time setup, credentials stored securely, fastest | Initial setup required, requires MCP-compatible tool | Frequent use, integrated workflows |

---

## Security Best Practices

### API Key Management
- ✅ **DO:** Use read-only API keys with minimum permissions
- ✅ **DO:** Store keys in password manager or encrypted vault
- ✅ **DO:** Create dedicated keys per tool/purpose
- ✅ **DO:** Rotate keys periodically (every 90 days)
- ❌ **DON'T:** Share keys via email, Slack, or unencrypted files
- ❌ **DON'T:** Commit keys to git repositories
- ❌ **DON'T:** Use admin/write-enabled keys for read-only tasks

### Agent Credential Handling
The compliance-prioritizer agent:
- Requests credentials interactively (not stored in prompts)
- Uses credentials only for immediate API calls
- Clears credentials from memory after execution
- Never logs or writes credentials to disk
- Uses HTTPS for all API communication

### Network Considerations
- Tenable.io API: Requires internet access to `cloud.tenable.com`
- Tenable.sc API: Requires network access to your on-prem instance
- Firewalls: Ensure outbound HTTPS (443) is allowed
- Proxies: May need proxy configuration for API calls

---

## Troubleshooting

### "Authentication Failed" (401 Error)
- ✅ Verify Access Key and Secret Key are correct
- ✅ Check key hasn't expired
- ✅ Ensure key has required permissions
- ✅ For Tenable.sc, verify instance URL is correct

### "Forbidden" (403 Error)
- ✅ API key lacks required permissions
- ✅ Create new key with Read Scans, Read Assets, Read Compliance

### "Scan Not Found" (404 Error)
- ✅ Verify Scan ID is correct
- ✅ Ensure scan is in your account/container
- ✅ Check if scan has completed (not running/pending)

### "Rate Limited" (429 Error)
- ✅ Wait 60 seconds and retry
- ✅ Agent will automatically retry with backoff
- ✅ Reduce concurrent requests if running multiple analyses

### "MCP Server Not Connected"
- ✅ Check MCP server configuration in settings
- ✅ Verify MCP server process is running
- ✅ Check MCP server logs for errors
- ✅ Restart Claude Code to reconnect

### "No Compliance Results Found"
- ✅ Verify scan includes compliance checks (not just vulnerability scan)
- ✅ Check scan policy includes compliance audit files
- ✅ Ensure scan completed successfully
- ✅ For policy compliance, verify credentials were provided

---

## Example Invocations

### Quick Start - File Export
```
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Analyze /Users/me/Downloads/windows_compliance_scan.csv"
})
```

### Real-Time - API (Tenable.io)
```
Agent({
  subagent_type: "compliance-prioritizer", 
  prompt: "Fetch and analyze compliance results for scan ID 12345 from Tenable.io"
})
# Agent will prompt for API keys interactively
```

### Enterprise - MCP Server
```
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Use Tenable MCP to analyze compliance for asset group 'Production-Databases'"
})
```

### Multi-Asset Analysis
```
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Get compliance results from Tenable.io for all assets tagged 'pci-scope' and prioritize by risk"
})
```

---

## Getting Help

- **Tenable API Docs:** https://developer.tenable.com/
- **Tenable.io API:** https://developer.tenable.com/reference/navigate
- **Tenable.sc API:** https://docs.tenable.com/security-center/api/
- **MCP Protocol:** https://modelcontextprotocol.io/

If you encounter issues with the agent, check:
1. Your API keys are valid and have correct permissions
2. Network connectivity to Tenable instance
3. Scan/asset IDs are correct
4. Scan includes compliance checks (not just vulnerabilities)
