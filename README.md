# Claude_MCP_Bridge

> Connect Claude Code with multiple AI models (Gemini, Grok, ChatGPT, DeepSeek) through a unified Model Context Protocol interface

[![Python 3.7+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![MCP Compatible](https://img.shields.io/badge/MCP-2024--11--05-green.svg)](https://modelcontextprotocol.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

The Claude_MCP_Bridge enables Claude Code to collaborate with multiple AI models simultaneously. Compare responses, facilitate AI debates, and leverage collective intelligence for complex problem-solving directly from your terminal.

### Key Features

- **Multi-Model Integration**: Connect with Gemini, Grok, ChatGPT, and DeepSeek through one interface
- **AI Collaboration Tools**: Enable debates, consensus-building, and collaborative problem-solving
- **Specialized Workflows**: Code review, debugging, architecture design, and brainstorming
- **Flexible Configuration**: Use only the AI models you have access to
- **Unified Interface**: Consistent tool patterns across all AI providers

## Quick Start

### Prerequisites

- **Python 3.7+** - [Download here](https://www.python.org/downloads/)
- **Claude Code CLI** - Install with: `npm install -g @anthropic-ai/claude-code`
- **AI API Keys** - At least one from supported providers (see below)

### Installation

#### Automated Setup
```bash
# Clone and run setup
git clone <repository-url>
cd multi-ai-mcp
chmod +x setup.sh
./setup.sh
```

The setup script will:
1. Install Python dependencies
2. Configure API keys interactively
3. Register the MCP server with Claude Code

#### Supported AI Providers

- **Gemini** - Free API key from [Google AI Studio](https://aistudio.google.com/apikey)
- **Grok** - API key from [xAI Console](https://console.x.ai/)
- **OpenAI** - API key from [OpenAI Platform](https://platform.openai.com/api-keys)
- **DeepSeek** - API key from [DeepSeek Platform](https://platform.deepseek.com/)

## Usage

### Starting Claude Code
```bash
claude
```

### Verify Connection
```bash
/mcp
# Should show: Claude_MCP_Bridge connected
```

### Tool Categories

#### Status and Configuration

**`server_status`** - Check available AIs and configuration
```
mcp__Claude_MCP_Bridge__server_status
```

#### Individual AI Tools

Each configured AI provides these tools:

**`ask_{ai_name}`** - Direct questions
```
mcp__Claude_MCP_Bridge__ask_gemini "Explain containerization best practices"
```

**`{ai_name}_code_review`** - Code analysis with focus areas
```
mcp__Claude_MCP_Bridge__gemini_code_review
```
Focus options: `general`, `security`, `performance`, `readability`

**`{ai_name}_think_deep`** - Extended reasoning and analysis
```
mcp__Claude_MCP_Bridge__grok_think_deep
```

**`{ai_name}_brainstorm`** - Creative problem-solving
```
mcp__Claude_MCP_Bridge__openai_brainstorm
```

**`{ai_name}_debug`** - Debugging assistance
```
mcp__Claude_MCP_Bridge__deepseek_debug
```

**`{ai_name}_architecture`** - System design recommendations
```
mcp__Claude_MCP_Bridge__gemini_architecture
```

#### Multi-AI Collaboration Tools

**`ask_all_ais`** - Compare responses from all available AIs
```
mcp__Claude_MCP_Bridge__ask_all_ais "Database selection for real-time analytics"
```

**`ai_debate`** - Facilitate debate between two AIs
```
mcp__Claude_MCP_Bridge__ai_debate "Monolith vs microservices for startups" gemini grok
```

**`collaborative_solve`** - Multi-AI problem-solving session
```
mcp__Claude_MCP_Bridge__collaborative_solve "Design a distributed cache system"
```

**`ai_consensus`** - Get unified recommendations
```
mcp__Claude_MCP_Bridge__ai_consensus "Best frontend framework for enterprise apps"
```

## Configuration

### Configuration File Location
```
~/.Claude_MCP_Bridge/credentials.json
```

### Configuration Structure
```json
{
  "gemini": {
    "api_key": "your-api-key",
    "model": "gemini-2.5-flash",
    "enabled": true
  },
  "grok": {
    "api_key": "your-api-key",
    "model": "grok-4",
    "base_url": "https://api.x.ai/v1",
    "enabled": true
  },
  "openai": {
    "api_key": "your-api-key",
    "model": "gpt-4o",
    "enabled": true
  },
  "deepseek": {
    "api_key": "your-api-key",
    "model": "deepseek-chat",
    "base_url": "https://api.deepseek.com",
    "enabled": true
  }
}
```

### Available Models

#### Gemini Models
- `gemini-2.5-pro` - Most capable model with thinking mode
- `gemini-2.5-flash` - Fast and efficient (default)
- `gemini-2.5-flash-lite` - Lightweight variant
- `gemini-2.5-flash-preview-05-20` - Preview release
- `gemini-2.5-pro-preview-06-05` - Pro preview release
- `gemini-2.0-flash` - Previous generation
- `gemini-2.0-flash-lite` - Previous gen lightweight
- `gemma-3n-e4b-it` - Open model variant

#### Grok Models
- `grok-4` - Latest model (default)
- `grok-4-latest` - Rolling latest version
- `grok-4-fast-reasoning` - Optimized for reasoning tasks
- `grok-4-fast-non-reasoning` - Optimized for general tasks
- `grok-3` - Previous generation
- `grok-3-mini` - Lightweight version
- `grok-code-fast-1` - Specialized for coding
- `grok-2-image-1212` - Image generation model

#### OpenAI Models
- `gpt-5` - Flagship model with unified reasoning (default)
- `gpt-5-codex` - GPT-5 for agentic coding
- `gpt-4.1` - Latest GPT-4.1 series
- `gpt-4.1-mini` - Smaller GPT-4.1 variant
- `gpt-4.1-nano` - Smallest GPT-4.1 variant
- `gpt-4.5` - Previous generation (deprecating July 2025)
- `gpt-4o` - Optimized GPT-4
- `gpt-4o-mini` - Smaller optimized variant
- `o4-mini` - O4 reasoning model
- `o3-mini` - O3 reasoning model
- `gpt-oss-120b` - Open weights 120B model
- `gpt-oss-20b` - Open weights 20B model

#### DeepSeek Models
- `deepseek-chat` - V3.1-Terminus non-thinking mode (default)
- `deepseek-reasoner` - V3.1-Terminus R1 thinking mode

## Architecture

### System Design

```
┌─────────────────┐
│   Claude Code   │
└────────┬────────┘
         │ MCP Protocol (JSON-RPC 2.0)
┌────────▼─────────────────────────┐
│      Claude_MCP_Bridge           │
│ ┌──────────────────────────────┐ │
│ │   Unified Tool Interface     │ │
│ └──┬─────┬─────┬─────┬───────-─┘ │
│    │     │     │     │           │
│ ┌──▼──┐┌─▼──┐ ┌─▼──┐ ┌─▼──────┐  │
│ │Gemini││Grok││OAI │ │DeepSeek│  │
│ └──────┘└────┘└────┘ └────────┘  │
└──────────────────────────────────┘
```

### Protocol Details
- **Protocol**: JSON-RPC 2.0 over stdin/stdout
- **MCP Version**: 2024-11-05
- **Response Format**: Unified across all AI providers
- **Error Handling**: Graceful degradation when AIs unavailable

## Examples

### Comparative Analysis
```bash
# Compare AI perspectives on a technical decision
mcp__Claude_MCP_Bridge__ask_all_ais "PostgreSQL vs MongoDB for time-series data"
```

### Code Review Pipeline
```bash
# Sequential reviews focusing on different aspects
mcp__Claude_MCP_Bridge__gemini_code_review "$(cat app.py)" security
mcp__Claude_MCP_Bridge__grok_code_review "$(cat app.py)" performance
mcp__Claude_MCP_Bridge__deepseek_code_review "$(cat app.py)" maintainability
```

### Architecture Planning
```bash
# Collaborative architecture design
mcp__Claude_MCP_Bridge__collaborative_solve "Design event-driven microservices for e-commerce"
```

### Technical Debate
```bash
# AI debate on architectural choices
mcp__Claude_MCP_Bridge__ai_debate "REST vs GraphQL for mobile applications" openai deepseek
```

## Troubleshooting

### MCP Connection Issues
```bash
# Remove and re-add the server
claude mcp remove Claude_MCP_Bridge
claude mcp add --scope user Claude_MCP_Bridge python3 ~/.Claude_MCP_Bridge/server.py
```

### Verify Installation
```bash
# Check Python dependencies
pip3 list | grep -E "google-genai|openai|python-dotenv"

# Test server directly
python3 ~/.Claude_MCP_Bridge/server.py
```

### Update API Keys
```bash
# Edit configuration
nano ~/.Claude_MCP_Bridge/credentials.json

# Or use environment variables
export GEMINI_API_KEY="new-key"
export OPENAI_API_KEY="new-key"
```

### Common Issues

**Issue**: AI not responding
- **Solution**: Check API key validity and rate limits

**Issue**: Model not found
- **Solution**: Verify model name in configuration matches available models

**Issue**: MCP server not connecting
- **Solution**: Ensure Claude Code CLI is updated to latest version

## API Limits and Costs

### Rate Limits

| Provider | Free Tier | Paid Tier |
|----------|-----------|-----------|
| Gemini | 15 RPM, 1500/day | 360 RPM |
| Grok | N/A | 60 RPM |
| OpenAI | N/A | 500 RPM (GPT-4o) |
| DeepSeek | 50 RPM | 500 RPM |

### Token Limits

| Provider | Context Window | Max Output | Special Features |
|----------|---------------|------------|------------------|
| Gemini 2.5 | Up to 2M tokens | 8192 tokens | Thinking mode (Pro), Live API, Image generation |
| Grok-4 | 256k tokens | 8192 tokens | Dynamic reasoning, Live search via API |
| GPT-5 | Up to 1M tokens | 8192 tokens | Unified reasoning, Codex integration |
| DeepSeek V3.1 | 64k tokens | 8192 tokens | R1 thinking mode, Context caching |
