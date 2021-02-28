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
import json

def get_mail_conf(repo):
    keys=repo.split('/')
    jsonstring = keyring.get_password("email-conf", keys[0])
    mail_conf = json.loads(jsonstring)
    return mail_conf[":" + keys[1]]

FOLDER_MAP = {
    'inbox':   'INBOX',
    "sent":    "[Gmail]/Sent Mail",
    "drafts":  "[Gmail]/Drafts",
    "trash":   "[Gmail]/Trash",
    "archive": "[Gmail]/All Mail"
}

INVERSE_FOLDER_MAP = {v:k for k,v in FOLDER_MAP.items()}

INCLUDED_FOLDERS = ["INBOX"] + FOLDER_MAP.values()

def local_folder_to_gmail_folder(folder):
    return FOLDER_MAP.get(folder, folder)

def gmail_folder_to_local_folder(folder):
    return INVERSE_FOLDER_MAP.get(folder, folder)

def should_include_folder(folder):
    return folder in INCLUDED_FOLDERS

