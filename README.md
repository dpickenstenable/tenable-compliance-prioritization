# Compliance Prioritizer

AI-powered risk-based prioritization for Tenable VM compliance benchmark failures.

Analyzes compliance scan results and ranks failed benchmarks using a weighted risk score based on business impact, asset criticality, remediation ease, and exploitability — then generates actionable reports to focus your team on what matters most.

## Installation

Clone this repository and copy the skill files into your Claude Code skills directory:

```bash
git clone https://github.com/dpickenstenable/tenable-compliance-prioritization.git
mkdir -p ~/.claude/skills/compliance-prioritizer
cp tenable-compliance-prioritization/compliance-prioritizer/* ~/.claude/skills/compliance-prioritizer/
chmod +x ~/.claude/skills/compliance-prioritizer/test-tenable-api.sh
```

Verify installation:

```bash
ls ~/.claude/skills/compliance-prioritizer/SKILL.md
```

## Usage

From within a Claude Code conversation, invoke the skill with `/compliance-prioritizer` followed by a natural language description of what you want to analyze.

### Using an exported file (simplest, no setup)

Export a compliance scan as CSV or JSON from the Tenable UI, then:

```
/compliance-prioritizer Analyze /path/to/Windows_Compliance_Scan.csv
```

### Using the Tenable API (real-time)

```
/compliance-prioritizer Fetch compliance results from Tenable.io for scan ID 12345
```

The skill will prompt you interactively for your API access key and secret key. Use read-only keys with minimum permissions (Read Scans, Read Assets, Read Compliance).

### Using a Tenable MCP server

If you have a Tenable MCP server configured in `~/.claude/config.json`:

```
/compliance-prioritizer Use Tenable MCP to analyze asset group 'Production-Servers'
```

## Providing context for better results

The skill produces better prioritization when you provide asset context:

```
/compliance-prioritizer Analyze scan.csv

Asset context:
- db-prod-01: criticality 10/10 (customer database, PCI scope)
- app-staging-02: criticality 3/10 (isolated staging)
- web-dmz-03: criticality 9/10 (internet-facing)

Focus on PCI-DSS requirements. We have an audit in 30 days.
```

## Output

Each run generates four reports in your current directory:

| Report | Format | Purpose |
|--------|--------|---------|
| `*_prioritization.csv` | CSV | Sortable ranked list of all failures by risk score |
| `*_report.md` | Markdown | Executive summary, risk distribution, top 20 findings |
| `*_report.html` | HTML | Interactive dashboard with color-coded priorities |
| `*_remediation_plan.md` | Markdown | Step-by-step fixes grouped by timeline |

The remediation plan groups findings into three phases:
- **Quick Wins** (0-2 weeks): GPO changes, config updates
- **Short-term** (2-8 weeks): Application updates, moderate effort
- **Long-term** (2-6 months): Architecture changes, hardware upgrades

## Risk scoring

Each failed benchmark is scored using:

```
Risk Score = (Business Impact x 0.35) + (Asset Criticality x 0.35) +
             (Remediation Ease x 0.20) + (Exploitability x 0.10)
```

| Factor | Weight | Scale |
|--------|--------|-------|
| Business Impact | 35% | 0-10: what does the control protect? |
| Asset Criticality | 35% | 0-10: how important is the affected system? |
| Remediation Ease | 20% | 1-3: inverse complexity (easier = higher priority) |
| Exploitability | 10% | Based on remote accessibility and known CVEs |

## Tenable API setup

If you want to use the API method instead of file exports:

**Tenable.io:** Settings > My Account > API Keys > Generate. Grant Read Scans, Read Assets, Read Compliance.

**Tenable.sc:** Users > Your Profile > API Keys > Generate with read-only role. Note your SecurityCenter URL.

**Test your connection (optional):**

```bash
~/.claude/skills/compliance-prioritizer/test-tenable-api.sh
```

## MCP server setup

Add to `~/.claude/config.json`:

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

Restart Claude Code after adding the configuration.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Skill not found | Verify `~/.claude/skills/compliance-prioritizer/SKILL.md` exists |
| No compliance data found | Confirm the scan is a compliance scan, not a vulnerability scan |
| API authentication failed | Regenerate keys with correct permissions, check for trailing spaces |
| Rate limited | Wait 60 seconds; the skill retries automatically with backoff |
| MCP server not connected | Check config in `~/.claude/config.json`, restart Claude Code |

## Security

- API keys are requested interactively and cleared from memory after use
- Keys are never logged or persisted to disk
- All API calls use HTTPS/TLS
- Scan data is processed locally; reports are saved to your local filesystem only

## License

MIT
