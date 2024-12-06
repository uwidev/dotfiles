#!/bin/env python
"""Utility to get some file from a directory given a ref file.

implemented: current, next, prev
maybe: window from current, all
"""

from pathlib import Path
import argparse

parser = argparse.ArgumentParser(
	prog="Utility to get the next or previous file in a directory of files."
)

choices = ["get", "next", "prev"]
parser.add_argument("action", choices=choices)
parser.add_argument("-p", "--path", type=Path, required=True)
parser.add_argument("-r", "--reference", type=Path, required=True)

args = parser.parse_args()


def get_file(dir: Path, ref: Path, action: str):
	"""Get the next/prev file from a directory."""
	files = sorted([f for f in dir.iterdir() if f.is_file()])

	if ref not in files:
		return files[0]

	if action == "get":
		return ref

	offset = 1 if action == "next" else -1
	i = (files.index(ref) + offset) % len(files)
	return files[i]


if __name__ == "__main__":
	dir: Path = args.path.resolve()
	ref: Path = args.reference.resolve()
	action: str = args.action

	if action not in choices:
		msg = f"action {action} must one of the following {choices}"
		raise ValueError(msg)

	if not dir.is_dir():
		msg = f"Path {dir} must be a path to a directory."
		raise NotADirectoryError(msg)

	# # If a file does not exist, just return the first file from path.
	# if not ref.is_file():
	# 	msg = f"Reference file {ref} is not a file."
	# 	raise IsADirectoryError(msg)

	file = get_file(dir, ref, action)
	print(file)
