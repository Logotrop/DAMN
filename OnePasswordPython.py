import subprocess
import sys
import json


def get_un_and_pw(op_item, session_token):
    """
    1. run shell command to get json data from op cli
    2. convert json to python dictionary
    3. dict['details']['fields'] has a list of dictionaries with un and pw
    4. extract username(un) and password(pw)
dict['details']['fields']

    [{'designation': 'password', 'name': 'password', 'type': 'P', 'value': 'this_is_a_fake_password'},  {'designation': 'username', 'name': 'username', 'type': 'T', 'value': 'fake_username'}]
    """
    dict['details']['fields']
    # get json data of op_item
    shell_command = ["op", "get", "item", op_item, "--session", session_token]
    json_data = subprocess.check_output(shell_command)

    # convert json_data into python dict
    op_dict = json.loads(json_data)

    # extract un and pw
    for dict_item in op_dict["details"]["fields"]:  # looping over list of dictionaries
        try:
            if dict_item["designation"] == "password":
                pw = dict_item["value"]
        except KeyError:
            pass
        try:
            if dict_item["designation"] == "username":
                un = dict_item["value"]
        except KeyError:
            pass
    return un, pw


def get_pw_only(op_item, session_token):
    shell_command = ["op", "get", "item", op_item, "--session", session_token]
    json_data = subprocess.check_output(shell_command)
    op_dict = json.loads(json_data)
    for dict_item in op_dict["details"]["fields"]:  # looping over list of dictionaries
        try:
            if dict_item["designation"] == "password":
                pw = dict_item["value"]
        except KeyError:
            pass
    return pw


def get_totp(op_item, session_token):
    """
    Return time based one time password (totp) for op item
    """
    try:
        shell_command = ["op", "get", "totp", op_item, "--session", session_token]
        return subprocess.check_output(shell_command, text=True).strip()
    except Exception:
        return None


def main(op_item, session_token=None):
    """
    Input: name of one password item (op_item)
    Output: return username, password, TOTP.  TOTP will return None if absent
    """
    un, pw = get_un_and_pw(op_item, session_token)
    totp = get_totp(op_item, session_token)
    return un, pw, totp


if __name__ == "__main__":
    # code below if used as a command line program

    # log into op and get session token
    # can also use this as a module and embed next two lines of code in other programs making a call to this one to get session_token
    session_token_command = ["op", "signin", "ibm", "--raw"]
    session_token = subprocess.check_output(session_token_command, text=True).strip()

    # get credentials
    un, pw, totp = main(sys.argv[1], session_token)

    # display retrieved credentials
    print(f"Login item: {sys.argv[1]}")
    print(f"Username: {un}")
    print(f"Password: {pw}")
    print(f"TOTP: {totp}")