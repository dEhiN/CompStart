# Dependency to store the helper functions that display a menu and require the user to make a choice

import sys
from tkinter import filedialog as file_chooser


def user_menu_chooser(menu_choices: list, allow_quit: bool = True, include_save: bool = False):
    """Helper function for displaying a menu with choices for the user

    This function is called by a few other functions that need to display a menu to the user for
    them to make a choice. The function creates a menu from the list passed in and then loops until
    the user makes a valid choice. This is then returned.

    Args:
        menu_choices (list): A list of strings that will be used to generate the menu. There will be no data validation, so if a list item isn't of type string, it will be ignored when generating the menu.

        allow_quit (bool, optional): Whether to show the option to quit the whole program in the current menu. Defaults to True.

        include_save (bool, optional): Whether to display a message reminding the user to save any changes prior to returning to the previous menu. Defaults to False.

    Returns:
        int: A number representing which choice the user made
    """
    # Create a copy of the menu_choices list
    local_menu_choices = menu_choices.copy()

    # Check if the option to quit the whole program should be added to the menu
    if allow_quit:
        quit_choice = len(local_menu_choices) + 1
        local_menu_choices.append("Quit the program")

    # Set the user choice as default to 0 meaning no valid choice was made
    user_choice = 0

    # Create full menu and count the total number of menu options
    total_menu_choices = len(local_menu_choices)
    full_menu = "Please choose one of the following:\n"

    # Check to see if the message about saving should be added to the menu
    if include_save:
        full_menu += "**Important: There is no autosave. Please save your changes before returning to the previous menu.**\n"

    # Cycle through the menu choices list and add build the menu
    choice_count = 1
    for menu_item in local_menu_choices:
        full_menu += f"[{choice_count}] " + menu_item + "\n"
        choice_count += 1

    print("\n" + full_menu)
    user_input = input("What would you like to do? ")

    if not user_input.isnumeric() or int(user_input) < 1 or int(user_input) > total_menu_choices:
        # User didn't choose a valid option
        print("\nThat choice is invalid!")
    else:
        # User chose a valid option, process accordingly
        user_choice = int(user_input)

        # Check if user chose to quit the program
        if allow_quit and user_choice == quit_choice:
            print("\nThank you for using CompStart. Have a wonderful day.")
            sys.exit()

    return user_choice


def new_file_chooser():
    """Helper function to have the user choose what type of new file to create

    This function will ask the user to choose whether to create a new startup file with default data or with values the user decides upon.

    Args:
        None

    Returns:
        tuple: Consisting of the following two Boolean variables:
                bool: True if the user wants to use the default startup data, False if not. Default is True.
                bool: True if the user wants to continue creating a startup data file, False if they want to return to the main menu. Default is True.
    """
    # Loop through until user makes a valid choice:
    # is_default will specify if the user wants to create a startup file with default values or not
    # create_file will specify if the user wants to proceed with creating a startup file or return to the main menu
    is_default = True
    create_file = True
    menu_choices = [
        "Create a new startup file using the defaults",
        "Create a new startup file with programs of your choice",
        "Skip creating a new startup file and return to the main menu",
    ]
    total_menu_choices = len(menu_choices)
    quit_loop = False

    while not quit_loop:
        # Ask user what type of new file they want
        user_choice = user_menu_chooser(menu_choices, False)

        if user_choice in range(1, total_menu_choices + 1):
            quit_loop = True
            if user_choice == 2:
                is_default = False
            elif user_choice == 3:
                create_file = False

    return (is_default, create_file)


def existing_file_chooser(item_name: str):
    """Helper function to show a file dialog box

    Args:
        item_name: The existing startup item name

    Returns:
        str: The full path of the file that was selected
    """
    # Using tkinter's askopenfilename function to get the file and path using a standard file dialog
    # window
    file_name = file_chooser.askopenfilename(
        initialdir="C:\\Program Files\\",
        title="Choose the program executable for {}".format(item_name),
    )

    # Converting Unix path separators
    win_file_name = file_name.replace("/", "\\")

    return win_file_name
