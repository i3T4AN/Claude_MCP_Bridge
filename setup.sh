#!/bin/bash
# Multi-AI MCP Server Setup Script

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Multi-AI MCP Server Setup${NC}"
echo "Connect Claude Code with Gemini, Grok, ChatGPT, and DeepSeek"
echo ""

# Check requirements
echo "Checking requirements..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python 3 is required but not installed.${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "Python $PYTHON_VERSION found"

if ! command -v claude &> /dev/null; then
    echo -e "${RED}Claude Code CLI not found. Please install it first:${NC}"
    echo "npm install -g @anthropic-ai/claude-code"
    exit 1
fi
echo "Claude Code CLI found"

# Setup directories and files
echo ""
echo "Creating MCP server directory..."
mkdir -p ~/.Claude_MCP_Bridge

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing server..."
cp "$SCRIPT_DIR/server.py" ~/.Claude_MCP_Bridge/

if [ ! -f ~/.Claude_MCP_Bridge/credentials.json ]; then
    cp "$SCRIPT_DIR/credentials.template.json" ~/.Claude_MCP_Bridge/credentials.json
    echo "Created credentials.json from template"
fi

echo ""
echo "Installing Python dependencies..."
pip3 install -r "$SCRIPT_DIR/requirements.txt" --quiet

# API key configuration function
prompt_for_ai() {
    local service_name="$1"
    local current_key="$2"
    local description="$3"
    local default_model="$4"
    local available_models="$5"
    local is_optional="${6:-true}"
    
    if [[ "$current_key" == *"YOUR_"*"_KEY_HERE" ]]; then
        echo ""
        echo -e "${YELLOW}$service_name Configuration${NC}"
        echo "   $description"
        if [ "$is_optional" = "true" ]; then
            echo -e "   ${BLUE}(Optional - press Enter to skip)${NC}"
        fi
        read -p "Enter $service_name API key: " new_key
        if [ ! -z "$new_key" ]; then
            echo ""
            echo -e "${BLUE}Choose $service_name model:${NC}"
            echo "   Available: $available_models"
            echo "   Default: $default_model"
            read -p "Model (or press Enter for default): " model_choice
            if [ -z "$model_choice" ]; then
                model_choice="$default_model"
            fi
            
            python3 -c "
import json
with open('$HOME/.Claude_MCP_Bridge/credentials.json', 'r') as f:
    creds = json.load(f)
creds['$(echo $service_name | tr '[:upper:]' '[:lower:]')']['api_key'] = '$new_key'
creds['$(echo $service_name | tr '[:upper:]' '[:lower:]')']['model'] = '$model_choice'
creds['$(echo $service_name | tr '[:upper:]' '[:lower:]')']['enabled'] = True
with open('$HOME/.Claude_MCP_Bridge/credentials.json', 'w') as f:
    json.dump(creds, f, indent=2)
"
            echo -e "${GREEN}$service_name configured with model: $model_choice${NC}"
            return 0
        else
            echo -e "${YELLOW}$service_name skipped (can be added later)${NC}"
            return 1
        fi
    else
        echo -e "${GREEN}$service_name already configured${NC}"
        return 0
    fi
}

# Configure API keys
echo ""
echo "Configuring API keys..."
echo "You can skip any AI you don't have an API key for"

GEMINI_KEY=$(python3 -c "import json; f=open('$HOME/.Claude_MCP_Bridge/credentials.json'); print(json.load(f)['gemini']['api_key'])")
GROK_KEY=$(python3 -c "import json; f=open('$HOME/.Claude_MCP_Bridge/credentials.json'); print(json.load(f)['grok']['api_key'])")
OPENAI_KEY=$(python3 -c "import json; f=open('$HOME/.Claude_MCP_Bridge/credentials.json'); print(json.load(f)['openai']['api_key'])")
DEEPSEEK_KEY=$(python3 -c "import json; f=open('$HOME/.Claude_MCP_Bridge/credentials.json'); print(json.load(f)['deepseek']['api_key'])")

configured_ais=()

echo -e "${BLUE}Configure the AIs you want to use:${NC}"

if prompt_for_ai "Gemini" "$GEMINI_KEY" "Free API key from: https://aistudio.google.com/apikey" "gemini-2.5-flash" "gemini-2.5-flash, gemini-2.5-pro, gemini-2.0-flash"; then
    configured_ais+=("Gemini")
fi

if prompt_for_ai "Grok" "$GROK_KEY" "API key from: https://console.x.ai/" "grok-4" "grok-4, grok-3, grok-3-mini"; then
    configured_ais+=("Grok")
fi

if prompt_for_ai "OpenAI" "$OPENAI_KEY" "API key from: https://platform.openai.com/api-keys" "gpt-5" "gpt-5, gpt-4.1, gpt-4.1-mini, gpt-4o"; then
    configured_ais+=("ChatGPT")
fi

if prompt_for_ai "DeepSeek" "$DEEPSEEK_KEY" "API key from: https://platform.deepseek.com/" "deepseek-chat" "deepseek-chat, deepseek-reasoner"; then
    configured_ais+=("DeepSeek")
fi

echo ""
if [ ${#configured_ais[@]} -eq 0 ]; then
    echo -e "${RED}No AIs configured. Please run setup again with at least one API key.${NC}"
    exit 1
else
    echo -e "${GREEN}Configured AIs: ${configured_ais[*]}${NC}"
fi

# Configure Claude Code
echo ""
echo "Configuring Claude Code..."
claude mcp remove Claude_MCP_Bridge 2>/dev/null || true
claude mcp add --scope user Claude_MCP_Bridge python3 ~/.Claude_MCP_Bridge/server.py

# Complete
echo ""
echo -e "${GREEN}Setup complete${NC}"
echo ""
echo "Multi-AI MCP Server is ready with: ${configured_ais[*]}"
echo ""
echo "Quick start:"
echo "  1. Run: claude"
echo "  2. Type: /mcp (should show Claude_MCP_Bridge connected)"
echo "  3. Use tools like: mcp__Claude_MCP_Bridge__ask_gemini"
echo ""
echo "Config file: ~/.Claude_MCP_Bridge/credentials.json"