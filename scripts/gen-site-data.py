#!/usr/bin/env python3
"""
Omiden OS - Site Data Generator
Generates JSON files for the website from tools.yml and keybinds.yml
"""

import os
import json
import yaml
from pathlib import Path
from datetime import datetime

# Paths
BASE_DIR = Path(__file__).parent.parent
DATA_DIR = BASE_DIR / "data"
SITE_DATA_DIR = BASE_DIR / "site" / "data"
WALLPAPER_DIR = BASE_DIR / "wallpapers"

def load_yaml(file_path):
    """Load YAML file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def count_tools_by_stack(tools):
    """Count tools by stack"""
    counts = {"common": 0, "hyprland": 0, "i3": 0}
    for tool in tools:
        stack = tool.get("stack", "common")
        if stack in counts:
            counts[stack] += 1
        elif stack == "both":
            counts["hyprland"] += 1
            counts["i3"] += 1
    return counts

def generate_tools_json():
    """Generate tools.json from tools.yml"""
    print("==> Generating tools.json")
    
    tools_yml = DATA_DIR / "tools.yml"
    if not tools_yml.exists():
        print(f"ERROR: {tools_yml} not found!")
        return
    
    tools = load_yaml(tools_yml)
    
    # Count by category
    categories = {}
    for tool in tools:
        cat = tool.get("category", "other")
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(tool)
    
    # Count by stack
    stack_counts = count_tools_by_stack(tools)
    
    output = {
        "total": len(tools),
        "by_stack": stack_counts,
        "by_category": {k: len(v) for k, v in categories.items()},
        "categories": categories,
        "tools": tools,
        "generated": datetime.now().isoformat()
    }
    
    SITE_DATA_DIR.mkdir(parents=True, exist_ok=True)
    output_file = SITE_DATA_DIR / "tools.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    
    print(f"    Total tools: {len(tools)}")
    print(f"    Common: {stack_counts['common']}")
    print(f"    Hyprland: {stack_counts['hyprland']}")
    print(f"    i3: {stack_counts['i3']}")
    print(f"    Categories: {len(categories)}")

def generate_keybinds_json():
    """Generate keybinds.json from keybinds.yml"""
    print("==> Generating keybinds.json")
    
    keybinds_yml = DATA_DIR / "keybinds.yml"
    if not keybinds_yml.exists():
        print(f"ERROR: {keybinds_yml} not found!")
        return
    
    keybinds = load_yaml(keybinds_yml)
    
    # Group by category (infer from action name)
    categories = {
        "basic": [],
        "window": [],
        "workspace": [],
        "system": [],
        "media": []
    }
    
    for bind in keybinds:
        action = bind.get("action", "")
        if any(x in action for x in ["terminal", "launcher", "close", "reload", "exit"]):
            categories["basic"].append(bind)
        elif any(x in action for x in ["focus", "move", "split", "float", "fullscreen"]):
            categories["window"].append(bind)
        elif "workspace" in action:
            categories["workspace"].append(bind)
        elif any(x in action for x in ["lock", "wallpaper", "theme", "screenshot", "brightness"]):
            categories["system"].append(bind)
        elif any(x in action for x in ["volume", "media", "play"]):
            categories["media"].append(bind)
    
    output = {
        "total": len(keybinds),
        "categories": categories,
        "all": keybinds,
        "generated": datetime.now().isoformat()
    }
    
    output_file = SITE_DATA_DIR / "keybinds.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    
    print(f"    Total keybinds: {len(keybinds)}")
    print(f"    Basic: {len(categories['basic'])}")
    print(f"    Window: {len(categories['window'])}")
    print(f"    Workspace: {len(categories['workspace'])}")
    print(f"    System: {len(categories['system'])}")
    print(f"    Media: {len(categories['media'])}")

def generate_wallpapers_json():
    """Generate wallpapers.json from wallpapers directory"""
    print("==> Generating wallpapers.json")
    
    if not WALLPAPER_DIR.exists():
        print(f"WARNING: {WALLPAPER_DIR} not found! Run fetch-wallpapers.sh first.")
        return
    
    wallpapers = {
        "normal": [],
        "dynamic_dark": [],
        "dynamic_light": []
    }
    
    # Scan normal wallpapers
    normal_dir = WALLPAPER_DIR / "normal"
    if normal_dir.exists():
        for img in normal_dir.glob("*"):
            if img.suffix.lower() in [".jpg", ".jpeg", ".png"]:
                wallpapers["normal"].append({
                    "name": img.name,
                    "path": f"normal/{img.name}",
                    "size": img.stat().st_size
                })
    
    # Scan dark wallpapers
    dark_dir = WALLPAPER_DIR / "dynamic-dark"
    if dark_dir.exists():
        for img in dark_dir.glob("*"):
            if img.suffix.lower() in [".jpg", ".jpeg", ".png"]:
                wallpapers["dynamic_dark"].append({
                    "name": img.name,
                    "path": f"dynamic-dark/{img.name}",
                    "size": img.stat().st_size
                })
    
    # Scan light wallpapers
    light_dir = WALLPAPER_DIR / "dynamic-light"
    if light_dir.exists():
        for img in light_dir.glob("*"):
            if img.suffix.lower() in [".jpg", ".jpeg", ".png"]:
                wallpapers["dynamic_light"].append({
                    "name": img.name,
                    "path": f"dynamic-light/{img.name}",
                    "size": img.stat().st_size
                })
    
    total = len(wallpapers["normal"]) + len(wallpapers["dynamic_dark"]) + len(wallpapers["dynamic_light"])
    
    output = {
        "total": total,
        "counts": {
            "normal": len(wallpapers["normal"]),
            "dark": len(wallpapers["dynamic_dark"]),
            "light": len(wallpapers["dynamic_light"])
        },
        "wallpapers": wallpapers,
        "credits_url": "https://github.com/JaKooLit/Wallpaper-Bank",
        "generated": datetime.now().isoformat()
    }
    
    output_file = SITE_DATA_DIR / "wallpapers.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    
    print(f"    Total wallpapers: {total}")
    print(f"    Normal: {len(wallpapers['normal'])}")
    print(f"    Dark: {len(wallpapers['dynamic_dark'])}")
    print(f"    Light: {len(wallpapers['dynamic_light'])}")

def generate_release_json():
    """Generate release.json from build output"""
    print("==> Generating release.json")
    
    out_dir = BASE_DIR / "out"
    iso_file = None
    
    if out_dir.exists():
        iso_files = list(out_dir.glob("*.iso"))
        if iso_files:
            iso_file = iso_files[0]
    
    if iso_file:
        import hashlib
        
        # Calculate SHA256
        sha256 = hashlib.sha256()
        with open(iso_file, 'rb') as f:
            for chunk in iter(lambda: f.read(4096), b""):
                sha256.update(chunk)
        
        output = {
            "version": datetime.now().strftime("%Y.%m"),
            "date": datetime.now().isoformat(),
            "filename": iso_file.name,
            "size": iso_file.stat().st_size,
            "size_human": f"{iso_file.stat().st_size / (1024**3):.2f} GB",
            "sha256": sha256.hexdigest(),
            "download_url": f"https://github.com/muhemmed0634/OmidenOs/releases/latest/download/{iso_file.name}"
        }
        
        print(f"    ISO: {iso_file.name}")
        print(f"    Size: {output['size_human']}")
        print(f"    SHA256: {output['sha256'][:16]}...")
    else:
        print("    WARNING: No ISO found in out/ directory")
        output = {
            "version": datetime.now().strftime("%Y.%m"),
            "date": datetime.now().isoformat(),
            "filename": "omiden-YYYYMM-x86_64.iso",
            "size": 0,
            "size_human": "N/A",
            "sha256": "Not yet built",
            "download_url": "https://github.com/muhemmed0634/OmidenOs/releases"
        }
    
    output_file = SITE_DATA_DIR / "release.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

def main():
    """Main entry point"""
    print("=" * 60)
    print("Omiden OS - Site Data Generator")
    print("=" * 60)
    
    generate_tools_json()
    generate_keybinds_json()
    generate_wallpapers_json()
    generate_release_json()
    
    print("\n==> Site data generation complete!")
    print(f"    Output: {SITE_DATA_DIR}")

if __name__ == "__main__":
    main()
