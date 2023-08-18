# This will be a command line tool to create and edit the startup_data.json
# file.

import json
import os
from enum_classes import JsonSchemaKeys as ec_jsk
from enum_classes import JsonSchemaStructure as ec_jss

# An example of valid startup_data.json data to use while coding
EXAMPLE_JSON = {
    "TotalItems": 1,
    "Items": [
        {
            "ItemNumber": 1,
            "FilePath": "notepad",
            "Comments": "",
            "Browser": False,
            "ArgumentCount": 0,
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


def generate_json(json_data: dict, **kwargs):
    """Function to create JSON data from **kwargs parameter

    Args:
        json_data (dict): An empty dictionary to represent the top level JSON
        object

        **kwargs: Optional parameters that contain new JSON data

    Returns:
        dict: The same dictionary passed in but now filled with JSON data
    """

    pass


def generate_default(json_data: dict):
    """Function to create default startup data

    Args:
        json_data (dict): An empty dictionary to represent the top level JSON
        object

    Returns:
        dict: The same dictionary passed in but now filled with JSON data
    """

    json_data[ec_jsk.TOTALITEMS.value] = 1
    pass


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
    """

    # Create empty JSON object / Python dictionary
    json_data = ec_jss.OBJECT.value

    # If need to create default JSON data
    if default:
        json_data = generate_default(json_data)
    else:
        json_data = generate_json(json_data, **kwargs)


def json_creator(json_path: list, json_filename: str):
    """Function to create new JSON file with default startup data

    Args:
        json_path (list): A list containing the relative or absolute path to
            the JSON file with each list item representing one subfolder from
            Current Working Directory (CWD)
        json_filename (str): The filename of the JSON file

    Returns:

    """

    # Get the full path to the file in string format
    json_file = parse_full_path(json_path, json_filename)

    # Create default JSON data to add to the startup_data.json file
    json_data = create_json_data(default=True)

    pass


def json_reader(json_path: list, json_filename: str):
    """Function to read in JSON data from a file

    Args:
        json_path (list): A list containing the relative or absolute path to
            the JSON file with each list item representing one subfolder from
            Current Working Directory (CWD)
        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if there is JSON data to return, false if not
        string: An error message to display if there's no JSON data to return
            or blank otherwise
        dict: The actual JSON data if there is any to return or an empty
            dictionary if not
    """

    # Create return values
    read_json_success = False
    return_message = ""
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
            except:
                return_message = "Unable to read JSON data"

    return read_json_success, return_message, json_data


if __name__ == "__main__":
    # Variable to switch between testing and prod environments
    is_prod = False

    # Variables for location and name of JSON file with startup data
    json_path = ["data", "json_data"]
    json_filename = ""

    if is_prod:
        json_filename = "startup_data.json"
    else:
        json_filename = "test_data.json"

    # Main loop to allow user to navigate program options
    quit_loop = False

    user_choices = (
        "Choose one of the following:\n"
        "[1] Create a new startup JSON file\n"
        "[2] Edit an existing startup JSON file\n"
        "[3] Quit the program\n"
    )

    while not quit_loop:
        print(user_choices)
        user_choice = input("What would you like to do? ")

        # Validate input
        if not user_choice.isnumeric() or int(user_choice) < 1 or int(user_choice) > 3:
            print("\nPlease enter a valid choice\n")

        # User chose a valid option, process accordingly
        user_choice = int(user_choice)

        if user_choice == 1:
            quit_loop = True

            # Create a new JSON file
            json_creator(json_path, json_filename)
        elif user_choice == 2:
            quit_loop = True

            # Read in existing JSON file and store the return results of the
            # json_read function
            read_json_success, status_message, json_data = json_reader(
                json_path, json_filename
            )

            # Check if reading the JSON data was successful and if not, print
            # the message and exit with a status of 1
            if not read_json_success:
                print(status_message)
                exit(1)
            else:
                print("Valid JSON file!")
        else:
            quit_loop = True
