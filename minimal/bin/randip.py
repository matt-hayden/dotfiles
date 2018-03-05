#! /usr/bin/env python3
"""
Usage:
  randip [options] <network> [<count>]

Options:
  --no-color
  -v --verbose
"""
import ipaddress
import random


def randip(interface, count=1, sample=random.sample):
    interface = ipaddress.IPv4Interface(interface)
    ip, network = interface.ip, interface.network
    assert (count < network.num_addresses)
    not_this_host = set(_ for _ in network.hosts() if (_ != ip))
    return sample(not_this_host, count)


if __name__ == '__main__':
    import docopt
    import sys

    options = docopt.docopt(__doc__)
    if sys.stdout.isatty() and not options['--no-color']:
        def render(flag, text, highlights={ '>': '\x1b[1;37;44m', '*': '\x1b[3;36;40m', ' ': '\x1b[0m', None: '\x1b[0m' }):
            return highlights[flag]+text+highlights[None]
    else:
        def render(flag, text):
            return flag+text

    interface = ipaddress.IPv4Interface(options.pop('<network>'))
    ip, network = interface.ip, interface.network
    selected = set( randip(interface, count=int(options.pop('<count>') or 1)) )
    if options['--verbose']:
        for h in network.hosts():
            print(render('>' if h in selected else '*' if h == ip else ' ', str(h)))
    else:
        print( '\n'.join(str(_) for _ in sorted(selected)) )
