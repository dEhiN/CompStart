# This will be a command line tool to create and edit the startup_data.json
# file.

import json


def json_reader(path: str, file: str):
    """Function to read in JSON data from a file

    Currently the function only validates if file:str in a valid JSON
    file by checking the extension. The full functionality will be to read in
    the JSON data from file:str, assuming it's a valid JSON file, and return
    that so we work with the JSON data in memory.

    Args:
        path (str): A relative or absolute path to the folder with JSON file
        file (str): The filename of the JSON file
    Returns:
        string: Currently a message indicating the validity of file
    """

    # Validate if correct JSON file
    split_file = file.split(".")
    if len(split_file) == 1:
        return_message = "Please specify a valid JSON file name"
    else:
        last_item = split_file[len(split_file) - 1]
        if last_item == "json":
            return_message = "Valid JSON file name"
        else:
            return_message = f"Invalid JSON file name.\nExpected extension of: json\nReceived extension of: {last_item}"

    return return_message


if __name__ == "__main__":
    # Variable to switch between testing and prod environments
    is_prod = False

    # Variables for location and name of JSON file with startup data
    json_path = ""
    json_filename = ""
    if is_prod:
        json_path = "/data/json_data/"
        json_filename = "startup_data.json"
    else:
        json_path = "./"
        json_filename = "test_data.json"

    # Read JSON data from file and print whether file is valid JSON file
    status_message = json_reader(json_path, json_filename)
    print(status_message)
