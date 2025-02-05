#!/bin/env python
"""Manager for wallust, picking a file, and applying theme updates.

Hyprpaper requires
"""

import subprocess
import os
from pathlib import Path
import argparse


wal_current_img = Path("~/.cache/wal/wal").expanduser()
dir_default_imgs = Path("~/imgs/wal").expanduser()

lib_dir = Path(__file__).resolve().parent


def is_image(img_pth: Path) -> bool:
	cmd_check_mime = ["xdg-mime", "query", "filetype", str(img_pth)]
	output = subprocess.run(
		cmd_check_mime, capture_output=True, text=True, check=True
	).stdout

	if "image/" in output:
		return True

	return False


def get_current_img() -> Path:
	with wal_current_img.open(mode="r") as fd:
		return fd.readline().strip()


def get_img(action: str, dir: Path, result: Path) -> str:
	# retrieve img according to action
	cmd_fscroll = [
		f"{lib_dir}/file_scroller.py",
		action,
		"-p",
		dir,
	]

	cur_img = get_current_img()
	while True:
		result = subprocess.run(
			cmd_fscroll + ["-r", result], capture_output=True, text=True, check=True
		).stdout.rstrip()

		if is_image(Path(result)):
			return Path(result)

		if result == str(cur_img):
			return cur_img


def apply_wallust(im_pth: Path):
	# wallust...
	cmd_wallust = "wallust run {}"

	subprocess.run(cmd_wallust.format(im_pth), shell=True)

	with wal_current_img.open(mode="w+") as fd:
		fd.write(str(im_pth))


def apply_paper(im_pth: Path):
	# set wallpaper to all monitors
	# in the future, preload a window of files that we plant o scroll on
	monitors = subprocess.run(
		"hyprctl monitors | grep Monitor | cut -d' ' -f2",
		shell=True,
		capture_output=True,
		text=True,
	).stdout.split()

	cmd_paper_unload_all = "hyprctl hyprpaper unload all"
	cmd_paper_pre = 'hyprctl hyprpaper preload "{}"'
	cmd_paper_set = 'hyprctl hyprpaper wallpaper "{},{}"'

	subprocess.run(cmd_paper_unload_all, shell=True)
	subprocess.run(cmd_paper_pre.format(str(im_pth)), shell=True)

	for m in monitors:
		subprocess.run(cmd_paper_set.format(m, str(im_pth)), shell=True)


def apply_swww(im_pth: Path):
	# alternative to hyprpaper... if it works properly.
	cmd_swww = f'swww img "{str(im_pth)}" --transition-type any --transition-duration 1 --transition-fps 144 --resize crop'

	subprocess.Popen(cmd_swww, shell=True)


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


def apply_discord():
	subprocess.Popen(f"{lib_dir}/walcord", shell=True)


def main():
	parser = argparse.ArgumentParser(prog="Manager for wallust and internal images.")

	choices = ["get", "next", "prev"]
	parser.add_argument("action", choices=choices)
	parser.add_argument("-p", "--path", type=Path)
	parser.add_argument("-r", "--reference", type=Path)

	args = parser.parse_args()

	action = args.action or "get"
	dir = args.path or dir_default_imgs
	ref = args.reference or get_current_img()

	im_pth = get_img(action, dir, ref)
	apply_wallust(im_pth)
	# apply_paper(im_pth)
	apply_swww(im_pth)
	apply_gtk()
	apply_x()
	apply_mako()
	apply_fox()


if __name__ == "__main__":
	main()
