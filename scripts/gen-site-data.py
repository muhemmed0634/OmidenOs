#!/usr/bin/env python3
"""
Generate website data files from tools.yml and keybinds.yml
Creates: tools.json, keybinds.json, wallpapers.json, release.json
"""

import json
import re
from pathlib import Path
from datetime import datetime

def load_tools():
    """Load tools from data/tools.yml (simple YAML parser)"""
    tools_file = Path(__file__).parent.parent / "data" / "tools.yml"
    tools = []
    current_tool = {}
    
    with open(tools_file) as f:
        for line in f:
            line = line.rstrip()
            
            # Skip comments and empty lines
            if not line or line.strip().startswith('#'):
                continue
            
            # New tool entry starts with "- name:"
            if line.startswith('- name:'):
                if current_tool:
                    tools.append(current_tool)
                current_tool = {'name': line.split(':', 1)[1].strip()}
            
            # Parse other fields
            elif line.startswith('  category:'):
                current_tool['category'] = line.split(':', 1)[1].strip()
            elif line.startswith('  stack:'):
                current_tool['stack'] = line.split(':', 1)[1].strip()
            elif line.startswith('  description_en:'):
                # Remove quotes
                desc = line.split(':', 1)[1].strip().strip('"')
                current_tool['description_en'] = desc
            elif line.startswith('  description_az:'):
                desc = line.split(':', 1)[1].strip().strip('"')
                current_tool['description_az'] = desc
        
        # Add last tool
        if current_tool:
            tools.append(current_tool)
    
    return tools

def load_keybinds():
    """Load keybinds from data/keybinds.yml"""
    keybinds_file = Path(__file__).parent.parent / "data" / "keybinds.yml"
    keybinds = []
    current_keybind = {}
    
    with open(keybinds_file) as f:
        for line in f:
            line = line.rstrip()
            
            if not line or line.strip().startswith('#'):
                continue
            
            if line.startswith('- action:'):
                if current_keybind:
                    keybinds.append(current_keybind)
                current_keybind = {'action': line.split(':', 1)[1].strip()}
            
            elif line.startswith('  hyprland_bind:'):
                current_keybind['hyprland_bind'] = line.split(':', 1)[1].strip().strip('"')
            elif line.startswith('  i3_bind:'):
                current_keybind['i3_bind'] = line.split(':', 1)[1].strip().strip('"')
            elif line.startswith('  description_en:'):
                desc = line.split(':', 1)[1].strip().strip('"')
                current_keybind['description_en'] = desc
            elif line.startswith('  description_az:'):
                desc = line.split(':', 1)[1].strip().strip('"')
                current_keybind['description_az'] = desc
        
        if current_keybind:
            keybinds.append(current_keybind)
    
    return keybinds

def generate_site_data():
    """Generate all website data files"""
    site_data_dir = Path(__file__).parent.parent / "site" / "data"
    site_data_dir.mkdir(parents=True, exist_ok=True)
    
    # Generate tools.json
    print("Generating website data files...")
    tools = load_tools()
    tools_file = site_data_dir / "tools.json"
    with open(tools_file, 'w') as f:
        json.dump(tools, f, indent=2, ensure_ascii=False)
    print(f"✓ Generated {tools_file} ({len(tools)} tools)")
    
    # Generate keybinds.json
    keybinds = load_keybinds()
    keybinds_file = site_data_dir / "keybinds.json"
    with open(keybinds_file, 'w') as f:
        json.dump(keybinds, f, indent=2, ensure_ascii=False)
    print(f"✓ Generated {keybinds_file} ({len(keybinds)} keybinds)")
    
    # Generate wallpapers.json (placeholder)
    wallpapers = {
        "normal": [],
        "dynamic-dark": [],
        "dynamic-light": []
    }
    wallpapers_file = site_data_dir / "wallpapers.json"
    with open(wallpapers_file, 'w') as f:
        json.dump(wallpapers, f, indent=2)
    print(f"✓ Generated {wallpapers_file} (placeholder)")
    
    # Generate release.json
    release = {
        "version": datetime.now().strftime("%Y.%m.%d"),
        "date": datetime.now().strftime("%B %d, %Y"),
        "download_url": "https://github.com/muhemmed0634/OmidenOs/releases/latest",
        "sha256": ""
    }
    release_file = site_data_dir / "release.json"
    with open(release_file, 'w') as f:
        json.dump(release, f, indent=2)
    print(f"✓ Generated {release_file}")
    
    print("\n✓ Website data generation complete!")

def main():
    generate_site_data()

if __name__ == '__main__':
    main()
