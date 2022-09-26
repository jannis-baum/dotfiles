#!/usr/local/bin/python

import sys, subprocess

from sympy import *
from symbol_definition import *

if __name__ == '__main__':
    latex = eval(f'latex({sys.argv[1]})')
    subprocess.run('pbcopy', universal_newlines=True, input=latex)
    print('closePanel')
