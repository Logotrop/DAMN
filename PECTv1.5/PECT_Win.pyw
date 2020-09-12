#!/usr/bin/python

from tkinter import *
from tkinter import ttk
from tkinter import font
import time
import subprocess
import webbrowser
import os
import re
import signal
import ctypes

cwd = os.getcwd()

##############################################################################################
with open(cwd + "\WINDOWS\check_at_07_30\check_at_07_30.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\check_at_07_30\ " + "\n"
with open(cwd + "\WINDOWS\check_at_07_30\check_at_07_30.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\check_at_08_32_onlyA\check_at_08_32_onlyA.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\check_at_08_32_onlyA\ " + "\n"
with open(cwd + "\WINDOWS\check_at_08_32_onlyA\check_at_08_32_onlyA.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\PELCONTR_CT01\PELCONTR_CT01.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\PELCONTR_CT01\ " + "\n"
with open(cwd + "\WINDOWS\PELCONTR_CT01\PELCONTR_CT01.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\PELEG\PELEG.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\PELEG\ " + "\n"
with open(cwd + "\WINDOWS\PELEG\PELEG.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\PELEH\PELEH.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\PELEH\ " + "\n"
with open(cwd + "\WINDOWS\PELEH\PELEH.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\Pelican_BCPF\Pelican_BCPF.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\Pelican_BCPF\ " + "\n"
with open(cwd + "\WINDOWS\Pelican_BCPF\Pelican_BCPF.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\Pelican_PELCD_A7\Pelican_PELCD_A7.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\Pelican_PELCD_A7\ " + "\n"
with open(cwd + "\WINDOWS\Pelican_PELCD_A7\Pelican_PELCD_A7.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\Pelican_PELE1\Pelican_PELE1.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\Pelican_PELE1\ " + "\n"
with open(cwd + "\WINDOWS\Pelican_PELE1\Pelican_PELE1.ws", 'w') as file:
    file.writelines(data)
file.close()
#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\Pelican_PELIS_SL11\Pelican_PELIS_SL11.ws", 'r') as file:
    data = file.readlines()
file.close()
data[24] = "DIR=" + cwd + "\WINDOWS\Pelican_PELIS_SL11\ " + "\n"
with open(cwd + "\WINDOWS\Pelican_PELIS_SL11\Pelican_PELIS_SL11.ws", 'w') as file:
    file.writelines(data)
file.close()


#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\CRF_sessions\CRF_TSAD.ws", 'r') as file:
    data = file.readlines()
file.close()
data[25] = "DIR=" + cwd + "\WINDOWS\CRF_sessions\ " + "\n"
with open(cwd + "\WINDOWS\CRF_sessions\CRF_TSAD.ws", 'w') as file:
    file.writelines(data)
file.close()

#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\CRF_sessions\CRF_BCP.ws", 'r') as file:
    data = file.readlines()
file.close()
data[25] = "DIR=" + cwd + "\WINDOWS\CRF_sessions\ " + "\n"
with open(cwd + "\WINDOWS\CRF_sessions\CRF_BCP.ws", 'w') as file:
    file.writelines(data)
file.close()

#--------------------------------------------------------------------------------------------------#
with open(cwd + "\WINDOWS\CRF_sessions\CRF_CICSEXPL.ws", 'r') as file:
    data = file.readlines()
file.close()
data[25] = "DIR=" + cwd + "\WINDOWS\CRF_sessions\ " + "\n"
with open(cwd + "\WINDOWS\CRF_sessions\CRF_CICSEXPL.ws", 'w') as file:
    file.writelines(data)
file.close()



##############################################################################################

def check_at_07_30_session():
    text1.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\check_at_07_30\check_at_07_30.ws", "/M=check_at_07_30.mac"]).wait()
        output = os.path.isfile(cwd + '\WINDOWS\check_at_07_30\check_at_07_30.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\check_at_07_30\check_at_07_30.txt', 'r')
            text1.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("Pelicans check ended")

def PELCONTR_CT01_session():
    text2.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\PELCONTR_CT01\PELCONTR_CT01.ws", "/M=PELCONTR_CT01.mac"]).wait()
        output = os.path.isfile(cwd + '\WINDOWS\PELCONTR_CT01\PELCONTR_CT01.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\PELCONTR_CT01\PELCONTR_CT01.txt', 'r')
            text2.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("PELCONTR_CT01 ended")

def Pelican_BCPF_session():
    text3.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\Pelican_BCPF\Pelican_BCPF.ws", "/M=Pelican_BCPF.mac"]).wait()
        output = os.path.isfile(cwd + '\WINDOWS\Pelican_BCPF\Pelican_BCPF.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\Pelican_BCPF\Pelican_BCPF.txt', 'r')
            text3.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("BCPF ended")

def Pelican_PELE1_session():
    text4.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\Pelican_PELE1\Pelican_PELE1.ws", "/M=Pelican_PELE1.mac"]).wait()
        output = os.path.isfile(cwd + '\WINDOWS\Pelican_PELE1\Pelican_PELE1.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\Pelican_PELE1\Pelican_PELE1.txt', 'r')
            text4.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("PELE1 ended")

def Pelican_PELCD_A7_session():
    text5.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\Pelican_PELCD_A7\Pelican_PELCD_A7.ws", "/M=Pelican_PELCD_A7.mac"]).wait()
        output = os.path.isfile(cwd + '\WINDOWS\Pelican_PELCD_A7\Pelican_PELCD_A7.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\Pelican_PELCD_A7\Pelican_PELCD_A7.txt', 'r')
            text5.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("PELCD A7 ended")


def Pelican_PELIS_SL11_session():
    text6.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        p=subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\Pelican_PELIS_SL11\Pelican_PELIS_SL11.ws", "/M=Pelican_PELIS_SL11.mac"]).wait()
        #subprocess.call(['taskkill', '/F', '/T', '/PID', str(p.pid)])
        output = os.path.isfile(cwd + '\WINDOWS\Pelican_PELIS_SL11\Pelican_PELIS_SL11.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\Pelican_PELIS_SL11\Pelican_PELIS_SL11.txt', 'r')
            text6.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("PELIS SL11 ended")


def check_at_08_32_onlyA_session():
    text7.delete(1.0, END)
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe', "/S=Y",
                          cwd + "\WINDOWS\check_at_08_32_onlyA\check_at_08_32_onlyA.ws", "/M=check_at_08_32_onlyA.mac"]).wait()
        output = os.path.isfile(cwd + '\WINDOWS\check_at_08_32_onlyA\check_at_08_32_onlyA.txt')
        if output == True :
            f = open(cwd + '\WINDOWS\check_at_08_32_onlyA\check_at_08_32_onlyA.txt', 'r')
            text7.insert(END, f.read())
    else:
        print("Not right credentials")
    v.set("PELICANS_only_A ended")


def PELEH_session():
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',
                          cwd + "\WINDOWS\PELEH\PELEH.ws", "/M=PELEH.mac"])
    else:
        print("Not right credentials")
    v.set("PELEH button clicked!")


def PELEG_session():
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',
                          cwd + "\WINDOWS\PELEG\PELEG.ws", "/M=PELEG.mac"])
    else:
        print("Not right credentials")
    v.set("PELEG button clicked!")

def CRF_sessions():
    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0]:
        name = line[0]
    if line[1]:
        password = line[1]
    file1.close()
    if len(name.strip()) == 7 and len(password.strip()) == 8:
        TSAD_file = cwd + "\WINDOWS\CRF_sessions\CRF_TSAD.ws"

        # use windows and open the session
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',TSAD_file, "/M=CRF_TSAD.mac"])
        BCP_file = cwd + "\WINDOWS\CRF_sessions\CRF_BCP.ws"

        # use windows and open the session
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',BCP_file, "/M=CRF_BCP.mac"])
        CICSEXPL_file = cwd + "\WINDOWS\CRF_sessions\CRF_CICSEXPL.ws"

        # use windows and open the session
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',CICSEXPL_file, "/M=CRF_CICSEXPL.mac"])
        EX01_file = cwd + "\WINDOWS\CRF_sessions\CRF_C000_EX01.ws"

        # use windows and open the session
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',EX01_file])
        DV02_file = cwd + "\WINDOWS\CRF_sessions\CRF_C000_DV02.ws"

        # use windows and open the session
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',DV02_file])
        BACKUP_file = cwd + "\WINDOWS\CRF_sessions\CRF_BackUP.ws"

        # use windows and open the session
        subprocess.Popen([r'C:\Program Files (x86)\IBM\Personal Communications\pcsws.exe',BACKUP_file])
    else:
        print("Not right credentials")
    v.set("SESSIONS button clicked!")




def update_timeText():
# Get the current time
    current = time.strftime("%a, %d. %B %Y %H:%M:%S")
    current_time = time.strftime("%H:%M:%S")
    current_day = time.strftime("%a")
# Update the timeText Label box with the current time
    timeText.configure(text=current)
# Call the update_timeText() function after 1 second
    root.after(1000, update_timeText)
# We will define the automatic checks
    #print(current[0:3].strip())
    my_list = ["02:00:00-CT01","06:00:00-PELE1","07:02:00-PELCD_A7","07:30:00-Pelicans","07:33:00-PELCD_A7","08:02:00-PELCD_A7","08:30:00-Pelicans_Only_A","08:32:00-PELCD_A7","09:02:00-PELCD_A7","09:32:00-PELCD_A7","10:02:00-PELCD_A7","10:32:00-PELCD_A7","11:02:00-PELCD_A7","11:32:00-PELCD_A7","12:00:00-PELE1","12:02:00-PELCD_A7","15:05:00-CT01","16:15:00-BCPF","18:00:00-PELE1"]
    try:
        my_lbl=sorted(x for x in my_list if x >= current_time.strip())[0]
        checks_label.configure(text="Next check at: "+my_lbl)
    except IndexError:
        checks_label.configure(text="Next check at: "+"02:00:00-CT01")
    try:
        my_lbl1=sorted(x for x in my_list if x <= current_time.strip())[-1]
        checks_label1.configure(text="Previous check at : "+my_lbl1)
    except IndexError:
        checks_label1.configure(text="Previous check at : "+"18:00:00-PELE1")

    if current_time.strip() == "07:30:00":
        check_at_07_30_session()
    elif (current_time.strip() == "15:05:00") or (current_time.strip() == "02:00:00"):
        PELCONTR_CT01_session()
    elif current_time.strip() == "16:15:00":
        Pelican_BCPF_session()
    elif (current_time.strip() == "06:00:00") or (current_time.strip() == "12:00:00") or (current_time.strip() == "18:00:00"):
        Pelican_PELE1_session()
    elif (current_time.strip() == "07:02:00") or (current_time.strip() == "07:33:00") or (
            current_time.strip() == "08:02:00") or (current_time.strip() == "08:32:00") or (
            current_time.strip() == "09:02:00") or (current_time.strip() == "09:32:00") or (
            current_time.strip() == "10:02:00") or (current_time.strip() == "10:32:00") or (
            current_time.strip() == "11:02:00") or (current_time.strip() == "11:32:00") or (
            current_time.strip() == "12:02:00"):
        Pelican_PELCD_A7_session()
    elif (current_day.strip() == "Sun") and (current_time.strip() == "16:00:00"):
        Pelican_PELIS_SL11_session()
    elif current_time.strip() == "08:30:00":
        check_at_08_32_onlyA_session()



def help_index():
    master1 = Tk()
    master1.title("Help Index")

    font_type="Times", 13
    font_type_link = "Times", 13, "bold italic"

    def link1_function(event):
        webbrowser.open(r"Notes://mopndi09/C125700B00420464/C3792F13CEEE743AC1256FA90031AC03/F1ACCC4F5ECFC9ADC1257A5400611B3C ")

    def link2_function(event):
        webbrowser.open(r"Notes://mopndi09/C125700B00420464/C3792F13CEEE743AC1256FA90031AC03/7243553AEE45597AC1257A5400727A00 ")

    def link3_function(event):
        webbrowser.open(r"Notes://mopndi09/C125700B00420464/C3792F13CEEE743AC1256FA90031AC03/F8E17E274797FF1CC1257A54003BA3C7 ")

    def link4_function(event):
        webbrowser.open(r"Notes://mopndi09/C125700B00420464/C3792F13CEEE743AC1256FA90031AC03/730BDA204B0F037FC1257BAC004F7824 ")

    def link5_function(event):
        webbrowser.open(r"Notes://mopndi09/C125700B00420464/C3792F13CEEE743AC1256FA90031AC03/C9F43412A1F3BB5FC1257FFF004A543F ")

    def link6_function(event):
        webbrowser.open(r"Notes://mopndi09/C125700B00420464/C3792F13CEEE743AC1256FA90031AC03/EE819D3D0CFC4195C1257A540081EF9E ")

    def link7_function(event):
        webbrowser.open(r"Notes://D06DBL032/C12571DB0047F6E9/0E58CDC518E962F5C1256D13004213B3/671C9C64B41DB67D802583CC004DB172\ ")

    a = Label(master1,fg="blue", font=("Times",15) , text="HELP/INFO")
    a1 = Label(master1, font=(font_type), text="PECT is a checking tool created for Operators to scan Carrefour Pelicans.")
    a2 = Label(master1, font=(font_type), text="The application scans Pelicans in the specified status and reports everything as a text.")
    a3 = Label(master1, font=(font_type), text="All check are performed automatically.Every check can be performed manually by clicking the button.\n")
    b1 = Label(master1,fg="blue" , font=("Times", 15), text="BUTTON/AUTOMATIC CHECK EXPLANATION")
    b2 = Label(master1, font=(font_type), text="PELICANS=Scans all Pelicans for status AD167 & 9.Check is performed daily at 07:30.")
    link1 = Label(master1,font=(font_type_link), text="link to lotus notes\n", fg="blue", cursor="hand2")
    link1.bind("<Button-1>", link1_function)
    b3 = Label(master1, font=(font_type), text="PELCONTR-CT01=Scans pelican PELCONTR for status A & 9.Check is performed daily at 07:30,15:05 and 02:00.")
    link2 = Label(master1, font=(font_type_link), text="link to lotus notes\n", fg="blue", cursor="hand2")
    link2.bind("<Button-1>", link2_function)
    b4 = Label(master1, font=(font_type), text="BCPF=Scans pelican PELCCONTR for status 9.Check is performed daily at 16:15.")
    link3 = Label(master1, font=(font_type_link), text="link to lotus notes\n", fg="blue", cursor="hand2")
    link3.bind("<Button-1>", link3_function)
    b5 = Label(master1, font=(font_type), text="PELE1=Scans pelican PELE1 for status A,site UFPSOPB1,nom A300.Check is performed daily at 06:00,12:00 and 18:00.")
    link4 = Label(master1, font=(font_type_link), text="link to lotus notes\n", fg="blue", cursor="hand2")
    link4.bind("<Button-1>", link4_function)
    b6 = Label(master1, font=(font_type), text="PELCD-A7=Scans pelican PELCD for status A7,site CHAM*,nom SL53.Check is performed daily every 30' from 07:02 till 12:02.")
    link5 = Label(master1, font=(font_type_link), text="link to lotus notes\n", fg="blue", cursor="hand2")
    link5.bind("<Button-1>", link5_function)
    b7 = Label(master1, font=(font_type), text="PELIS-SL11=Scans pelican PELIS for status 94A and nom SL11.Check is performed every Sunday at 16:00.")
    link6 = Label(master1, font=(font_type_link), text="link to lotus notes\n", fg="blue", cursor="hand2")
    link6.bind("<Button-1>", link5_function)
    b8 = Label(master1, font=(font_type), text="PELEH=Manual button used to open new session and logon PELEH")
    b9 = Label(master1, font=(font_type), text="PELEG=Manual button used to open new session and logon PELEG\n")
    c = Label(master1,fg="blue" , font=("Times", 15), text="EXTRA")
    c1 = Label(master1, font=(font_type), text="PELICANS-ONLY-A=This is ONLY automatic check and,ONLY for status A in every Pelican.Check is performed every day at 08:30")
    c2 = Label(master1, font=("Times", 18, "bold"), fg="red", text="In case of any problems follow checklist in Lotus Notes", cursor="hand2")
    link7 = Label(master1, font=(font_type_link), text="Link to lotus notes\n", fg="blue", cursor="hand2")
    link7.bind("<Button-1>", link7_function)


    a.grid(row=0,column=1)
    a1.grid(row=1,column=1)
    a2.grid(row=2,column=1)
    a3.grid(row=3,column=1)
    b1.grid(row=4,column=1)
    b2.grid(row=5,column=1)
    link1.grid(row=6, column=1)
    b3.grid(row=7,column=1)
    link2.grid(row=8, column=1)
    b4.grid(row=9, column=1)
    link3.grid(row=10, column=1)
    b5.grid(row=11, column=1)
    link4.grid(row=12, column=1)
    b6.grid(row=13, column=1)
    link5.grid(row=14, column=1)
    b7.grid(row=15, column=1)
    link6.grid(row=16, column=1)
    b8.grid(row=17, column=1)
    b9.grid(row=18, column=1)
    c.grid(row=19,column=1)
    c1.grid(row=20, column=1)
    c2.grid(row=21, column=1)
    link7.grid(row=22, column=1)



    master1.mainloop()

def about_index():

    master2 = Tk()
    master2.title("About")

    a = Label(master2, font=("Helvetica", 15), text="PElican Checking Tool(PE.C.T) was developed by")
    a1 = Label(master2, fg="blue" , font=("Helvetica", 15), text="Athanasios Gkanis")
    a2 = Label(master2, text="")
    a3 = Label(master2, text="")
    a4 = Label(master2, font=("Helvetica", 15), text="Project was driven by")
    a5 = Label(master2, fg="blue", font=("Helvetica", 15), text="Jakub Matous")

    a.grid(row=0, column=1)
    a1.grid(row=1, column=1)
    a2.grid(row=2, column=1)
    a3.grid(row=3, column=1)
    a4.grid(row=4, column=1)
    a5.grid(row=5, column=1)

    master2.mainloop()



def variable_gui():
    master = Tk()
    master.geometry("350x150")
    def save_variables():
        #WithoutClass.name = name.get()
        #WithoutClass.password = password.get()
        f = open(cwd+"\WINDOWS\Variables.txt", "w+")
        f.write(name.get()+"\n")
        f.write(password.get())
        f.write("\n")
        f.write("\n")
        f.close()
        master.destroy()

    L1 = Label(master, text="User Name", font=("Helvetica", 15))
    L1.grid(row=0,column=0)
    name = Entry(master,width=15, font=("Helvetica", 15))
    name.grid(row=0,column=1)
    name.focus_set()

    L2 = Label(master, text="Password", font=("Helvetica", 15))
    L2.grid(row=3,column=0)
    password = Entry(master,width=15, show="*", font=("Helvetica", 15))
    password.grid(row=3,column=1)
    password.focus_set()

    b = Button(master, text="Save", width=10,font=("Helvetica", 15), command=save_variables)
    b.grid(row=4,column=1)

    file1 = open(cwd + "\WINDOWS\Variables.txt")
    line = file1.readlines()
    if line[0].strip():
        name.insert(0, line[0].strip())
    if line[1].strip():
        password.insert(0, line[1].strip())

    file1.close()

    master.mainloop()

def tox_gui():
    master = Tk()
    #master.geometry("350x150")
    def start_tox():
        #WithoutClass.name = name.get()
        #WithoutClass.password = password.get()
        with open(cwd+"\WINDOWS\TOX.txt", "w+") as f:
            f.write(tox_user.get()+"\n")
            f.write(tox_pass.get()+"\n")
        with open(cwd+"\WINDOWS\TOX.txt", "r") as f:
            content = f.readlines()
            content = [x.strip() for x in content]


    tox_user_lbl = Label(master, text="TOX_USER", font=("Helvetica", 15))
    tox_user_lbl.grid(row=0,column=0)
    tox_user = Entry(master,width=15, font=("Helvetica", 15))
    tox_user.grid(row=0,column=1)
    tox_user.focus_set()

    tox_pass_lbl = Label(master, text="TOX_PASS", font=("Helvetica", 15))
    tox_pass_lbl.grid(row=3,column=0)
    tox_pass = Entry(master,width=15, font=("Helvetica", 15))
    tox_pass.grid(row=3,column=1)
    tox_pass.focus_set()

    tox_start_btn = Button(master, text="START", width=10,font=("Helvetica", 15), command=start_tox)
    tox_start_btn.grid(row=4,column=0)

    tox_message_lbl = StringVar()
    Label(master,bg="red", font=("Helvetica", 15), textvariable=tox_message_lbl).grid(row=5, column=0, columnspan=2)
    tox_message_lbl.set("Tox messages will display here")

    #tox_message_lbl = Label(master, text="Tox messages will display here", font=("Helvetica", 15))
    #tox_message_lbl.grid(row=5,column=0,columnspan=2)

    try:
        with open(cwd+"\WINDOWS\TOX.txt", "r") as f:
            #lines = f.readlines()
            #content = [x.strip() for x in content]
            #line0 = re.sub("[^\x20-\x7E]", "", lines[0])
            #tox_user.insert(0, content[0].strip())
            #line1 = re.sub("[^\x20-\x7E]", "", lines[1])
            #tox_pass.insert(0, content[1].strip())
            line = f.readlines()
            if line[0].strip():
                tox_user.insert(0, line[0].strip())
            if line[1].strip():
                tox_pass.insert(0, line[1].strip())
    except:
        pass

    master.mainloop()


root = Tk()
root.title("PECT Windows")

menubar = Menu(root)
insidebar =Menu(menubar, tearoff=0)


insidebar.add_command(label='Credentials', command=variable_gui)
#insidebar.add_command(label='TOX', command=tox_gui)

menubar.add_cascade(label="Menu", menu=insidebar)
helpmenu = Menu(menubar, tearoff=0)
helpmenu.add_command(label="Help Index",command=help_index)
helpmenu.add_command(label="About....",command=about_index)
menubar.add_cascade(label="Help", menu=helpmenu)

#this label is for define an extra line of space between menu and main window
label = Label(root,bg="red", text="" )
label.grid(row=1, column=0, columnspan=42)

notebook = ttk.Notebook(root)
notebook.grid(row=2, column=0, columnspan=40, rowspan=40, sticky=E + W + S + N)

page1 = ttk.Frame(notebook)
notebook.add(page1, text='PELICANS')
text1 = Text(page1, wrap=WORD, font=("Arial", 11, "bold italic"))
text1.grid(row=2, column=0, columnspan=2, rowspan=4, padx=5)

page2 = ttk.Frame(notebook)
notebook.add(page2, text='PELCONTR-CT01')
text2 = Text(page2, wrap=WORD, font=("Arial", 11, "bold italic"))
text2.grid(row=2, column=0, columnspan=2, rowspan=4, padx=5)

page3 = ttk.Frame(notebook)
notebook.add(page3, text='BCPF')
text3 = Text(page3, wrap=WORD, font=("Arial", 11, "bold italic"))
text3.grid(row=2, column=0, columnspan=2, rowspan=4,
                  padx=5)


page4 = ttk.Frame(notebook)
notebook.add(page4, text='PELE1')
text4 = Text(page4, wrap=WORD, font=("Arial", 11, "bold italic"))
text4.grid(row=2, column=0, columnspan=2, rowspan=4,
                  padx=5)


page5 = ttk.Frame(notebook)
notebook.add(page5, text='PELCD-A7')
text5 = Text(page5, wrap=WORD, font=("Arial", 11, "bold italic"))
text5.grid(row=2, column=0, columnspan=2, rowspan=4,
                  padx=5)


page6 = ttk.Frame(notebook)
notebook.add(page6, text='PELIS-SL11')
text6 = Text(page6, wrap=WORD, font=("Arial", 11, "bold italic"))
text6.grid(row=2, column=0, columnspan=2, rowspan=4,
                  padx=5)


page7 = ttk.Frame(notebook)
notebook.add(page7, text='PELICANS_Only A')
text7 = Text(page7, wrap=WORD, font=("Arial", 11, "bold italic"))
text7.grid(row=2, column=0, columnspan=2, rowspan=4,
                  padx=5)

Btn1 = Button(root,bg="black",fg="white", text="PELICANS", command=check_at_07_30_session, height=4, width=13)
Btn1.grid(row=2, column=40)

Btn2 = Button(root,bg="black",fg="white", text="PELCONTR-CT01", command=PELCONTR_CT01_session, height=4,width=13)
Btn2.grid(row=3, column=40)

Btn3 = Button(root,bg="black",fg="white", text="BCPF",command=Pelican_BCPF_session, height=4, width=13)
Btn3.grid(row=4, column=40)

Btn4 = Button(root,bg="black",fg="white", text="PELE1",command=Pelican_PELE1_session, height=4, width=13)
Btn4.grid(row=5, column=40)

Btn5 = Button(root,bg="black",fg="white", text="PELCD-A7",command=Pelican_PELCD_A7_session, height=4, width=13)
Btn5.grid(row=6, column=40)

Btn6 = Button(root,bg="black",fg="white", text="PELIS-SL11",command=Pelican_PELIS_SL11_session, height=4, width=13)
Btn6.grid(row=7, column=40)

Btn7 = Button(root,bg="white",fg="black", text="PELEH",command=PELEH_session, height=4, width=13)
Btn7.grid(row=2, column=41)

Btn8 = Button(root,bg="white",fg="black", text="PELEG",command=PELEG_session, height=4, width=13)
Btn8.grid(row=3, column=41)

Btn9 = Button(root,bg="red",fg="black", text="SESSIONS",command=CRF_sessions, height=4, width=13)
Btn9.grid(row=4, column=41)

checks_label = Label(root,fg="red", text="", font=("Helvetica", 20))
checks_label.grid(row=45, column=0)

checks_label1 = Label(root,fg="blue", text="", font=("Helvetica", 20))
checks_label1.grid(row=46, column=0)

empty = Label(root,bg="red", text="")
empty.grid(row=42, column=0)
timeText = Label(root, text="", relief=GROOVE, font=("Helvetica", 20))
timeText.grid(row=43, column=0)
update_timeText()
empty = Label(root,bg="red", text="")
empty.grid(row=44, column=0)


v = StringVar()
Label(root,bg="red", font=("Helvetica", 15), textvariable=v).grid(row=43, column=30)

root.config(menu=menubar)
root.configure(background='#C0C0C0')
root.mainloop()

#The next lines inside the triple quote once enabled,
# will remove the file with the ID and PASS every time the user closes the program.
"""
output=os.path.isfile(cwd+"\PECT_WINDOWS\WINDOWS\Variables.txt")
if output:
    os.remove(cwd+"\PECT_WINDOWS\WINDOWS\Variables.txt")

"""
