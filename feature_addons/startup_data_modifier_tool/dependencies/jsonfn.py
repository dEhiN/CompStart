# Dependency to store the main JSON related functions used by Demord

import json, os, copy

import dependencies.helper as deps_helper
import dependencies.chooser as deps_chooser
import dependencies.pretty as deps_pretty
import dependencies.data_generate as deps_data_gen
import dependencies.startup_edit as deps_start_edit


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
            json_file = deps_helper.parse_full_path(json_path, json_filename)

            # Read in JSON data
            try:
                with open(json_file, "r") as json_file:
                    json_data = json.load(json_file)

                # Read was successful
                read_json_success = True
            except Exception as error:
                return_message = deps_pretty.prettify_io_error(error, "r")

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
            if deps_helper.check_overwrite(json_file):
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
                return_message = deps_pretty.prettify_io_error(error, "r")

            if not json_data == existing_data:
                file_mode = "w"
            else:
                return_message = (
                    "Existing startup data and new startup data are the same. Not"
                    + f" updating {json_file} because there is no point."
                )
        case _:
            return_message = (
                "Invalid file state! Could not write startup data."
                " Please try again."
            )

    # Write to file if needed
    if not file_mode == "":
        try:
            with open(json_file, file_mode) as file:
                json.dump(json_data, file)

            # Created file successfully
            write_json_success = True
        except Exception as error:
            return_message = deps_pretty.prettify_io_error(error, file_mode)

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
    json_file = deps_helper.parse_full_path(json_path, json_filename)

    # Create default JSON data to add to the startup_data.json file
    json_data = deps_data_gen.generate_json_data(
        new_file=True, is_default=default_mode
    )

    # If the file exists, make sure we confirm from the user before overwriting
    # the file
    if os.path.isfile(json_file):
        file_state = 1

    # Write the file to disk and get the return values
    write_json_success, return_message = json_writer(
        json_file, file_state, json_data
    )

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
    status_state, status_message, json_data = json_reader(
        json_path, json_filename
    )

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
                start_items_menu += (
                    f"[{item_number}] Edit startup item {item_number}\n"
                )

            item_add = total_items + 1
            item_delete = total_items + 2
            data_save = total_items + 3
            item_quit = total_items + 4
            total_menu_choices = item_quit

            menu_choices = (
                start_items_menu
                + f"[{item_add}] Add a new startup item\n"
                + f"[{item_delete}] Delete an existing startup item\n"
                + f"[{data_save}] Save the current startup data\n"
                + f"[{item_quit}] Return to the main menu\n"
            )

            quit_loop = False
            while not quit_loop:
                user_choice = deps_chooser.user_menu_chooser(
                    menu_choices, total_menu_choices
                )

                if user_choice == item_quit:
                    quit_loop = True
                elif user_choice == item_add:
                    print("\nThat functionality hasn't yet been implemented!")
                elif user_choice == item_delete:
                    question_prompt = "\nPlease enter the startup item number you want to remove"
                    if total_items == 1:
                        question_prompt += " [1]: "
                    else:
                        question_prompt += f" [1-{total_items}]: "

                    user_item_choice = ""
                    user_input = input(question_prompt)

                    if (
                        not user_input.isnumeric()
                        or int(user_input) < 1
                        or int(user_input) > total_items
                    ):
                        # User didn't choose a valid option
                        print("\nThat choice is invalid!")
                    else:
                        # User chose a valid option, process accordingly
                        user_item_choice = int(user_input)

                        json_pruner(
                            copy.deepcopy(items), user_item_choice, total_items
                        )
                elif user_choice == data_save:
                    status_state, status_message = json_saver(
                        json_data, json_path, json_filename
                    )

                    if not status_state:
                        print(status_message)
                elif user_choice > 0:
                    deps_start_edit.edit_startup_item(
                        items[user_choice - 1], json_path, json_filename
                    )
        else:
            print("There are no startup items to edit!")


def json_saver(json_data: dict, json_path: list, json_filename: str):
    """Function to allow the user to save startup data

    This function takes in startup data in the form of a JSON object / Python
    dictionary. After calling the generate_user_edited_data function to
    basically validate it, json_writer will be called to save the actual data.

    Args:
        json_data (dict): A dictionary containing the JSON startup data to save
        to disk.

        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be
        written to disk or a message that it was written successfully
    """
    # Call the generate_user_edited_data function for scenario 2
    new_json_data = deps_data_gen.generate_user_edited_data(
        copy.deepcopy(json_data), False
    )

    # Grab the full file path and name
    data_file = deps_helper.parse_full_path(json_path, json_filename)

    # Save the actual data
    status_state, status_message = json_writer(data_file, 2, new_json_data)

    return (status_state, status_message)


def json_pruner(items_data: list, item_number: int, total_items: int):
    """Function to remove a whole startup item from existing startup data

    This function will remove the item and update the startup data as necessary

    Args:
        items_data (dict): The existing startup data but only as the Items
        array

        item_number (int): The number of the startup item to delete

        total_items (int): The total number of startup items. While this can be
        pulled from json_data, to make the code simpler, any calling function
        must pass in this value.
    """
    prune_item = items_data[item_number - 1]
    items_data.remove(prune_item)
    print(f"{item_number} out of {total_items}:")
    print(prune_item)
    print(items_data)
