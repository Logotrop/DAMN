import subprocess,os,sys

session_token_command = ["op", "signin", "ibm", "--raw"]
session_token = subprocess.check_output(session_token_command, text=True).strip()

def get_all_items(session_token):
    shell_command = ["op", "get", "items", "--session", session_token]
    return subprocess.check_output(shell_command)
print(subprocess.Popen('powershell.exe $env:OP_SESSION_ibm', stdout=sys.stdout).communicate())
#print(subprocess.check_output("$env:OP_SESSION_ibm"))