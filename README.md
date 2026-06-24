# Compliance Prioritizer Agent

**AI-powered risk-based prioritization for Tenable VM compliance benchmark failures**

## 🚀 New User? Start Here

**[→ Installation & Usage Guide (INSTALL.md)](INSTALL.md)** - Complete walkthrough for installing and running this agent in Claude Code

Already installed? Jump to [Quick Start](#quick-start) below.

## Overview

The `compliance-prioritizer` agent analyzes Tenable Vulnerability Management compliance scan results and intelligently prioritizes failed benchmarks based on:

- **Business Impact** (35%): What does this control protect?
- **Asset Criticality** (35%): How important is the affected system?
- **Remediation Ease** (20%): How hard is it to fix?
- **Exploitability** (10%): Can this be exploited remotely?

## Quick Start

**First time?** See [INSTALL.md](INSTALL.md) for complete installation and usage instructions.

### Basic Usage (Export File)

From within a Claude Code conversation, use natural language:

```
Run the compliance-prioritizer agent on the file /path/to/scan.csv
```

**Or use the direct agent invocation** (Claude Code handles this automatically):

```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Analyze the compliance scan from /path/to/scan.csv"
})
```

The agent will generate 4 comprehensive reports automatically.

> **Note**: You don't type the JavaScript code yourself - just tell Claude Code in natural language what you want to analyze, and it will invoke the agent for you.

## Data Sources

The agent supports **three input methods**:

### 1. Export File (Simplest)
- Export CSV/JSON from Tenable UI
- Provide file path to agent
- Works offline, no API setup needed

### 2. Tenable API (Real-time)
- Direct connection to Tenable.io or Tenable.sc
- Fetch latest scan results automatically
- Requires API keys (read-only recommended)

### 3. Tenable MCP Server (Most Integrated)
- One-time MCP server setup
- Credentials stored securely in config
- Fastest for repeated use

## Setup Instructions

### For Export File Method
No setup required! Just export your scan and provide the path.

### For API Method

**Step 1: Generate API Keys**

**Tenable.io:**
1. Login → Settings → My Account → API Keys
2. Click "Generate API Key"
3. Name: "Compliance Prioritizer"
4. Permissions: Read Scans, Read Assets, Read Compliance
5. Copy Access Key and Secret Key

**Tenable.sc:**
1. Login → Users → Your Profile → API Keys
2. Generate new key with read-only role
3. Note your SecurityCenter URL

**Step 2: Test Connection (Optional)**
```bash
cd ~/.claude/agents
./test-tenable-api.sh
```

**Step 3: Use with Agent**
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Fetch compliance results from Tenable.io for scan ID 12345"
})
```

The agent will prompt for your API keys interactively.

### For MCP Method

**Step 1: Configure MCP Server**

Add to your `~/.claude/config.json`:

```json
{
  "mcpServers": {
    "tenable": {
      "command": "tenable-mcp-server",
      "env": {
        "TENABLE_ACCESS_KEY": "your-access-key",
        "TENABLE_SECRET_KEY": "your-secret-key",
        "TENABLE_URL": "https://cloud.tenable.com"
      }
    }
  }
}
```

**Step 2: Restart Claude Code**

**Step 3: Use with Agent**
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Use Tenable MCP to analyze asset group 'Production-Servers'"
})
```

## Output Reports

The agent generates **4 comprehensive reports**:

### 1. CSV Ranked List
- Complete prioritized list of all failed checks
- Sortable by risk score, category, complexity
- Import into Excel/Google Sheets for filtering

**Example:**
```csv
Rank,Risk Score,Check ID,Title,Host,Business Impact,Asset Criticality,...
1,6.65,9.2.5,Windows Firewall: Private Logging,win11,9,6,...
2,6.65,18.10.57.3.10.1,RDP Session Timeout,win11,9,6,...
```

### 2. Detailed Markdown Report
- Executive summary with statistics
- Risk distribution visualizations (ASCII charts)
- Top 20 detailed findings with context
- Three-phase remediation roadmap

**Includes:**
- Why each finding matters to the business
- Risk score breakdown
- Category classification
- Complexity assessment

### 3. Interactive HTML Dashboard
- Styled, sortable tables
- Visual risk scoring charts
- Color-coded priority levels
- Open in browser for best experience

### 4. Actionable Remediation Plan
- Step-by-step fix instructions
- Grouped by complexity:
  - **Quick Wins**: 0-2 weeks (GPO changes)
  - **Short-term**: 2-8 weeks (moderate effort)
  - **Long-term**: 2-6 months (hardware/architecture)
- Testing methodology
- Success metrics

## Risk Scoring Framework

### Formula
```
Risk Score = (Business Impact × 0.35) + (Asset Criticality × 0.35) + 
             (Remediation Ease × 0.20) + (Exploitability × 0.10)
```

### Business Impact (0-10)
- **9-10 (Critical)**: Financial data, PII, authentication systems
- **7-8 (High)**: Regulatory compliance, data integrity
- **4-6 (Medium)**: Security hardening, access controls
- **1-3 (Low)**: Documentation, non-critical configs

### Asset Criticality (0-10)
- **9-10 (Critical)**: Prod DBs, domain controllers, public systems
- **7-8 (High)**: App servers, file servers
- **4-6 (Medium)**: Dev/staging, workstations
- **1-3 (Low)**: Test systems, isolated workstations

