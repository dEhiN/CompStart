# This is an example demonstrating the use of TKinter dialog boxes. The code for program one was taken from https://datatofish.com/executable-pyinstaller/. The code for program two was taken from the tooltip that shows when hovering over the tkinter module name in VS Code. Both programs were added to this one file and the code was extended to show two different options for what is displayed in the dialog box via program one or two.

import tkinter
from tkinter.constants import RIDGE, BOTH, BOTTOM, X

tk = tkinter.Tk()


def program_one():
    canvas = tkinter.Canvas(tk, width=300, height=300)
    canvas.pack()

    def program_one_hello():
        label = tkinter.Label(
            tk, text="Hello World!", fg="blue", font=("helvetica", 12, "bold")
        )
        canvas.create_window(150, 200, window=label)

    button1 = tkinter.Button(
        text="Click Me", command=program_one_hello, bg="brown", fg="white"
    )
    canvas.create_window(150, 150, window=button1)

    tk.mainloop()


def program_two():
    frame = tkinter.Frame(tk, relief=RIDGE, borderwidth=2)
    frame.pack(fill=BOTH, expand=1)

    label = tkinter.Label(frame, text="Hello, World")
    label.pack(fill=X, expand=1)

    button = tkinter.Button(frame, text="Exit", command=tk.quit)
    button.pack(side=BOTTOM)

    tk.mainloop()


program_number = input("Do you want to run program 1 or program 2 (1/2)")
if program_number == "1":
    program_one()
elif program_number == "2":
    program_two()
else:
    print("Please run this again and enter only the numbers 1 or 2. Goodbye!")
