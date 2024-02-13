# Dependency to store the helper functions that display a menu
# and require the user to make a choice

import sys
from tkinter import filedialog as file_chooser


def user_menu_chooser(menu_choices: str, total_menu_choices: int):
    """Helper function for displaying a menu with choices for the user

    This function is called by a few other functions that need to display a menu to the
    user for them to make a choice. The function prints the menu choice string passed
    in and then loops until the user makes a valid choice. This is then returned.

    Args:
        menu_choices (str): A formatted string of how the choices should be
        displayed
        total_menu_choices (int): The maximum number of choices there are

    Returns:
        int: A number representing which choice the user made
    """
    # Set the user choice as default to 0 meaning no valid choice was made
    user_choice = 0

    # Create option to quit the whole program and add it to the end of the passed
    # in menu
    total_menu_choices += 1
    quit_choice = total_menu_choices

    # Create menu header and footers
    menu_header = "Please choose one of the following:\n"
    menu_footer = f"[{quit_choice}] Quit the program\n"
    menu_choices = menu_header + menu_choices + menu_footer

    print("\n" + menu_choices)
    user_input = input("What would you like to do? ")

    if (
        not user_input.isnumeric()
        or int(user_input) < 1
        or int(user_input) > total_menu_choices
    ):
        # User didn't choose a valid option
        print("\nThat choice is invalid!")
    else:
        # User chose a valid option, process accordingly
        user_choice = int(user_input)

        # Check if user chose to quit the program
        if user_choice == quit_choice:
            print("\nThank you for using Demord. Have a wonderful day.")
            sys.exit()

    return user_choice


def new_file_chooser():
    """Helper function to have the user choose what type of new file to create

    This function will ask the user to choose whether to create a new startup file with
    default data or with values the user decides upon.

    Args:
        None

    Returns:
        tuple: Consisting of the following two Boolean variables:
                bool: True if the startup file should contain default data,
                False if not. Default is False.
                bool: True if the user wants to continue without creating a startup
                file, False if not. Default is True.
    """
    # Loop through until user makes a valid choice:
    # is_default will specify if the user wants to create a startup file with default
    # values or not
    # to_continue will specify if the user wants to return to the main menu or proceed
    # with creating a startup file
    is_default = False
    to_continue = True
    menu_choices = (
        "[1] Create a new startup file with some default values\n"
        "[2] Create a new startup file with programs that you choose\n"
        "[3] Return to the main menu\n"
    )
    total_menu_choices = 3
    quit_loop = False

    while not quit_loop:
        # Ask user what type of new file they want
        user_choice = user_menu_chooser(menu_choices, total_menu_choices)

        if user_choice in range(1, total_menu_choices + 1):
            quit_loop = True
            if user_choice == 1:
                is_default = True
            elif user_choice == 3:
                to_continue = False

    return (is_default, to_continue)


def edit_file_chooser(item_name: str):
    """Helper function to show a file dialog box

    Args:
        item_name: The existing startup item name

    Returns:
        str: The full path of the file that was selected
    """
    file_name = file_chooser.askopenfilename(
        initialdir="C:/Program Files/",
        title="Choose the program executable for {}".format(item_name),
    )
    return file_name
