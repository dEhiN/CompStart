# This will be a command line tool to create and edit the startup_data.json
# file.

import json
import os

# When running this Python file directly, comment out the lines that use the
# full "from package.module.submodule ..." phrasing and uncomment the lines
# that use the simpler "from submodule ..." phrasing. Conversely, when running
# the command "python -m unittest" to test this Python file, comment out the
# simper lines and uncomment the full lines. This is necessary because test.py
# is located in a different folder/module so when running the test, the full
# package.module phrasing needs to be used. When running this Python file
# directly, that's not necessary.

from enum_classes import JsonSchemaKeys as ec_jsk
from enum_classes import JsonSchemaStructure as ec_jss

# from startup_data_modifier_tool.program_files.enum_classes import (
#     JsonSchemaKeys as ec_jsk,
# )
# from startup_data_modifier_tool.program_files.enum_classes import (
#     JsonSchemaStructure as ec_jss,
# )


# An example of valid startup_data.json data to use while coding
EXAMPLE_JSON = {
    "TotalItems": 1,
    "Items": [
        {
            "ItemNumber": 1,
            "Name": "Notepad",
            "FilePath": "notepad",
            "Description": "A text editor",
            "Browser": False,
            "ArgumentCount": 0,
            "ArgumentList": [],
        }
    ],
}


def parse_full_path(json_path: list, json_filename: str):
    """Helper function to parse the path components to a JSON file

    Args:
        json_path (list): A list containing the relative or absolute path to
            the JSON file with each list item representing one subfolder from
            Current Working Directory (CWD)
        json_filename (str): The filename of the JSON file

    Returns:
        string: The full absolute path with filename of the JSON file
    """

    # Get the full path to the JSON file
    full_path = os.getcwd()
    for item in json_path:
        full_path += os.sep + os.path.join(item)

    # Add the full path and JSON filename together
    json_file = full_path + os.sep + json_filename

    return json_file


def check_overwrite(json_file: str):
    """Check to see if user is ok to overwrite existing file

    Args:
        json_file (str): The file that will be overwritten

    Returns:
        bool: True if user would like to overwrite the existing file, False
            otherwise
    """

    # Loop until user gives a valid response
    quit_loop = False
    overwrite_file = False

    exists_message = f"\n{json_file} already exists!"
    input_message = "Would you like to completely overwrite this file [Y/N]? "
    while not quit_loop:
        # Get user input and validate it
        print(exists_message)
        user_choice = input(input_message)

        if user_choice.upper() == "Y" or user_choice.upper() == "N":
            if user_choice.upper() == "Y":
                overwrite_file = True

            quit_loop = True

    return overwrite_file


def generate_json(**kwargs):
    """Function to create JSON data from **kwargs parameter

    Args:
        **kwargs: Optional parameters that contain new JSON data

    Returns:
        dict: The same dictionary passed in but now filled with JSON data
    """

    # For now return a blank dictionary
    return []


def generate_default():
    """Function to create default startup data

    The default startup data opens notepad and contains what's in EXAMPLE_JSON.

    Returns:
        dict: A dictionary of JSON startup data
    """

    # Create empty JSON object / Python dictionary
    json_data = ec_jss.OBJECT.value.copy()

    """
    Populate the dictionary with the keys and values specified in the 
    docstring. Use the Enum class JsonSchemaKey through the variable ec_jsk to 
    populate the keys. Use the Enum class JsonSchemaStructure through the 
    variable ec_jss to create a Python dictionary for a JSON object and a 
    Python list for a JSON array when called for. Because of how Python passes 
    mutable data types, when using the ec_jss members, a copy has to be made of
    the member value. Additionally, in order to make the code easier to read 
    and follow, the variables json_arr and json_items are used as reference 
    aliases.
    """
    json_data[ec_jsk.TOTALITEMS.value] = 1
    json_data[ec_jsk.ITEMS.value] = ec_jss.ARRAY.value.copy()
    json_arr = json_data[ec_jsk.ITEMS.value]
    json_arr.append(ec_jss.OBJECT.value.copy())
    json_items = json_arr[0]
    json_items[ec_jsk.ITEMNUMBER.value] = 1
    json_items[ec_jsk.NAME.value] = "Notepad"
    json_items[ec_jsk.FILEPATH.value] = "notepad"
    json_items[ec_jsk.DESCRIPTION.value] = "A text editor"
    json_items[ec_jsk.BROWSER.value] = False
    json_items[ec_jsk.ARGUMENTCOUNT.value] = 0
    json_items[ec_jsk.ARGUMENTLIST.value] = ec_jss.ARRAY.value.copy()

    return json_data


def create_json_data(default: bool, **kwargs):
    """Function to create JSON data

    Depending on the parameters passed in, the function will either create
    default startup data and create a new startup_data.json file with the
    default data, or will update an existing startup_data.json file with
    JSON data that's passed in.

    Args:
        default (bool): Tells this function whether to generate default startup
        data for a new startup_data.json file or not; is mandatory

        **kwargs: Optional parameters that can contain JSON data to update an
        existing startup_data.json file; can be in any format

    Returns:
        dict: The actual JSON data if there is any to return or an empty
            dictionary if not
    """

    # If need to create default JSON data
    if default:
        json_data = generate_default()
    else:
        json_data = generate_json(**kwargs)

    return json_data


