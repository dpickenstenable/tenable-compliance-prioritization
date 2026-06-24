# Installation & Usage Guide

This guide explains how to install and run the Compliance Prioritizer agent in Claude Code.

## What You Need

1. **Claude Code** - The CLI, desktop app, or web interface at claude.ai/code
2. **A Tenable compliance scan** - Either an exported file or API access

## Installation

### Option 1: Install from Repository (Recommended)

If this agent is available in the claude-gsd repository:

```bash
# From Claude Code prompt
/install compliance-prioritizer
```

The agent will be automatically installed to `~/.claude/agents/`

### Option 2: Manual Installation

1. Clone or download this repository:
   ```bash
   cd ~/.claude/agents
   git clone https://github.com/dpickenstenable/tenable-compliance-prioritization.git
   ```

2. Copy the agent definition file:
   ```bash
   cp tenable-compliance-prioritization/compliance-prioritizer.md ~/.claude/agents/
   ```

3. Verify installation:
   ```bash
   ls ~/.claude/agents/compliance-prioritizer.md
   ```

## How to Run the Agent

The agent runs **inside Claude Code** conversations. You interact with it through natural language prompts.

### Step 1: Start Claude Code

Open Claude Code in your preferred interface:
- **CLI**: Run `claude` in your terminal
- **Desktop**: Launch the Claude Code app
- **Web**: Visit claude.ai/code

### Step 2: Navigate to Your Scan Data

```bash
# In Claude Code, navigate to where your scan file is located
cd /path/to/your/scans
```

Or if using API method, no navigation needed.

### Step 3: Run the Agent

#### Method A: Using an Exported File

In the Claude Code conversation, type:

```
Please run the compliance-prioritizer agent on the file Windows_Compliance_Scan.csv
```

Or be more specific:

```
Use Agent with subagent_type "compliance-prioritizer" to analyze 
/Users/me/Downloads/Windows_Compliance_Scan.csv
```

**Behind the scenes**, Claude Code will execute:
```javascript
Agent({
  subagent_type: "compliance-prioritizer",
  prompt: "Analyze /Users/me/Downloads/Windows_Compliance_Scan.csv"
})
```

#### Method B: Using Tenable API

In the Claude Code conversation, type:

```
Run the compliance-prioritizer agent to fetch and analyze 
scan ID 12345 from my Tenable.io account
```

The agent will interactively prompt you for:
- Platform selection (Tenable.io or Tenable.sc)
- API Access Key
- API Secret Key
- Scan/Asset ID to analyze

#### Method C: Using MCP Server (if configured)

First, verify your MCP server is connected:

```
Check if my Tenable MCP server is connected
```

Then run:

```
Use the compliance-prioritizer agent with my Tenable MCP 
server to analyze asset group "Production-Servers"
```

### Using Opus Model for More Thorough Analysis

By default, agents run with the Sonnet model. For more comprehensive, thorough analysis, you can upgrade to the **Opus model with high effort**.

**When to use Opus:**
- Complex compliance scans with 500+ failed checks
- Need deeper analysis and more detailed recommendations
- Want exhaustive remediation plans with step-by-step details
- Preparing for audits requiring comprehensive documentation
- First-time analysis of a new environment

**How to use Opus:**

In your Claude Code conversation, specify the model before invoking the agent:

```
Switch to Opus model

Then run the compliance-prioritizer agent on Windows_Compliance_Scan.csv 
with high effort analysis
```

**Or use the direct command:**

```
/model opus

Run the compliance-prioritizer agent with comprehensive analysis 
on Windows_Compliance_Scan.csv
```

**What changes with Opus + high effort:**
- ✅ More detailed risk analysis for each finding
- ✅ Deeper context about why each failure matters
- ✅ More comprehensive remediation instructions
- ✅ Additional cross-references between related findings
- ✅ More thorough testing and validation steps
- ✅ Longer, more detailed reports (expect 2-3x length)

**Trade-offs:**
- ⏱️ Takes longer to complete (2-5x slower than Sonnet)
- 💰 Uses more tokens (higher cost)
- 📄 Generates longer reports (more to read)

**Recommendation:** Start with Sonnet for quick weekly scans, use Opus for quarterly deep-dives or audit preparation.

## What Happens When You Run It

1. **Agent starts**: Claude Code spawns the compliance-prioritizer agent
2. **Data collection**: Agent fetches or reads your compliance scan data
3. **Analysis**: Agent applies risk scoring algorithm to all failed checks
4. **Report generation**: Creates 4 comprehensive reports in your current directory:
   - `{scan_name}_prioritization.csv` - Sortable ranked list
   - `{scan_name}_report.md` - Executive summary with details
   - `{scan_name}_report.html` - Interactive dashboard
   - `{scan_name}_remediation_plan.md` - Step-by-step fixes

5. **Summary**: Agent provides a summary of findings and next steps

## Complete Example Walkthrough

### Scenario: You just exported a Windows CIS compliance scan

**Step 1**: Start Claude Code
```bash
claude
```

**Step 2**: Navigate to your download folder
```
cd ~/Downloads
```

**Step 3**: Confirm your file is there
```
ls *.csv
```

**Step 4**: Run the agent with natural language
```
Please analyze the Windows CIS compliance scan in 
Windows_Workstation_CIS_Benchmark_20240624.csv using the compliance-prioritizer agent.

Context: These are production workstations (criticality: 7/10) 
used by the finance team handling sensitive data.
```

**Step 5**: Wait for analysis (usually 1-3 minutes)

**Step 6**: Review the generated reports
```
ls -lh Windows_Workstation_*
```

**Step 7**: Open the HTML report in your browser
```
open Windows_Workstation_CIS_Benchmark_20240624_report.html
```

