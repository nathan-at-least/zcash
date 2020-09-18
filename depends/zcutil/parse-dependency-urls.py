#!/usr/bin/env python3
"""
Parse dependency name, version, url, and sha256 from `./depends` makefiles.
"""

import re
import sys
import json
from pathlib import Path

SKIP = [
    # Not packages:
    'packages.mk',
    'vendorcrate.mk',
]

OVERRIDES = {
    'native_rust.mk': {
        'package': 'native_rust',
        'archives': [{
            'url': 'https://static.rust-lang.org/dist/rust-1.42.0-x86_64-unknown-linux-gnu.tar.gz',
            'sha256': '7d1e07ad9c8a33d8d039def7c0a131c5917aa3ea0af3d0cc399c6faf7b789052',
        }, {
            'url': 'https://static.rust-lang.org/dist/rust-std-1.42.0-x86_64-apple-darwin.tar.gz',
            'sha256': '1d61e9ed5d29e1bb4c18e13d551c6d856c73fb8b410053245dc6e0d3b3a0e92c',
            'stamp_extras': ['rust-1.42.0-x86_64-unknown-linux-gnu.tar.gz'],
        }, {
            'url': 'https://static.rust-lang.org/dist/rust-std-1.42.0-x86_64-pc-windows-gnu.tar.gz',
            'sha256': '8a8389f3860df6f42fbf8b76a62ddc7b9b6fe6d0fb526dcfc42faab1005bfb6d',
            'stamp_extras': ['rust-1.42.0-x86_64-unknown-linux-gnu.tar.gz'],
        }],
    },
    'native_cctools.mk': {
        'package': 'native_cctools',
        'archives': [{
            'url': 'https://github.com/tpoechtrager/cctools-port/archive/55562e4073dea0fbfd0b20e0bf69ffe6390c7f97.tar.gz',
            'sha256': 'e51995a843533a3dac155dd0c71362dd471597a2d23f13dff194c6285362f875',
            'stamp_extras': [
                'clang-llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz',
                '3efb201881e7a76a21e0554906cf306432539cef.tar.gz',
            ],
        }, {
            'filename': 'clang-llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz',
            'url': 'https://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz',
            'sha256': '9ef854b71949f825362a119bf2597f744836cb571131ae6b721cd102ffea8cd0',
            'stamp_extras': None,
        }, {
            'url': 'https://github.com/tpoechtrager/apple-libtapi/archive/3efb201881e7a76a21e0554906cf306432539cef.tar.gz',
            'sha256': '380c1ca37cfa04a8699d0887a8d3ee1ad27f3d08baba78887c73b09485c0fbd3',
            'stamp_extras': None,
        }],
    },
}

def main():
    result = []

    dependsdir = Path(sys.argv[0]).parent.parent.resolve()
    #info(f'Scanning packages: {depends}')
    for p in (dependsdir / 'packages').glob('*.mk'):
        if p.name in SKIP:
            continue

        #info(f'Parsing: {p}')
        try:
            pkginfo = get_source_info(p)
        except Exception as e:
            warn(f'Skipping {p}: {e}')
            raise
        else:
            result.append(pkginfo)

    json.dump(result, sys.stdout, indent=2, sort_keys=True)


def get_source_info(path):
    try:
        return OVERRIDES[path.name]
    except KeyError:
        return extract_source_info(path)


def extract_source_info(path):
    paramrgx = re.compile(r'^(?P<key>\S+)=(?P<value>.*)$')
    rawparams = {}
    for line in path.open('r'):
        m = paramrgx.match(line)
        if m:
            rawparams[m.group('key')] = m.group('value') 

    resolver = Resolver(rawparams)

    package = resolver['package']
    version = resolver['$(package)_version']
    urlbase = resolver['$(package)_download_path'].rstrip('/')

    filename = resolver['$(package)_file_name']
    try:
        urlfile = resolver['$(package)_download_file']
    except KeyError:
        urlfile = filename

    try:
        sha256 = resolver[f'$(package)_sha256_hash']
    except KeyError as e:
        e.args += (f'Found url for {platform!r} but no sha256 hash.',)
        raise
    else:
        urlentry = {
            'url': f'{urlbase}/{urlfile}',
            'sha256': sha256,
        }
        if filename != urlfile:
            urlentry['filename'] = filename

        return {
            'package': f'{package}',
            'archives': [urlentry],
        }


class Resolver:
    def __init__(self, rawparams):
        self._rp = rawparams

    def __getitem__(self, key):
        # truly awful hack
        try:
            rawval = self._rp[key]
        except KeyError as e:
            e.args += (f'Missing key {key!r} in params {self._rp.keys()}',)
            raise
        else:
            return self._cook(rawval)

    def _cook(self, rawval):
        cooked = ''
        state = 'base'
        depth = None
        key = None
        for i, c in enumerate(rawval):
            if state == 'base':
                if c == '$':
                    state = 'expecting-expansion'
                else:
                    cooked += c
            elif state == 'expecting-expansion':
                assert c == '(', f"expected '(', found {c!r} at col {i+1} in {rawval!r}; cooked: {cooked!r}"
                state = 'expansion' 
                depth = 1
                key = ''
            elif state == 'expansion':
                assert isinstance(depth, int), repr(locals())
                assert isinstance(key, str), repr(locals())
                if c == '(':
                    depth += 1
                    key += c
                elif c == ')':
                    depth -= 1
                    if depth == 0:
                        try:
                            cooked += self._rp[key]
                        except KeyError as e:
                            e.args += (f'rawval: {rawval!r}; cooked: {cooked!r}; key: {key!r}',)
                            raise
                        state = 'base'
                        depth = None
                        key = None
                    else:
                        key += c
                else:
                    key += c

        return cooked
            

def info(msg):
    sys.stderr.write(f'{msg}\n')


def warn(s):
    info(f'WARNING: {s}')
    

if __name__ == '__main__':
    main()
