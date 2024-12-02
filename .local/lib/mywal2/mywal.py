#!/bin/env python
"""Manager for wallust, picking a file, and applying theme updates."""

import subprocess
import os
from pathlib import Path
import argparse

parser = argparse.ArgumentParser(prog="Manager for wallust and internal images.")

choices = ["get", "next", "prev"]
parser.add_argument("action", choices=choices)
parser.add_argument("-p", "--path", type=Path)
parser.add_argument("-r", "--reference", type=Path)

args = parser.parse_args()

wal_current_img = Path("~/.cache/wal/wal").expanduser()
dir_default_imgs = Path("~/images/wal").expanduser()
monitors = ["HDMI-A-1", "DP-3"]

lib_dir = Path(__file__).resolve().parent


def get_img() -> str:
	# retrieve img according to action
	dir = args.path
	ref = args.reference
	action = args.action

	if not ref:
		with wal_current_img.open(mode="r") as fd:
			ref = fd.readline().strip()

	if not dir:
		dir = dir_default_imgs

	cmd_fscroll = [
		f"{lib_dir}/file_scroller.py",
		action,
		"-p",
		str(dir),
		"-r",
		str(ref),
	]

	img = subprocess.run(cmd_fscroll, capture_output=True, text=True, check=True).stdout
	return img


def apply_wallust(img_path: str):
	# wallust...
	cmd_wallust = "wallust run {}"

	subprocess.run(cmd_wallust.format(img_path), shell=True)

	with wal_current_img.open(mode="w+") as fd:
		fd.write(img_path)


def apply_paper(img_path: str):
	# set wallpaper to all monitors
	# in the future, preload a window of files that we plant o scroll on
	cmd_paper_unload_all = "hyprctl hyprpaper unload all"
	cmd_paper_pre = 'hyprctl hyprpaper preload "{}"'
	cmd_paper_set = 'hyprctl hyprpaper wallpaper "{},{}"'

	subprocess.run(cmd_paper_unload_all, shell=True)
	for m in monitors:
		subprocess.run(cmd_paper_pre.format(img_path), shell=True)
		subprocess.run(cmd_paper_set.format(m, img_path), shell=True)


def apply_swww(img_path: str):
	# alternative to hyprpaper... if it works properly.
	cmd_swww = "swww img {}"

	subprocess.Popen(cmd_swww.format(img_path), shell=True)


# sync with everything...!

## For some reason, it seems that lushwal uses an internal cache when updating
## this results in applying color palette when nvim originally opened
# sync nvim lushwal
# id = subprocess.run("id -u", shell=True, capture_output=True, text=True).stdout.strip()
# usr_run_dir = Path(f"/run/user/{id}")
#
# cmd_nvr = 'nvr -s --nostart --servernbame "{}" -c "LushwalCompile'
#
# for file in usr_run_dir.iterdir():
# 	if file.is_file() and str(file).startswith("nvim.") and str(file).endswith(0.0):
# 		subprocess.run(cmd_nvr.format(str(file)), shell=True)


def apply_gtk():
	# gradience for gtk
	subprocess.Popen(f"{lib_dir}/apply-kvantum-gradience -s", shell=True)


def apply_x():
	# xrdb
	cfg_dir = os.getenv("XDG_CONFIG_HOME")
	subprocess.Popen(f"xrdb -merge {cfg_dir}/X11/Xresources", shell=True)


def apply_mako():
	# mako
	cmd_mako = str(Path("~/.config/mako/sync-mako").expanduser())
	subprocess.Popen(cmd_mako, shell=True)


def apply_fox():
	# pywalfox
	subprocess.Popen("pywalfox update", shell=True)


def main():
	img_path = get_img()
	apply_wallust(img_path)
	apply_paper(img_path)
	# apply_swww(img_path)
	apply_gtk()
	apply_x()
	apply_mako()
	apply_fox()


if __name__ == "__main__":
	main()