### Remediation Complexity
- **Easy (3 points)**: GPO changes, config updates
- **Medium (2 points)**: Application updates
- **Hard (1 point)**: Architecture changes, hardware upgrades

### Exploitability
- Based on remote accessibility and known CVEs
- Higher weight for internet-facing or remote-exploitable

## Example Use Cases

### Use Case 1: New Compliance Scan Analysis
```javascript
// You just ran a CIS benchmark scan on 50 Windows servers
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: `Analyze compliance scan export at ./scans/windows_cis_scan.csv
           
           Context: These are production application servers (criticality: 8/10)
           hosting customer-facing web applications with PCI data.`
})

// Result: Prioritized list focusing on PCI-relevant controls
```

### Use Case 2: Continuous Compliance Monitoring
```javascript
// Weekly automated check via API
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: `Fetch latest compliance results from Tenable.io for 
           asset group 'PCI-Scope' and generate weekly report.
           
           Focus on failed checks that changed since last week.`
})

// Result: Tracks compliance drift over time
```

### Use Case 3: Pre-Audit Preparation
```javascript
// 30 days before SOC 2 audit
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: `Analyze all compliance scans for assets tagged 'in-scope'
           
           Context: SOC 2 Type II audit in 30 days
           Priority: High-risk findings that auditors will flag`
})

// Result: Focused remediation plan for audit readiness
```

### Use Case 4: Risk Acceptance Decisions
```javascript
// Quarterly risk review
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: `Analyze compliance scan for legacy manufacturing systems
           
           Context: Asset criticality: 5/10 (isolated OT network)
           Need: Identify which failures can be risk-accepted vs must-fix`
})

// Result: Risk-ranked list for risk acceptance committee
```

## Advanced Features

### Custom Asset Criticality
Override default scoring by providing context:

```javascript
prompt: `Analyze scan.csv
         
         Asset context:
         - db-prod-01: criticality 10/10 (customer database)
         - app-staging-02: criticality 3/10 (isolated staging)
         - web-dmz-03: criticality 9/10 (internet-facing)`
```

### Multiple Asset Analysis
Analyze consolidated scans across environments:

```javascript
prompt: `Analyze compliance across all environments:
         - Production: scan_prod.csv
         - Staging: scan_staging.csv  
         - Development: scan_dev.csv
         
         Generate consolidated report with environment-specific priorities`
```

### Compliance Framework Focus
Target specific frameworks:

```javascript
prompt: `Analyze scan.csv focusing on PCI-DSS requirements
         
         Highlight findings mapped to PCI requirements 10.x (logging)
         and 8.x (access control)`
```

## Troubleshooting

### Common Issues

**"No failed checks found"**
- Verify scan is a compliance scan (not vulnerability scan)
- Check scan policy includes compliance audit files
- Ensure scan completed successfully

**"API Authentication Failed"**
- Verify API keys are correct (no extra spaces)
- Check key hasn't expired
- Ensure key has Read permissions

**"Rate Limited"**
- Wait 60 seconds and retry
- Agent automatically implements backoff
- Reduce concurrent analysis if running multiple

**"MCP Server Not Connected"**
- Check MCP configuration in settings
- Restart Claude Code
- Verify MCP server process is running

### Getting Support

1. Review setup guide: `compliance-prioritizer-setup-guide.md`
2. Test API connection: `./test-tenable-api.sh`
3. Check Tenable API docs: https://developer.tenable.com/

## Security & Privacy

### Credential Handling
- ✅ API keys requested interactively (not in prompts)
- ✅ Used only during execution, then cleared
- ✅ Never logged or persisted to disk
- ✅ All API calls use HTTPS/TLS

### Best Practices
- Use read-only API keys
- Minimum required permissions (Read Scans, Read Compliance)
- Rotate keys every 90 days
- Store keys in password manager
- Create dedicated keys per tool

### Data Privacy
- Scan data processed locally
- No data sent to external services (except Tenable API)
- Reports saved to local filesystem only

## Files Included

```
~/.claude/agents/
├── compliance-prioritizer.md              # Main agent definition
├── compliance-prioritizer-README.md       # This file
├── compliance-prioritizer-setup-guide.md  # Detailed setup instructions
└── test-tenable-api.sh                    # API connection test script
```

## Real-World Example

**Scenario**: Security team runs weekly Windows CIS compliance scans across 200 workstations.

**Before**: 
- 861 failed checks per workstation × 200 = 172,200 findings
- No clear prioritization
- Team picks randomly or by severity only
- Critical gaps remain unaddressed

**With compliance-prioritizer**:
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Analyze Windows_Workstation_Compliance.csv"
})
```

**Results**:
- 861 failures prioritized by risk score
- 839 are "Quick Wins" (97.4%) via Group Policy
- Top 20 high-risk items identified
- 3-phase remediation plan: 2 weeks → 8 weeks → 6 months
- Clear ROI: Focus on 20% of changes for 80% risk reduction

**Outcome**:
- Compliance score improved 65% in first month
- Focused effort on business-critical gaps
- Clear metrics for leadership
- Audit-ready documentation

## Version History

- **v1.0** - Initial release with export file support
- **v1.1** - Added Tenable.io API integration
- **v1.2** - Added Tenable.sc (SecurityCenter) support
- **v1.3** - Added MCP server integration
- **v1.4** - Enhanced risk scoring with exploitability factor

## License

This agent is provided as-is for use with Claude Code. Modify as needed for your environment.

---

**Questions?** Review the setup guide or test your API connection with the included test script.
