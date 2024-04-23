import subprocess


def get_monitor_by_edid(edid):
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
                        return current_monitor

        return None
    except subprocess.CalledProcessError as e:
        print(f"Error running xrandr: {e}")
        return None


# Define EDIDs
# TODO: Store EDIDS in a separate file
EDID_MONITOR1 = "00ffffffffffff0010ac98a14c384a311a200104b53c22783b5095a8544ea5260f5054a54b00714f8180a9c0a940d1c0e100010101014dd000a0f0703e803020350055502100001a000000ff004350394a4d34330a2020202020000000fc0044454c4c20533237323151530a000000fd00283c89893c010a20202020202001af020321f15461010203040506071011121415161f20215d5e5f2309070783010000565e00a0a0a029503020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc"
EDID_MONITOR2 = "00ffffffffffff001e6d0677c36c0100041f0103803c2278ea3e31ae5047ac270c50542108007140818081c0a9c0d1c081000101010108e80030f2705a80b0588a0058542100001e04740030f2705a80b0588a0058542100001a000000fd00383d1e873c000a202020202020000000fc004c472048445220344b0a20202001ab020338714d9022201f1203040161605d5e5f230907076d030c001000b83c20006001020367d85dc401788003e30f0003e305c000e3060501023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a000000ff003130344e544d5832523337390a0000000000000000000000000000000000d4"
EDID_MONITOR3 = "00ffffffffffff001e6df159899e00000b1a010380502278eaca95a6554ea1260f5054a54b80714f818081c0a9c0b3000101010101017e4800e0a0381f4040403a001e4e31000018023a801871382d40582c45001e4e3100001e000000fc004c4720554c545241574944450a000000fd00384b1e5a18000a20202020202001d802031df14a900403221412051f0113230907078301000065030c002000023a801871382d40582c450056512100001e011d8018711c1620582c250056512100009e011d007251d01e206e28550056512100001e8c0ad08a20e02d10103e9600565121000018000000000000000000000000000000000000000000000000000068"

monitors = [
    "eDP-1",
    get_monitor_by_edid(EDID_MONITOR1),
    get_monitor_by_edid(EDID_MONITOR2),
    get_monitor_by_edid(EDID_MONITOR3),
]

# Example operations on monitors, adapt as necessary
if monitors[1] and monitors[2]:
    subprocess.run(
        ["notify-send", f"{monitors[1]} and {monitors[2]} found"], check=False
    )
    subprocess.run(
        [
            "xrandr",
            "--output",
            "eDP-1",
            "--mode",
            "3840x2400",
            "--pos",
            "0x1780",
            "--rotate",
            "normal",
            "--output",
            monitors[1],
            "--mode",
            "3840x2160",
            "--pos",
            "7680x0",
            "--rotate",
            "right",
            "--output",
            monitors[2],
            "--primary",
            "--mode",
            "3840x2160",
            "--pos",
            "3840x840",
            "--rotate",
            "normal",
        ],
        check=False,
    )
elif monitors[1]:
    subprocess.run(["notify-send", f"{monitors[1]} found"], check=False)
    subprocess.run(["xrandr", "--output", monitors[0], "--auto"], check=False)
    subprocess.run(["xrandr", "--output", monitors[1], "--auto"], check=False)
elif monitors[2]:
    subprocess.run(["notify-send", f"{monitors[2]} found"], check=False)
    subprocess.run(["xrandr", "--output", monitors[0], "--auto"], check=False)
    subprocess.run(["xrandr", "--output", monitors[2], "--auto"], check=False)
elif monitors[3]:
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
    subprocess.run(["notify-send", "No external monitors"], check=False)
    subprocess.run(["xrandr", "--output", monitors[0], "--auto"], check=False)
    subprocess.run(["xrandr", "--output", "DP-2", "--off"], check=False)
    subprocess.run(["xrandr", "--output", "DP-3", "--off"], check=False)

with open("/tmp/monitor_info.sh", "w", encoding="utf-8") as f:
    for i, monitor in enumerate(monitors):
        if monitor:
            f.write(f'export MONITOR{i}="{monitor}"\n')
