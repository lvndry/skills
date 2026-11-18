"""Embed images into a board and write a frozen copy for screenshots.

Usage:
    python3 build.py board.src.html --out board.html [--still]

Every `__EMBED:path__` placeholder becomes a data URI. A relative path is read
from the source file's folder. `--still` also writes `still/index.html`, a copy
with every `.canvas .in` intro transition frozen at its end state, so a
scrolling screenshotter shows each sketch's final composition.
"""

import argparse
import base64
import mimetypes
import pathlib
import re
import sys

PLACEHOLDER = re.compile(r"__EMBED:([^_][^\s\"')]*?)__")
FREEZE = ".canvas .in{transition:none!important;opacity:1!important;transform:none!important}"


def data_uri(path: pathlib.Path) -> str:
    mime = mimetypes.guess_type(path.name)[0] or "application/octet-stream"
    if path.suffix.lower() == ".webp":
        mime = "image/webp"
    return f"data:{mime};base64," + base64.b64encode(path.read_bytes()).decode()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source")
    parser.add_argument("--out", required=True)
    parser.add_argument("--still", action="store_true")
    arguments = parser.parse_args()

    source = pathlib.Path(arguments.source).resolve()
    text = source.read_text()
    missing = []

    def replace(match: re.Match) -> str:
        target = pathlib.Path(match.group(1)).expanduser()
        if not target.is_absolute():
            target = source.parent / target
        if not target.exists():
            missing.append(str(target))
            return match.group(0)
        return data_uri(target)

    text = PLACEHOLDER.sub(replace, text)
    if missing:
        print("Missing files, left as placeholders:", *missing, sep="\n  ", file=sys.stderr)
        return 1

    output = pathlib.Path(arguments.out).resolve()
    output.write_text(text)
    print(f"{output} ({len(text) // 1024} KB)")

    if arguments.still:
        still = output.parent / "still" / "index.html"
        still.parent.mkdir(exist_ok=True)
        still.write_text(text.replace("</style>", FREEZE + "</style>", 1))
        print(still)
    return 0


if __name__ == "__main__":
    sys.exit(main())
