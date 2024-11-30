# Dependency to store the main JSON related functions used by CompStart

import json, os, copy

import dependencies.cs_helper as deps_helper
import dependencies.cs_chooser as deps_chooser
import dependencies.cs_pretty as deps_pretty
import dependencies.cs_data_generate as deps_data_gen
import dependencies.cs_startup_edit as deps_item_edit
import dependencies.cs_startup_add as deps_item_add
import dependencies.cs_enum as deps_enum

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_ITV = deps_enum.ItemTypeVals


def json_reader(json_path: list, json_filename: str, is_json_schema: bool = False):
    """Function to read in JSON data from a file

    Args:
        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

        is_json_schema (bool): A variable specifying if the JSON file that will be read is going to be one of the JSON schema files. This was added because in order to confirm that read in JSON startup data is valid, the function json_data_validator from the helper module is called. However, that function then calls this function, which creates a loop. This variable will be used specifically to avoid that situation. The default is False, so most existing calls to this function will still work. The call in the json_data_validator function will pass in a value of True for this variable.

    Returns:
        bool: True if there is JSON data to return, False if not

        string: An error message to display if there's no JSON data to return or blank otherwise

        dict: The actual JSON data if there is any to return or an empty dictionary if not
    """

    # Initialize function variables
    read_json_success = False
    return_message = ""
    json_data = {}
    required_ext = ".json"

    # Grab the file extension
    file_ext = os.path.splitext(json_filename)[1]

    # Validate if filename passed in is a JSON file
    if not file_ext:
        # The filename has no extension
        return_message = "Argument 'json_filename' is not a valid file as it has no extension"
    else:
        # Check the extension is "json"
        if not file_ext == required_ext:
            return_message = (
                "Invalid startup file name.\n"
                f"Received extension of: {file_ext}\n"
                f"Expected extension of: {required_ext}"
            )
        else:
            # Get the full path to the file in string format
            json_file = deps_helper.parse_full_path(json_path, json_filename)

            # Read in JSON data
            try:
                with open(json_file, "r") as json_file:
                    json_data = json.load(json_file)

                # Check to see if the JSON data file is blank
                if len(json_data) == 0:
                    return_message = "JSON data is blank"
                # Check to see if the JSON data is valid (ex., no blank JSON object)
                elif not is_json_schema and not deps_helper.json_data_validator(json_data):
                    return_message = "Validation failed while reading in JSON data"
                # Read was successful
                else:
                    read_json_success = True
                    return_message = "Startup data read in successfully"
            except Exception as error:
                return_message = deps_pretty.prettify_io_error(error, "r")

    # If there were any errors or exceptions, print them out
    if not read_json_success:
        deps_pretty.prettify_custom_error(return_message, "json_reader")

    return read_json_success, return_message, json_data


def json_writer(json_file: str, file_state: int, json_data: dict):
    """Function to write the actual JSON data to file

    Based on the value of the file_state variable, the file to be written is handled differently:

    0 - The file doesn't exist and mode "w" is to be used
    1 - The file exists but mode "w" is to be used so first need to confirm is
        user is alright with overwriting existing file
    2 - The file exists but the JSON data needs to be updated; see note below

    Note: Initially, the plan was to open the file in "append" mode when 'file_state' is 2, but this doesn't work. Due to how the 'json.dump' function writes JSON data, it's not possible to just append newer JSON data to an existing file. As a result, existing startup JSON data will
    need to be read in, any modifications made - such as adding new startup data or editing existing startup data, and then written back to the file by overwriting what exists. However, this function will not be responsible for modifying any JSON data. This function will assume that 'json_data'
    contains the correct startup JSON data and if a 'file_state' of 2 is passed in, this function will overwrite the existing file data.

    Args:
        json_file (str): The full absolute path of the JSON file including filename and extension

        file_state (int): An indicator of how the file to be written should be handled. See extended summary above.

        json_data (dict): The JSON data to write to file. See note above.

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be written to disk or a message that it was written successfully
    """

    # Initialize function variables
    write_json_success = False
    return_message = ""
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
                return_message = "Skipped writing startup file"
        case 2:
            # Check to see if the current JSON data in the file is different from json_data
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
                    + f" updating {json_file} because there are no changes."
                )
        case _:
            return_message = "Invalid file state. Could not write startup data."

    # Write to file if needed
    if not file_mode == "":
        try:
            with open(json_file, file_mode) as file:
                json.dump(json_data, file)

            # Created file successfully
            write_json_success = True
            return_message = "Startup file written successfully!"
        except Exception as error:
            return_message = deps_pretty.prettify_io_error(error, file_mode)

    # If there were any errors or exceptions, print them out unless there's a return message that's not an Exception
    if not write_json_success and not file_mode == "":
        deps_pretty.prettify_custom_error(return_message, "json_writer")

    return write_json_success, return_message


