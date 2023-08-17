# This will be a command line tool to create and edit the startup_data.json
# file.

import json
import os


def json_reader(json_path: list, json_filename: str):
    """Function to read in JSON data from a file

    Currently the function only validates if file:str in a valid JSON
    file by checking the extension. The full functionality will be to read in
    the JSON data from file:str, assuming it's a valid JSON file, and return
    that so we work with the JSON data in memory.

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
    is_json_file = False
    return_message = ""
    json_data = {}

    # Validate if correct JSON file
    split_filename = json_filename.split(".")
    if len(split_filename) == 1:
        return_message = "Please specify a valid JSON file name"
    else:
        last_item = split_filename[len(split_filename) - 1]
        if last_item != "json":
            return_message = f"Invalid JSON file name.\nReceived extension of: {last_item}\nExpected extension of: json"
        else:
            is_json_file = True

    # Get the full path to the JSON file
    full_path = os.getcwd()
    for item in json_path:
        full_path += os.sep + os.path.join(item)

    # Add the full path and JSON filename together
    json_file = full_path + os.sep + json_filename

    # Read in JSON data
    try:
        with open(json_file, "r") as json_file:
            json_data = json.load(json_file)
    except:
        pass

    return is_json_file, return_message, json_data


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

    # Check if given filename is a valid JSON file and if it is, return the
    # JSON data, and if it's not, print an error message and exit with status
    # of 1
    is_json_file, status_message, json_data = json_reader(json_path, json_filename)
    if not is_json_file:
        print(status_message)
        exit(1)
