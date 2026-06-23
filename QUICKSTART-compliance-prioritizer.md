# Compliance Prioritizer - Quick Start

Get started in 3 minutes with any of these methods.

## Method 1: Export File (Easiest - No Setup)

### Step 1: Export your scan
From Tenable UI: **Scans → Your Compliance Scan → Export → CSV**

### Step 2: Run the agent
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Analyze /path/to/your/scan.csv"
})
```

### Step 3: View reports
Check your directory for 4 generated reports:
- `*_prioritization.csv` - Ranked list
- `*_report.md` - Detailed analysis  
- `*_report.html` - Visual dashboard
- `*_remediation_plan.md` - Fix instructions

**Done!** ✅

---

## Method 2: Tenable API (Real-time Data)

### Step 1: Get API keys (2 minutes)

**Tenable.io:**
1. Login → Settings → API Keys → Generate
2. Name: "Compliance Prioritizer"
3. Permissions: ✅ Read Scans ✅ Read Compliance
4. Copy Access Key + Secret Key

**Tenable.sc:**
1. Login → Users → API Keys → Generate
2. Role: Read-only
3. Copy keys + note your SC URL

### Step 2: Test connection (optional)
```bash
cd ~/.claude/agents
./test-tenable-api.sh
```

### Step 3: Run the agent
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Fetch compliance results from Tenable.io for scan ID 12345"
})
```

Agent will prompt for:
- Platform (io/sc)
- Access Key
- Secret Key
- SC URL (if sc)

**Done!** ✅

---

## Method 3: MCP Server (Best for Repeated Use)

### Step 1: Configure MCP (one-time, 3 minutes)

Edit `~/.claude/config.json`:
```json
{
  "mcpServers": {
    "tenable": {
      "command": "tenable-mcp-server",
      "env": {
        "TENABLE_ACCESS_KEY": "your-key",
        "TENABLE_SECRET_KEY": "your-secret",
        "TENABLE_URL": "https://cloud.tenable.com"
      }
    }
  }
}
```

### Step 2: Restart Claude Code

### Step 3: Use anytime
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Use Tenable MCP to analyze scan 12345"
})
```

**Done!** No need to enter keys each time ✅

---

## What You Get

Every run generates **4 reports**:

### 1. CSV Spreadsheet
Sortable ranked list of all failed checks with risk scores

### 2. Executive Report (Markdown)
- Summary statistics
- Risk distribution charts
- Top 20 detailed findings
- 3-phase remediation roadmap

### 3. HTML Dashboard
Interactive visual report - open in browser

### 4. Remediation Plan
Step-by-step instructions grouped by:
- Quick Wins (0-2 weeks)
- Short-term (2-8 weeks)  
- Long-term (2-6 months)

---

## Finding Your Scan ID

### Tenable.io
Scan URL: `https://cloud.tenable.com/scans/12345`
→ Scan ID = **12345**

### Tenable.sc
Check scan properties or use test script to list scans

---

## Common First Runs

### Just ran a Windows compliance scan?
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Analyze Windows_Compliance_Scan.csv"
})
```

### Need to analyze production servers?
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: `Fetch from Tenable.io scan ID 12345
  
  Context: Production web servers (criticality: 9/10) with PCI data`
})
```

### Weekly compliance check?
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Use MCP to get latest compliance for asset group 'Production'"
})
```

---

## Tips

💡 **Provide context** for better prioritization:
```javascript
prompt: `Analyze scan.csv

Asset context: These are production database servers (criticality: 10/10)
handling customer PII and payment data.`
```

💡 **Test API before big runs**:
```bash
./test-tenable-api.sh
```

💡 **Start with export file** to see how it works, then move to API for automation

💡 **Use HTML report** for presenting to management - it's visual and interactive

---

## Help

- **Full docs:** `compliance-prioritizer-README.md`
- **Setup guide:** `compliance-prioritizer-setup-guide.md`
- **Test API:** `./test-tenable-api.sh`
- **Tenable API docs:** https://developer.tenable.com/

---

## Tested With

✅ Windows CIS Benchmarks  
✅ Linux CIS Benchmarks  
✅ Custom compliance policies  
✅ STIG compliance checks  
✅ PCI-DSS audit files  

Works with any Tenable compliance scan format!