def json_creator(json_path: list, json_filename: str, default_mode: bool):
    """Function to create a new startup data JSON file

    There are two possibilities here:

        1) The user wants to use the default startup data for creating a new file
        2) The user wants to specify the data themselves

    The third argument or parameter passed in will tell this function which is the case

    Args:
        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

        default_mode (bool): If True, create a new file with default startup data. If False, allow
        the user to specify their own startup data.

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be written to disk or a
        message that it was written successfully
    """

    # Initialize function variables
    write_json_success = False
    exists_data = False
    return_message = ""
    file_state = 0

    # Get the full path to the file in string format
    json_file = deps_helper.parse_full_path(json_path, json_filename)

    # Create startup JSON data to add to the startup_data.json file
    exists_data, json_data = deps_data_gen.generate_new_json_data(is_default=default_mode)

    # Check to see if any data was actually generated
    if exists_data:
        # If the file exists, make sure we will confirm from the user before overwriting the file
        if os.path.isfile(json_file):
            file_state = 1

        # If the user chose to add their own startup programs, alert the user that a blank startup file is being created
        if not default_mode:
            print("\nCreating blank startup file...")

        # Write the file to disk and get the return values
        write_json_success, return_message = json_writer(json_file, file_state, json_data)

        # If the user chose to add their own startup programs
        if not default_mode:
            # Call the function to handle adding the startup items
            write_json_success, return_message = json_adder(json_path, json_filename)

            # If there was a problem adding the startup items, let the user know and return back to the main menu
            if not write_json_success:
                deps_pretty.prettify_custom_error(
                    "Could not add any startup items. Only a blank startup file was created.",
                    "json_creator",
                )

                return write_json_success, return_message
    else:
        # There's no data to use, so let the user know
        deps_pretty.prettify_custom_error(
            "Could not create a new startup data JSON file",
            "json_creator",
        )

    return write_json_success, return_message


def json_editor(json_path: list, json_filename: str):
    """Function to allow the user to edit existing JSON data

    This function will display the existing JSON data and then allow the user to edit or delete startup items

    Args:
        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the edit operations were successful, False if there were any issues encountered

        string: An error message to display if the boolean return variable is False, blank otherwise
    """

    # Initialize function variables
    # Assume status of edit operations was successful as default status
    status_state = True
    status_message = ""

    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = json_reader(json_path, json_filename)

    # If the data was read in successfully, continue
    if status_state:
        # Let user know the data was read in successfully
        print(f"\n{status_message}")

        # Check to make sure there really are startup items in case TotalItems is wrong
        if len(json_data[ENUM_JSK.ITEMS.value]) > 0:
            # Initialize the loop variables
            total_items = 0
            items = []
            new_menu = True
            quit_loop = False

            # Loop through to allow the user to edit the JSON data until they are ready to return
            # to the main menu
            while not quit_loop:
                # Generate the menu from scratch because if it's the first time the menu is being
                # displayed or the menu has changed
                if new_menu:
                    # Make sure the menu is regenerated only when necessary
                    new_menu = False

                    # Get the total items
                    total_items = json_data[ENUM_JSK.TOTALITEMS.value]
                    items = json_data[ENUM_JSK.ITEMS.value]

                    # Print out the total number of items
                    print(f"\nNumber of startup items: {total_items}")

                    # Create the actual menu
                    menu_choices = []

                    for item_number in range(1, total_items + 1):
                        menu_choices.append(f"Edit startup item {item_number}")

                    menu_choices.extend(
                        [
                            "Delete an existing startup item",
                            "Save full startup data to disk",
                            "Return to the main menu",
                        ]
                    )

                    # Store the values necessary to determine each choice the user could make
                    menu_delete = total_items + 1
                    menu_save = total_items + 2
                    menu_quit = total_items + 3

                # Ask the user what they want to do
                user_choice = deps_chooser.user_menu_chooser(menu_choices)

                if user_choice == menu_quit:
                    # User chose to return to the main menu
                    quit_loop = True
                elif user_choice == menu_delete:
                    # First check to see if there are any items to delete
                    if total_items > 0:
                        # User chose to delete an existing startup item
                        new_menu = True

                        question_prompt = (
                            "\nPlease enter the startup item number you want to remove"
                        )
                        if total_items == 1:
                            question_prompt += " [1]: "
                        else:
                            question_prompt += f" [1-{total_items}]: "
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

                            json_data = json_pruner(json_data, user_item_choice)
                    else:
                        status_message = (
                            "There are no items to delete! Please add a new startup item first..."
                        )
                        status_state = False
                        quit_loop = True
                elif user_choice == menu_save:
                    # User chose to save the current JSON data
                    status_state, status_message = json_saver(json_data, json_path, json_filename)
                elif user_choice > 0:
                    # User chose to edit a specific startup item
                    items[user_choice - 1] = deps_item_edit.edit_startup_item(
                        items[user_choice - 1], json_path, json_filename
                    )
        else:
            status_message = "There are no startup items to edit!"
            status_state = False
    else:
        status_message = "Could not read in the startup data to edit"

    if not status_state:
        deps_pretty.prettify_custom_error(status_message, "json_editor")

    return status_state, status_message


