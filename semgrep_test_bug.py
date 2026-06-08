# TEMPORARY FILE - added only to verify the Semgrep PR check catches issues.
# Safe to delete once the scan has been confirmed to fail on these findings.

import os
import subprocess


def run_user_command(user_input):
    # BUG: command injection - shell=True with untrusted input
    subprocess.call(user_input, shell=True)
    os.system("echo " + user_input)


def evaluate(expr):
    # BUG: arbitrary code execution via eval
    return eval(expr)
