---
name: "Tenable Compliance Prioritizer"
author: "dpickenstenable"
github_url: "https://github.com/dpickenstenable/agents/Tenable Compliance Prioritization"
description: "The Tenable Compliance Prioritizer agent analyzes Tenable Vulnerability Management compliance scan results and intelligently prioritizes failed benchmarks."
license: "MIT"
type: "agent"
tier: "unreviewed"
tags: ["tag1", "tag2"]
framework: "Claude Code"
integrations: ["Tenable"]
date_added: 2026-06-22
---

Optional longer description of your agent. This is rendered as markdown on the detail page.
The actual code and documentation should remain in your GitHub repo.

## What it does

The `compliance-prioritizer` agent analyzes Tenable Vulnerability Management compliance scan results and intelligently prioritizes failed benchmarks based on:

Business Impact (35%): What does this control protect?
Asset Criticality (35%): How important is the affected system?
Remediation Ease (20%): How hard is it to fix?
Exploitability (10%): Can this be exploited remotely?

## How it works

 The compliance-prioritizer agent intelligently analyzes Tenable VM compliance scans and prioritizes failed benchmarks based on a risk-scoring framework that weighs business impact, asset criticality, remediation ease, and exploitability. 

 It accepts data via exported files, Tenable.VM/sc API (with user-provided credentials), or MCP servers, then generates four comprehensive reports: a sortable CSV ranking all failures, a detailed Markdown executive report with top priorities and remediation roadmap, an interactive HTML dashboard for presentations, and a step-by-step remediation plan with exact commands and timelines. 

 By focusing teams on the compliance gaps that pose the greatest actual risk rather than treating all failures equally, it transforms overwhelming scan results into strategic, actionable security improvements.

