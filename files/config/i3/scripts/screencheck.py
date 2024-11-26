#! /usr/bin/env python3

import re
import subprocess

def get_edid():
    result = subprocess.run(['xrandr', '--verbose'], capture_output=True, text=True)
    output = result.stdout

    edid_regex = re.compile(r'EDID(_1)?:\s+(\w+\s+){128}', re.MULTILINE)
    edid_matches = edid_regex.findall(output)

    edids = [match[1].replace('\n', '') for match in edid_matches]
    return edids


def get_monitor_by_edid(edid):
    print(f"Checking for monitor with EDID {edid}")
    try:
        xrandr_output = subprocess.check_output(["xrandr", "--props"], text=True)
        lines = xrandr_output.split("\n")
        current_monitor = None
        current_edid = ""
        collecting_edid = False

        for line in lines:
            if " connected " in line:
                current_monitor = line.split()[0]
            elif "EDID:" in line:
                collecting_edid = True
                current_edid = ""
            elif collecting_edid:
                if line.startswith("\t\t"):
                    current_edid += line.strip()
                else:
                    collecting_edid = False
                    if current_edid.replace("\n", "").replace(" ", "") == edid:
                        print(f"Found monitor {current_monitor} with EDID {edid}")
                        return current_monitor
        print(f"Monitor with EDID {edid} not found")
        return None
    except subprocess.CalledProcessError as e:
        print(f"Error running xrandr: {e}")
        return None

monitors = ["eDP-1", "DP-3", "DP-2"]

# Example operations on monitors, adapt as necessary
if monitors[1] and monitors[2]:
    print(f"{monitors[1]} and {monitors[2]} found")
    subprocess.run(
        ["notify-send", f"{monitors[1]} and {monitors[2]} found"], check=False
    )
    subprocess.run(
        [
            "xrandr",
            "--output",
            "eDP-1",
            "--mode",
            "1920x1200",
            "--pos",
            "0x2029",
            "--rotate",
            "normal",
            "--output",
            monitors[1],
            "--mode",
            "3840x2160",
            "--pos",
            "5760x0",
            "--rotate",
            "right",
            "--output",
            monitors[2],
            "--primary",
            "--mode",
            "3840x2160",
            "--pos",
            "1920x668",
            "--rotate",
            "normal",
        ],
        check=False,
    )
elif monitors[1]:
    print(f"{monitors[1]} found")
    subprocess.run(["notify-send", f"{monitors[1]} found"], check=False)
    subprocess.run(["xrandr", "--output", monitors[0], "--auto"], check=False)
    subprocess.run(["xrandr", "--output", monitors[1], "--auto"], check=False)
elif monitors[2]:
    print(f"{monitors[2]} found")
    subprocess.run(["notify-send", f"{monitors[2]} found"], check=False)
    subprocess.run(["xrandr", "--output", monitors[0], "--auto"], check=False)
    subprocess.run(["xrandr", "--output", monitors[2], "--auto"], check=False)
elif monitors[3]:
    print(f"{monitors[3]} found and configured")
    subprocess.run(["notify-send", f"{monitors[3]} found and configured"], check=False)
    subprocess.run(
        [
            "xrandr",
            "--output",
            monitors[0],
            "--mode",
            "1920x1200",
            "--pos",
            "320x1080",
            "--rotate",
            "normal",
        ],
        check=False,
    )
    subprocess.run(
        [
            "xrandr",
            "--output",
            monitors[3],
            "--mode",
            "2560x1080",
            "--pos",
            "0x0",
            "--rotate",
            "normal",
        ],
        check=False,
    )
else:
    print("No external monitors")
    subprocess.run(["notify-send", "No external monitors"], check=False)
    subprocess.run(["xrandr", "--output", monitors[0], "--auto"], check=False)
    subprocess.run(["xrandr", "--output", "DP-2", "--off"], check=False)
    subprocess.run(["xrandr", "--output", "DP-3", "--off"], check=False)

with open("/tmp/monitor_info.sh", "w", encoding="utf-8") as f:
    for i, monitor in enumerate(monitors):
        if monitor:
            f.write(f'export MONITOR{i}="{monitor}"\n')
