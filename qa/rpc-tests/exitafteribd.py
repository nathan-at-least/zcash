#!/usr/bin/env python
# Copyright (c) 2019 The Zcash developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or https://www.opensource.org/licenses/mit-license.php .

import sys

from test_framework.test_framework import BitcoinTestFramework
from test_framework.util import \
    assert_equal, start_node, connect_nodes_bi, bitcoind_processes

import logging

assert sys.version_info < (3,), \
    ur"This script does not run under Python 3. Please use Python 2.7.x."

logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.INFO)


class ExitAfterIBD (BitcoinTestFramework):
    def run_test(self):
        logger = logging.getLogger(type(self).__name__)

        def log(tmpl, *args):
            logger.info('%s', tmpl.format(*args))

        # create a new node in -exitafteridb mode:
        ix = len(self.nodes)
        log('Starting node {} with -exitafteribd mode.', ix)
        node = start_node(ix, self.options.tmpdir, ['-exitafteribd'])
        self.nodes.append(node)

        log('Connecting ibd node {} with node 0.', ix)
        connect_nodes_bi(self.nodes, 0, ix)

        log('Syncing all nodes.')
        self.sync_all()

        # FIXME: Accessing bitcoind_processes is a hacky layer violation:
        log('Waiting for zcashd node {} process exit.', ix)
        status = bitcoind_processes[ix].wait()
        log('Exit status for zcashd node {} process: {}.', ix, status)
        assert_equal(0, status)


if __name__ == '__main__':
    ExitAfterIBD().main()
