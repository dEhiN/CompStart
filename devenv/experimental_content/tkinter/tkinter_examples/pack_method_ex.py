# This geometry manager organizes widgets in blocks before placing them in the parent widget.
#
# Syntax:
# widget.pack(pack_options)
#
# Here is the list of possible options:
# expand − When set to true, widget expands to fill any space not otherwise used in widget's parent
# fill − Determines whether widget fills any extra space allocated to it by the packer, or keeps its own minimal dimensions:
#        NONE (default), X (fill only horizontally), Y (fill only vertically), or BOTH (fill both horizontally and vertically)
# side − Determines which side of the parent widget packs against:
#        TOP (default), BOTTOM, LEFT, or RIGHT

from tkinter import *

root = Tk()

top_frame = Frame(root)
top_frame.pack()

bottom_frame = Frame(root)
bottom_frame.pack(side=BOTTOM)

red_button = Button(top_frame, text="Red", fg="red")
red_button.pack(side=LEFT)

green_button = Button(top_frame, text="Green", fg="green")
green_button.pack(side=LEFT)

blue_button = Button(top_frame, text="Blue", fg="blue")
blue_button.pack(side=LEFT)

black_button = Button(bottom_frame, text="Black", fg="black")
black_button.pack(side=BOTTOM)

root.mainloop()
