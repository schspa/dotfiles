#!/usr/bin/env python3
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
import sys
import keyring
import json

def get_mail_conf(repo):
    keys=repo.split('/')
    jsonstring = keyring.get_password("email-conf", keys[0])
    if jsonstring is None:
        return None
    mail_conf = json.loads(jsonstring)
    return mail_conf[":" + keys[1]]

def set_mail_conf(repo, value):
    keys=repo.split('/')
    jsonstring = keyring.get_password("email-conf", keys[0])
    mail_conf = None
    try:
        mail_conf = json.loads(jsonstring)
    except TypeError:
        mail_conf = {}
    mail_conf[":" + keys[1]] = value
    keyring.set_password("email-conf", keys[0], json.dumps(mail_conf))


FOLDER_MAP = {
    'inbox':   'INBOX',
    "sent":    "[Gmail]/已发邮件",
    "drafts":  "[Gmail]/草稿",
    "trash":   "[Gmail]/已删除邮件",
    "archive": "[Gmail]/所有邮件",
    "mail-list/mine": "mail-list/mine",
}

INVERSE_FOLDER_MAP = {v: k for k, v in FOLDER_MAP.items()}

INCLUDED_FOLDERS = ["mail-list", "mail-list/mine" "已发送邮件"] + list(FOLDER_MAP.values())

def local_folder_to_gmail_folder(folder):
    return FOLDER_MAP.get(folder, folder)

def gmail_folder_to_local_folder(folder):
    return INVERSE_FOLDER_MAP.get(folder, folder)

FOLDER_MAP_WORK = {
    'inbox':   'INBOX',
    "sent":    "已发送邮件",
    "drafts":  "草稿",
    "trash":   "已删除邮件",
    "archive": "存档",
}

INVERSE_FOLDER_MAP_WORK = {v: k for k, v in FOLDER_MAP_WORK.items()}

def local_folder_to_work_folder(folder):
    return FOLDER_MAP_WORK.get(folder, folder)

def work_folder_to_local_folder(folder):
    return INVERSE_FOLDER_MAP_WORK.get(folder, folder)

def should_include_folder(folder):
    return folder in INCLUDED_FOLDERS

if __name__ == '__main__':
    import click
    import getpass
    @click.command()
    @click.option('--verbose', is_flag=True)
    @click.option('-r', '--remote', default=None)
    @click.option('-u', '--username', default=None)
    def cli(verbose, remote, username):
        """Print config"""
        password = None

        print(local_folder_to_gmail_folder("archive"))
        print(gmail_folder_to_local_folder("[Gmail]/Sent Mail"))

        if remote != "gmail":
            if password is None:
                password = getpass.getpass()
            elif password == "-":
                password = sys.stdin.read().strip()
                pass

            set_mail_conf('work/host', remote)
            set_mail_conf('work/username', username)
            set_mail_conf('work/password', password)
            print(get_mail_conf('work/host'))
            print(get_mail_conf('work/username'))
            print(get_mail_conf('work/password'))
            pass

        set_mail_conf('gmail/client_id', '')
        set_mail_conf('gmail/client_secret', '')
        set_mail_conf('gmail/refresh_token', '')
        print(get_mail_conf('gmail/client_id'))
        get_mail_conf('gmail/client_secret')
        get_mail_conf('gmail/refresh_token')

    cli()