## Advanced Usage

### Providing Context for Better Prioritization

```
Run compliance-prioritizer on production_db_scan.csv

Asset context:
- All hosts are production database servers (criticality: 10/10)
- Handle customer PII and payment card data (PCI scope)
- Internet-facing through application layer
- Must maintain 99.9% uptime SLA

Focus on controls that protect data at rest and access controls.
```

### Analyzing Multiple Scans

```
Analyze compliance across environments:
- Production: scan_prod.csv (criticality: 9/10)
- Staging: scan_staging.csv (criticality: 5/10)  
- Development: scan_dev.csv (criticality: 3/10)

Generate a consolidated report prioritizing production issues.
```

### Targeting Specific Compliance Frameworks

```
Use compliance-prioritizer on our_scan.csv

Focus only on findings mapped to PCI-DSS requirements:
- Requirement 8.x (Access Control)
- Requirement 10.x (Logging and Monitoring)

We have a PCI audit in 30 days.
```

## Troubleshooting

### "Agent not found" or "Unknown subagent_type"

**Problem**: The agent isn't installed correctly

**Solution**:
```bash
# Verify installation
ls -la ~/.claude/agents/compliance-prioritizer.md

# If missing, reinstall
cd ~/.claude/agents
git clone https://github.com/dpickenstenable/tenable-compliance-prioritization.git
cp tenable-compliance-prioritization/compliance-prioritizer.md .
```

### "File not found"

**Problem**: Claude Code can't access your scan file

**Solution**:
```bash
# Use absolute paths
pwd  # Get current directory
ls   # Verify file is there

# Then use full path in prompt
"/Users/yourname/Downloads/scan.csv"
```

### "No compliance data found"

**Problem**: The scan file doesn't contain compliance results

**Solution**:
- Verify this is a **compliance scan**, not a vulnerability scan
- Check the scan policy includes compliance audit files
- Ensure the scan completed successfully in Tenable UI

### "API authentication failed"

**Problem**: API keys are incorrect or lack permissions

**Solution**:
1. Go to Tenable.io → Settings → My Account → API Keys
2. Generate a new key with these permissions:
   - ✅ Read Scans
   - ✅ Read Assets
   - ✅ Read Compliance
3. Copy the keys carefully (no extra spaces)
4. Try again with new keys

## Understanding the Output

### 1. CSV Ranked List (`*_prioritization.csv`)
- Import into Excel/Google Sheets
- Sort by Risk Score (highest first)
- Filter by Category, Complexity, or Asset
- Share with remediation teams

### 2. Markdown Report (`*_report.md`)
- Executive summary for management
- Risk distribution visualizations
- Top 20 detailed findings with business context
- 3-phase remediation roadmap

### 3. HTML Dashboard (`*_report.html`)
- Open in any web browser
- Interactive sortable tables
- Visual risk scoring
- Color-coded priorities
- Best for presentations

### 4. Remediation Plan (`*_remediation_plan.md`)
- Actionable step-by-step instructions
- Grouped by timeline:
  - Quick Wins: 0-2 weeks (GPO changes)
  - Short-term: 2-8 weeks (updates, configs)
  - Long-term: 2-6 months (architecture changes)
- Testing methodology
- Success metrics

## Next Steps After Analysis

1. **Review the HTML dashboard** - Get the big picture visually
2. **Share the Markdown report** - Send to management/stakeholders
3. **Start with Quick Wins** - Open remediation plan, tackle 0-2 week items
4. **Track progress** - Re-run weekly to measure compliance improvement
5. **Focus on top 20** - The Pareto principle: 20% of fixes = 80% risk reduction

## Common Workflows

### Weekly Compliance Monitoring
```bash
# Every Monday morning
claude

# In Claude Code:
"Run compliance-prioritizer on this week's scan:
weekly_compliance_scan_2024-06-24.csv

Compare to last week's results and highlight any new failures."
```

### Pre-Audit Preparation
```bash
# 30 days before audit
"Analyze all compliance scans for in-scope assets.

Context: SOC 2 Type II audit in 30 days.
Priority: High and Critical findings that auditors will flag.

Generate focused remediation plan for audit readiness."
```

### Risk Committee Reporting
```bash
# Quarterly
"Analyze compliance for our legacy OT systems at scan_ot.csv

Asset context: Isolated OT network (criticality: 5/10)

Generate report identifying:
1. Must-fix items (risk score > 7)
2. Should-fix items (risk score 5-7)  
3. Can-accept items (risk score < 5)

Format for risk acceptance committee review."
```

## Getting Help

- **Full Documentation**: See `README.md` for comprehensive details
- **Setup Guide**: See `compliance-prioritizer-setup-guide.md` for API/MCP setup
- **Quick Start**: See `QUICKSTART-compliance-prioritizer.md` for 3-minute start
- **Test Script**: Run `~/.claude/agents/test-tenable-api.sh` to verify API connectivity

## Tips for Best Results

✅ **DO**:
- Provide asset context (criticality, data classification, network location)
- Mention compliance framework focus (PCI, SOC 2, CIS, STIG)
- State business drivers (audit deadline, incident response, risk reduction)
- Use absolute file paths
- Start with export files to understand output, then move to API for automation

❌ **DON'T**:
- Try to run the JavaScript `Agent()` code yourself - let Claude Code handle it
- Use vulnerability scan exports - this agent needs compliance scan data
- Skip the context - generic analysis produces generic prioritization
- Expect instant results - analysis takes 1-3 minutes depending on scan size

---

**Ready to start?** Export a compliance scan from Tenable, open Claude Code, and say:

```
"Run the compliance-prioritizer agent on my scan file at /path/to/scan.csv"
```

The agent will handle the rest!
