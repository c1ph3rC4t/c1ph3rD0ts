#!/usr/bin/env python3
"""Patches EssentialsX plugin.yml to prefix vanilla-conflicting commands with 'ex',
so vanilla commands (and their tab completion) work unimpeded."""

import sys
import os
import zipfile
import yaml

# vanilla MC commands that essentialsx registers over
# (command names as they appear in-game, not bukkit's namespaced versions)
VANILLA_COMMANDS = {
    "ban", "clear", "enchant", "gamemode", "give", "help",
    "kick", "kill", "list", "me", "msg", "pardon",
    "tell", "teleport", "tp", "time", "w", "weather", "xp",
}


def patch_commands(data):
    commands = data.get("commands", {})
    patched = {}
    renamed_keys = []
    renamed_aliases = []

    for name, info in commands.items():
        new_name = name
        if name in VANILLA_COMMANDS:
            new_name = f"ex{name}"
            renamed_keys.append(f"  {name} -> {new_name}")

        if "aliases" in info:
            new_aliases = []
            for alias in info["aliases"]:
                if alias in VANILLA_COMMANDS:
                    new_alias = f"ex{alias}"
                    renamed_aliases.append(f"  {alias} -> {new_alias} (in {name})")
                    new_aliases.append(new_alias)
                else:
                    new_aliases.append(alias)
            info["aliases"] = new_aliases

        patched[new_name] = info

    data["commands"] = patched
    return data, renamed_keys, renamed_aliases


def find_main_jar(directory):
    """Find the main EssentialsX jar (not Spawn, Chat, etc)."""
    for f in os.listdir(directory):
        if f.endswith(".jar") and "Spawn" not in f and "Chat" not in f and "Discord" not in f and "GeoIP" not in f and "XMPP" not in f and "Protect" not in f and "AntiBuild" not in f:
            return os.path.join(directory, f)
    return None


def main():
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <path/to/EssentialsX.jar or .zip>")
        sys.exit(1)

    input_path = os.path.realpath(sys.argv[1])

    if not os.path.isfile(input_path):
        print(f"error: {input_path} not found")
        sys.exit(1)

    if input_path.endswith(".zip"):
        extract_dir = os.path.join(os.path.dirname(input_path), "essentialsx-patched")
        os.makedirs(extract_dir, exist_ok=True)
        with zipfile.ZipFile(input_path, "r") as zf:
            zf.extractall(extract_dir)
        jar_path = find_main_jar(extract_dir)
        if not jar_path:
            print(f"error: no main EssentialsX jar found in {extract_dir}")
            sys.exit(1)
        print(f"extracted to {extract_dir}")
    elif input_path.endswith(".jar"):
        jar_path = input_path
    else:
        print(f"error: expected .jar or .zip, got {input_path}")
        sys.exit(1)

    # read plugin.yml from jar
    with zipfile.ZipFile(jar_path, "r") as zf:
        if "plugin.yml" not in zf.namelist():
            print("error: no plugin.yml found in jar")
            sys.exit(1)
        data = yaml.safe_load(zf.read("plugin.yml"))

    # patch
    data, renamed_keys, renamed_aliases = patch_commands(data)

    if not renamed_keys and not renamed_aliases:
        print("nothing to patch - no vanilla conflicts found")
        sys.exit(0)

    # rewrite jar with patched plugin.yml
    tmp = jar_path + ".tmp"
    with zipfile.ZipFile(jar_path, "r") as zin:
        with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                if item.filename == "plugin.yml":
                    zout.writestr(
                        item,
                        yaml.dump(data, default_flow_style=False, sort_keys=False),
                    )
                else:
                    zout.writestr(item, zin.read(item.filename))

    os.replace(tmp, jar_path)

    print(f"patched {jar_path}\n")
    if renamed_keys:
        print("renamed commands:")
        print("\n".join(renamed_keys))
    if renamed_aliases:
        print("\nrenamed aliases:")
        print("\n".join(renamed_aliases))


if __name__ == "__main__":
    main()
