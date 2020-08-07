#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#   .offlineimap.py
#
#   Copyright (C) 2020, schspa, all rights reserved.
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import keyring

def get_host(repo):
    return keyring.get_password("offlineimap_{:s}".format(repo), 'host')

def get_username(repo):
    return keyring.get_password("offlineimap_{:s}".format(repo), 'username')

def get_password(repo):
    return keyring.get_password("offlineimap_{:s}".format(repo), 'password')

if __name__ == "__main__":
    import sys
    import os
    import getpass
    if len(sys.argv) != 4:
        print "Usage: %s <repository> <host> <username>" \
            % (os.path.basename(sys.argv[0]))
        sys.exit(0)
    repo, host, username = sys.argv[1:]
    password = getpass.getpass("Enter password for user '%s': " % username)
    password_confirmation = getpass.getpass("Confirm password: ")
    if password != password_confirmation:
        print "Error: password confirmation does not match"
        sys.exit(1)
    keyring.set_password("offlineimap_{:s}".format(repo), 'host', host)
    keyring.set_password("offlineimap_{:s}".format(repo), 'username', username)
    keyring.set_password("offlineimap_{:s}".format(repo), 'password', password)
