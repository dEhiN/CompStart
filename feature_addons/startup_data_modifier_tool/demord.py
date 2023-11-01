# This will be a command line tool to create and edit the
# startup_data.json file

import json, os
from dependencies.helper import *
from dependencies.chooser import *
from dependencies.pretty import *
from dependencies.data_generate import *
from dependencies.startup_add import *
from dependencies.startup_edit import *


def json_reader(json_path: list, json_filename: str):
    """Function to read in JSON data from a file

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if there is JSON data to return, False if not

        string: An error message to display if there's no JSON data to return
        or blank otherwise

        dict: The actual JSON data if there is any to return or an empty
        dictionary if not
    """

    # Create return values
    read_json_success = False
    return_message = "Startup data read in successfully!"
    json_data = {}

    # Split the filename into its components of name and extension
    split_filename = json_filename.split(".")

    # Validate if correct JSON file
    if len(split_filename) == 1:
        # The filename has no extension component
        return_message = "Please specify a valid startup file name"
    else:
        # Grab the extension
        last_item = split_filename[len(split_filename) - 1]

        # Check the extension is "json"
        if last_item != "json":
            return_message = (
                "Invalid startup file name.\n"
                f"Received extension of: .{last_item}\n"
                "Expected extension of: .json"
            )
        else:
            # Get the full path to the file in string format
            json_file = parse_full_path(json_path, json_filename)

            # Read in JSON data
            try:
                with open(json_file, "r") as json_file:
                    json_data = json.load(json_file)

                # Read was successful
                read_json_success = True
            except Exception as error:
                return_message = prettify_error(error, "r")

    return read_json_success, return_message, json_data


def json_writer(json_file: str, file_state: int, json_data: dict):
    """Function to write the actual JSON data to file

    Based on the value of the file_state variable, the file to be written is
    handled differently:

    0 - The file doesn't exist and mode "w" is to be used
    1 - The file exists but mode "w" is to be used so first need to confirm is
        user is alright with overwriting existing file
    2 - The file exists but the JSON data needs to be updated; see note below

    Note: Initially, the plan was to open the file in "append" mode when
    'file_state' is 2, but this doesn't work. Due to how the 'json.dump'
    function writes JSON data, it's not possible to just append newer JSON
    data to an existing file. As a result, existing startup JSON data will
    need to be read in, any modifications made - such as adding new startup
    data or editing existing startup data, and then written back to the file
    by overwriting what exists. However, this function will not be responsible
    for modifying any JSON data. This function will assume that 'json_data'
    contains the correct startup JSON data and if a 'file_state' of 2 is passed
    in, this function will overwrite the existing file data.

    Args:
        json_file (str): The full absolute path of the JSON file including
        filename and extension

        file_state (int): An indicator of how the file to be written should be
        handled. See extended summary above.

        json_data (dict): The JSON data to write to file. See note above.

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be
        written to disk or a message that it was written successfully
    """

    # Initialize return variables
    write_json_success = False
    return_message = "Startup file written successfully!"
    file_mode = ""

    # Check for valid file_state value
    match file_state:
        case 0:
            # Write JSON data to file
            file_mode = "w"
        case 1:
            # Check if user wants to overwrite the existing file
            if check_overwrite(json_file):
                # Write JSON data to file
                file_mode = "w"
            else:
                return_message = "Skipped writing startup file!"
        case 2:
            # Check to see if the current JSON data in the file is different
            # from json_data
            try:
                with open(json_file, "r") as file:
                    existing_data = json.load(file)
            except Exception as error:
                existing_data = json_data
                return_message = prettify_error(error, "r")

            if not json_data == existing_data:
                file_mode = "w"
            else:
                return_message = (
                    "Existing startup data and new startup data are the same. Not"
                    + f" updating {json_file} because there is no point."
                )
        case _:
            return_message = (
                "Invalid file state! Could not write startup data." " Please try again."
            )

    # Write to file if needed
    if not file_mode == "":
        try:
            with open(json_file, file_mode) as file:
                json.dump(json_data, file)

            # Created file successfully
            write_json_success = True
        except Exception as error:
            return_message = prettify_error(error, file_mode)

    return write_json_success, return_message


