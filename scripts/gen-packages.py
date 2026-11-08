#!/usr/bin/env python3
"""
Generate archiso package lists from tools.yml
"""

import re
from pathlib import Path

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
                current_tool = {'package': line.split(':', 1)[1].strip()}
            
            # Parse other fields
            elif line.startswith('  category:'):
                current_tool['category'] = line.split(':', 1)[1].strip()
            elif line.startswith('  stack:'):
                current_tool['stack'] = line.split(':', 1)[1].strip()
        
        # Add last tool
        if current_tool:
            tools.append(current_tool)
    
    return tools

def generate_packages():
    """Generate package list for archiso"""
    tools = load_tools()
    
    # Separate packages by type
    base_packages = []
    hyprland_packages = []
    i3_packages = []
    optional_packages = []
    
    for tool in tools:
        pkg = tool['package']
        category = tool.get('category', '')
        stack = tool.get('stack', '')
        
        # Base system packages (always installed)
        if category in ['cli', 'network', 'disk-system', 'development', 'desktop-base']:
            base_packages.append(pkg)
        # Hyprland specific
        elif stack == 'hyprland':
            hyprland_packages.append(pkg)
        # i3 specific
        elif stack == 'i3':
            i3_packages.append(pkg)
        # Optional/apps (installed by installer based on user choice)
        else:
            optional_packages.append(pkg)
    
    return {
        'base': sorted(base_packages),
        'hyprland': sorted(hyprland_packages),
        'i3': sorted(i3_packages),
        'optional': sorted(optional_packages)
    }

def write_archiso_packages(packages):
    """Write packages.x86_64 for archiso"""
    output_file = Path(__file__).parent.parent / "archiso-profile" / "packages.x86_64"
    
    lines = [
        "# Omiden OS Package List",
        "# Generated from data/tools.yml",
        "",
        "# ===== BASE SYSTEM PACKAGES =====",
        "# These packages are included in the ISO and form the base system",
        ""
    ]
    
    # Add base packages
    lines.extend(packages['base'])
    lines.append("")
    
    # Add a minimal set of Hyprland packages for the installer to work
    lines.append("# ===== INSTALLER ESSENTIALS =====")
    lines.append("# Minimal packages needed for installer to function")
    lines.append("")
    lines.append("dialog")
    lines.append("gawk")
    lines.append("")
    
    with open(output_file, 'w') as f:
        f.write('\n'.join(lines))
    
    print(f"✓ Generated {output_file}")
    print(f"  - {len(packages['base'])} base packages")

def write_installer_packages(packages):
    """Write package lists for the custom installer"""
    installer_dir = Path(__file__).parent.parent / "archiso-profile" / "airootfs" / "usr" / "share" / "omiden"
    installer_dir.mkdir(parents=True, exist_ok=True)
    
    # Write Hyprland packages
    hyprland_file = installer_dir / "packages-hyprland.txt"
    with open(hyprland_file, 'w') as f:
        f.write('\n'.join(packages['hyprland']))
    print(f"✓ Generated {hyprland_file} ({len(packages['hyprland'])} packages)")
    
    # Write i3 packages
    i3_file = installer_dir / "packages-i3.txt"
    with open(i3_file, 'w') as f:
        f.write('\n'.join(packages['i3']))
    print(f"✓ Generated {i3_file} ({len(packages['i3'])} packages)")
    
    # Write optional packages
    optional_file = installer_dir / "packages-optional.txt"
    with open(optional_file, 'w') as f:
        f.write('\n'.join(packages['optional']))
    print(f"✓ Generated {optional_file} ({len(packages['optional'])} packages)")

def main():
    print("Generating package lists from tools.yml...")
    packages = generate_packages()
    
    write_archiso_packages(packages)
    write_installer_packages(packages)
    
    print(f"\n✓ Package generation complete!")
    print(f"  Total: {len(packages['base']) + len(packages['hyprland']) + len(packages['i3']) + len(packages['optional'])} packages")

if __name__ == '__main__':
    main()