def json_writer(json_file: str, file_state: int, json_data: dict):
    """Function to write the actual JSON data to file

    Based on the value of the file_state variable, the file to be written is
    handled differently:

    0 - The file doesn't exist and mode "w" is to be used
    1 - The file exists but mode "w" is to be used so first need to confirm is
        user is alright with overwriting existing file
    2 - The file exists but mode "a" is to be used to append data

    Args:
        json_file (str): The full absolute path of the JSON file including
            filename and extension
        file_state (int): An indicator of how the file to be written should be
            handled. See extended summary above.
        json_data (dict): The JSON data to write to file

    Returns:
        bool: True if the JSON data was written successfully, False if not
        string: An error message to display if the JSON data couldn't be
            written to disk or blank otherwise
    """

    # Initialize return variables
    write_json_success = False
    return_message = "JSON file written successfully!"
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
                return_message = "Skipped writing JSON file!"
        case 2:
            # Append JSON data to file
            file_mode = "a"
        case _:
            return_message = (
                "Invalid file state! Could not write JSON data. Please try again."
            )

    # Write to file if needed
    if not file_mode == "":
        try:
            with open(json_file, file_mode) as file:
                json.dump(json_data, file)

            # Created file successfully
            write_json_success = True
        except Exception as error:
            return_message = (
                "Unable to write JSON data. Error information is below:\n"
                + str(type(error).__name__)
                + " - "
                + str(error)
            )

    return write_json_success, return_message


def json_creator(json_path: list, json_filename: str):
    """Function to create new JSON file with default startup data

    Args:
        json_path (list): A list containing the relative or absolute path to
            the JSON file with each list item representing one subfolder from
            Current Working Directory (CWD)
        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the JSON data was written successfully, False if not
        string: An error message to display if the JSON data couldn't be
            written to disk or blank otherwise
    """

    # Initialize variables
    write_json_success = False
    return_message = ""
    file_state = 0

    # Get the full path to the file in string format
    json_file = parse_full_path(json_path, json_filename)

    # Create default JSON data to add to the startup_data.json file
    json_data = dict(create_json_data(default=True))

    # If the file exists, make sure we confirm from the user before overwriting
    # the file
    if os.path.isfile(json_file):
        file_state = 1

    # Write the file to disk and get the return values
    write_json_success, return_message = json_writer(json_file, file_state, json_data)

    return write_json_success, return_message


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
    return_message = "JSON data read in successfully!"
    json_data = {}

    # Split the filename into its components of name and extension
    split_filename = json_filename.split(".")

    # Validate if correct JSON file
    if len(split_filename) == 1:
        # The filename has no extension component
        return_message = "Please specify a valid JSON file name"
    else:
        # Grab the extension
        last_item = split_filename[len(split_filename) - 1]

        # Check the extension is "json"
        if last_item != "json":
            return_message = (
                "Invalid JSON file name.\n"
                f"Received extension of: {last_item}\n"
                "Expected extension of: json"
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
                return_message = (
                    "Unable to read JSON data. Error information is below:\n"
                    + str(type(error).__name__)
                    + " - "
                    + str(error)
                )

    return read_json_success, return_message, json_data


if __name__ == "__main__":
    # Variable to switch between testing and prod environments
    is_prod = False

    # Variables for location and name of JSON file with startup data
    json_path = []
    json_filename = ""

    if is_prod:
        json_path.extend(["data", "json_data"])
        json_filename = "startup_data.json"
    else:
        json_path.extend(["startup_data_modifier_tool", "program_files"])
        json_filename = "test_data.json"

    # Main loop to allow user to navigate program options
    quit_loop = False

    user_choices = (
        "Choose one of the following:\n"
        "[1] Create a new startup JSON file\n"
        "[2] Edit an existing startup JSON file\n"
        "[3] Quit the program\n"
    )

    # Initialize status variables
    status_state = False
    status_message = "No action taken..."

    while not quit_loop:
        print("")  # Add a blank line before showing user choices
        print(user_choices)
        user_choice = input("What would you like to do? ")

        # Validate input
        if not user_choice.isnumeric() or int(user_choice) < 1 or int(user_choice) > 3:
            print("\nPlease enter a valid choice\n")

        # User chose a valid option, process accordingly
        user_choice = int(user_choice)

        if user_choice == 1:
            # Create a new JSON file
            status_state, status_message = json_creator(json_path, json_filename)
        elif user_choice == 2:
            # Read in existing JSON file and store the return results of the
            # json_read function
            status_state, status_message, json_data = json_reader(
                json_path, json_filename
            )
        else:
            quit_loop = True

        # Print the status message if user isn't exiting the program
        if not quit_loop:
            print(f"\n{status_message}")
        else:
            print("Thank you for using CompStart. Have a wonderful day.")
