import re
import subprocess

from exception_annotation.utils import scp_to_folder


# Send a notification
def notify_send(text):
    bash_command = ['notify-send', text]
    subprocess.Popen(bash_command, stdout=subprocess.PIPE)


# Play video with VLC
def play_video(path):
    bash_command = ['vlc', path]
    subprocess.Popen(bash_command, stdout=subprocess.PIPE)


def show_image(path):
    bash_command = ['eog', path]
    subprocess.Popen(bash_command, stdout=subprocess.PIPE)


# Get robot number from active window name
def get_robot_from_window():
    bash_command = ['xdotool', 'getwindowfocus', 'getwindowname']
    p = subprocess.Popen(bash_command, stdout=subprocess.PIPE)
    out, err = p.communicate()
    match = re.match("toru-([0-9]{4}).*", out)
    result = int(match.group(1)) if match else 0
    return result


# Open 3d carstenlog in computer
def open_carstenlog(robot, file):
    bash_command = ['rosrun', 'box_detection_tools', '3d_evaluate_log.py', file]
    p = subprocess.Popen(bash_command, stdout=subprocess.PIPE)
    out, err = p.communicate()
    notify_send(out)

# Get text from clipboard
text = subprocess.Popen("xsel -p", shell=True, stdout=subprocess.PIPE).stdout.read()

# Identify text, call functions for each type of log.
match_video = re.match(
    ".*(\/tmp\/manipulation_videos\/toru-([0-9]{4})\/(.*\.avi))", text)
match_carsten = re.match(
    ".*(\/tmp\/box_detection\/)(.*[0-9]*\.[0-9]*\.tar\.gz)", text)
match_barcode = re.match(
    ".*(\/tmp\/barcode_detector\/toru-([0-9]{4})\/.*\/)(.*\.tif)", text)
match_manipulation = re.match(
    ".*(toru-([0-9]{4})-[0-9]{8}-[0-9]{6}-[0-9,a-f]{8}-[0-9,a-f]{4}-[0-9,a-f]{4}-[0-9,a-f]{4}-[0-9,a-f]{12})", text)

if match_video:
    robot = int(match_video.group(2))
    file = match_video.group(3)
    path = match_video.group(1)
    notify_send("Downloading {}".format(file))
    # TODO: Text is not suitable for download if it is not selected exactly!
    scp_to_folder(robot, path, "downlogs")
    path_to_video = "/tmp/toru" + str(robot) + "_" + "downlogs/" + file
    play_video(path_to_video)
elif match_carsten:
    robot = get_robot_from_window()
    if robot:
        file = match_carsten.group(2)
        path = match_carsten.group(1) + file
        notify_send("Downloading {}".format(file))
        scp_to_folder(robot, path, "downlogs")
        path_to_log = "/tmp/toru" + str(robot) + "_" + "downlogs/" + file
        open_carstenlog(robot, path_to_log)
    else:
        notify_send("Tried to get robot name from active window, alas no luck")
elif match_barcode:
    robot = int(match_barcode.group(2))
    path = match_barcode.group(1)
    file = match_barcode.group(3)
    notify_send("Downloading {}".format(file))
    scp_to_folder(robot, text, "downlogs")
    path = "/tmp/toru" + str(robot) + "_" + "downlogs/" + file
    show_image(path)
elif match_manipulation:
    robot = int(match_manipulation.group(2))
    file = match_manipulation.group(1)
    path = "/tmp/manipulation_logs/" + file
    notify_send("Downloading {}".format(file))
    scp_to_folder(robot, path, "downlogs")
else:
    notify_send("No match found")