def json_saver(json_data: dict, json_path: list, json_filename: str):
    """Function to allow the user to save startup data

    This function takes in startup data in the form of a JSON object / Python dictionary. After calling the generate_user_edited_data function to basically validate it, json_writer will be called to save the actual data.

    Args:
        json_data (dict): A dictionary containing the JSON startup data to save to disk.

        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be written to disk or a message that it was written successfully
    """
    # Call the generate_user_edited_data function for scenario 4
    new_json_data = deps_data_gen.generate_user_edited_data(
        copy.deepcopy(json_data), ENUM_ITV.FULL.value
    )

    # Grab the full file path and name
    data_file = deps_helper.parse_full_path(json_path, json_filename)

    # Save the actual data
    status_state, status_message = json_writer(data_file, 2, new_json_data)

    return (status_state, status_message)


def json_pruner(curr_json_data: dict, item_number: int):
    """Function to remove a whole startup item from existing startup data

    This function will remove the item and update the startup data as necessary

    Args:
        curr_json_data (dict): The existing full startup data

        item_number (int): The number of the startup item to delete

    Returns:
        dict: A dictionary containing the updated startup data
    """
    temp_json_data = copy.deepcopy(curr_json_data)
    prune_item = temp_json_data[ENUM_JSK.ITEMS.value][item_number - 1]

    updated_json_data = deps_data_gen.generate_user_edited_data(
        prune_item, ENUM_ITV.DELETE.value, temp_json_data
    )

    print("\nStartup item {} was successfully deleted".format(item_number))

    return updated_json_data


def json_adder(json_path: list, json_filename: str):
    """Function to add one or more startup items to the existing startup file

    This function will allow the user to choose how many startup items they want to add, and then loop through so they can add each item one by one

    Args:
    json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

    json_filename (str): The filename of the JSON file

    Returns:
        bool: True if adding startup items was successful, False if there were any issues encountered

        string: An error message to display if the boolean return variable is False, blank otherwise
    """

    # Initialize function variables
    status_state = True
    status_message = ""

    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = json_reader(json_path, json_filename)

    # Ask user how many startup items they want to add and loop until the user enters a valid integer
    while True:
        try:
            num_startup_items = int(input("\nHow many startup items would you like to add? "))
        except ValueError:
            print("Please enter a valid number...")
            continue
        else:
            break

    # If the user entered 0 or a negative number
    if num_startup_items < 1:
        # Print out an error message
        status_message = "The number of startup items chosen to add is invalid. Cannot add {} startup items.".format(
            num_startup_items
        )
        status_state = False
    else:
        # Loop through and get each startup item from the user
        for item in range(num_startup_items):
            startup_item = deps_item_add.add_startup_item()

    if not status_state:
        deps_pretty.prettify_custom_error(status_message, "json_adder")

    return status_state, status_message
