#!/usr/bin/env python
"""Report render.
"""
import sys
import re
import argparse
from jinja2 import Template
from jinja2 import Environment, FileSystemLoader


def parse_cmd():
    """Parse cmd.
    """
    parser = argparse.ArgumentParser(
        description="Render report according to template file",
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument(
        "--baseline_file",
        type=str,
        required=True,
        help=("Absolution path of baseline file. "))
    parser.add_argument(
        "--result_file",
        type=str,
        required=True,
        help=("Absolution path of result file with the same format"
              "as baseline_file."))
    parser.add_argument(
        "--template_file",
        type=str,
        required=False,
        help=("Absolution path of template file with jinja2 format."))

    return parser.parse_args()


def main():
    """Render report.
    """
    args = parse_cmd()
    baseline = {}
    result = {}
    with open(args.baseline_file, 'r') as f:
        for line in f:
            k, v = line.rstrip().split("=")
            baseline[k] = float(v)
    with open(args.result_file, 'r') as f:
        for line in f:
            k, v = line.rstrip().split("=")
            result[k] = float(v)

    env = Environment(loader=FileSystemLoader('./'))
    template = env.get_template(args.template_file)
    r = template.render(result=result, baseline=baseline)
    print r
    return 0


if __name__ == "__main__":
    sys.exit(main())