def json_creator(json_path: list, json_filename: str, default_mode: bool):
    """Function to create a new JSON file

    There are two possibilities here:

        1) The user wants to use the default startup data for creating a new file
        2) The user wants to specify the data themselves

    The third argument or parameter passed in will tell this function which is the case

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

        default_mode (bool): If True, create a new file with startup data. If False,
        allow the user to specify their own startup data.

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be
        written to disk or a message that it was written successfully
    """

    # Initialize variables
    write_json_success = False
    return_message = ""
    file_state = 0

    # Get the full path to the file in string format
    json_file = parse_full_path(json_path, json_filename)

    # Create default JSON data to add to the startup_data.json file
    json_data = generate_json_data(new_file=True, is_default=default_mode)

    # If the file exists, make sure we confirm from the user before overwriting
    # the file
    if os.path.isfile(json_file):
        file_state = 1

    # Write the file to disk and get the return values
    write_json_success, return_message = json_writer(json_file, file_state, json_data)

    return write_json_success, return_message


def json_editor(json_path: list, json_filename: str):
    """Function to allow the user to edit existing JSON data

    This function will display the existing JSON data and then allow the
    user to edit each startup item one at a time, including delete startup
    items and add new ones

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        ##TODO##
    """
    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = json_reader(json_path, json_filename)

    print(f"\n{status_message}")

    # If the data was read in successfully, display it when the user is ready
    if status_state:
        # Check to make sure there really are startup items in case TotalItems is
        # wrong
        if len(json_data["Items"]) > 0:
            # Get the total items
            total_items = json_data["TotalItems"]
            items = json_data["Items"]

            # Print out the total number of items
            print(f"\nNumber of startup items: {total_items}")

            # Loop through to allow the user to edit the JSON data until they are ready
            # to return to the main menu
            start_items_menu = ""
            for item_number in range(1, total_items + 1):
                start_items_menu += f"[{item_number}] Edit startup item {item_number}\n"

            item_add = total_items + 1
            item_delete = total_items + 2
            item_quit = total_items + 3
            total_menu_choices = item_quit

            menu_choices = (
                start_items_menu
                + f"[{item_add}] Add a new startup item\n"
                + f"[{item_delete}] Delete a startup item\n"
                + f"[{item_quit}] Return to the main menu\n"
            )

            quit_loop = False
            while not quit_loop:
                user_choice = user_menu_chooser(menu_choices, total_menu_choices)

                if user_choice == item_quit:
                    quit_loop = True
                elif user_choice == item_add:
                    print("\nThat functionality hasn't yet been implemented!")
                elif user_choice == item_delete:
                    print("\nThat functionality hasn't yet been implemented")
                elif user_choice > 0:
                    edit_startup_item(items[user_choice - 1], json_path, json_filename)
        else:
            print("There are no startup items to edit!")


if __name__ == "__main__":
    # Set the starting directory
    set_start_dir()

    # Variable to switch between testing and prod environments
    is_prod = False

    # Variables for location and name of JSON file with startup data
    json_path = []
    json_filename = ""

    if is_prod:
        json_path.extend(["data", "json_data"])
        json_filename = "startup_data.json"
    else:
        json_path.extend(
            ["feature_addons", "startup_data_modifier_tool", "dependencies"]
        )
        json_filename = "test_data.json"

    # Print welcome message
    print(
        "\nWelcome to Demord: The computer startup tool that will make your"
        " life easier."
    )

    # Initialize status variables
    status_state = False
    status_message = "No action taken..."

    # Main loop to allow user to navigate program options
    menu_choices = (
        "[1] What is Demord?\n"
        "[2] Create a new startup file\n"
        "[3] View the existing startup file\n"
        "[4] Edit the existing startup file\n"
    )
    total_menu_choices = 4
    quit_loop = False

    while not quit_loop:
        user_choice = user_menu_chooser(menu_choices, total_menu_choices)

        match user_choice:
            case 1:
                program_info()
            case 2:
                # Find out which type of new file the user wants
                is_default = new_file_chooser()

                # Create a new JSON file
                status_state, status_message = json_creator(
                    json_path, json_filename, is_default
                )
                print(f"\n{status_message}")
            case 3:
                # Read in existing JSON file and store the return results of the
                # json_read function, then print out if the read was successful
                status_state, status_message, json_data = json_reader(
                    json_path, json_filename
                )
                print(f"\n{status_message}\n")

                # If there was data read in, print it out in a prettified way
                if status_state:
                    input("Press any key to view the startup data...")
                    print(prettify_json(json_data))
                    input("\nPress any key to return to the main menu...")
            case 4:
                json_editor(json_path, json_filename)
