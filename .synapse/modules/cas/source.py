#!/usr/local/bin/python

import sys, json

from sympy import *
from symbol_definition import *

if __name__ == '__main__':
    result = [{
        'symbol': '􀅮',
        'title': str(eval(sys.argv[1]))
    }]
    print(json.dumps(result))
