# Dependency to store miscellaneous helper functions that
# don't fit anywhere else as well as the default JSON data

import os, jsonschema

import dependencies.pretty as deps_pretty
import dependencies.jsonfn as deps_json

# Default startup data to use
DEFAULT_JSON = {
    "TotalItems": 3,
    "Items": [
        {
            "ItemNumber": 1,
            "Name": "Calculator",
            "FilePath": "calc",
            "Description": "A simple calculator",
            "Browser": False,
            "ArgumentCount": 0,
            "ArgumentList": [],
        },
        {
            "ItemNumber": 2,
            "Name": "Google",
            "FilePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
            "Description": "The Google Homepage",
            "Browser": True,
            "ArgumentCount": 3,
            "ArgumentList": [
                "--profile-directory=Default",
                "--new-window",
                "https://www.google.com/",
            ],
        },
        {
            "ItemNumber": 3,
            "Name": "Notepad",
            "FilePath": "notepad",
            "Description": "A text editor",
            "Browser": False,
            "ArgumentCount": 0,
            "ArgumentList": [],
        },
    ],
}


def set_start_dir():
    dirs_list = os.getcwd().split(os.sep)
    len_dirs_list = len(dirs_list) - 1
    start_dir = "Demord"

    if start_dir in dirs_list:
        idx_start_dir = dirs_list.index(start_dir)

        if len_dirs_list == idx_start_dir:
            return
        else:
            num_dirs_diff = len_dirs_list - idx_start_dir
            while num_dirs_diff > 0:
                os.chdir("..")
                num_dirs_diff -= 1


def program_info():
    """Function to explain what this program is and how it works"""
    program_information = (
        "\nWhat is Demord?\n"
        "Demord is a computer startup tool designed to make your life easier.\n\n"
        "What does that mean?\n"
        "Have you ever wished to be able to log into your laptop at work and\n"
        "have all of your programs automatically start up? Or, maybe you are\n"
        "working on some personal project at home and don't want to be reopening\n"
        "the file or program you're using every time you turn on your desktop\n"
        "computer. With Demord, you you can have any program automatically open\n"
        "when you log in, including your favourite browser to any websites you\n"
        "desire as well as any files you want, such as a Word document."
    )
    print(program_information)
    print("\nThis menu option is still under construction...come back later...")
    input("\nPress any key to return to the main menu... ")


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
    """Helper function to confirm before overwriting the startup file

    If a startup file already exists, this function will check to see if the
    user would like to overwrite it. This function assumes the file exists and
    doesn't check for that.

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


def json_data_validator(json_data: dict, single_item: bool = False):
    """Helper function to validate startup JSON data, including both full
    data and a single startup item, against the JSON Schema defined in
    startup_data.schema.json or startup_item.schema.json, depending on what
    needs to be validated.

    Args:
        json_data (dict): The JSON data to validate

        single_item (bool): A boolean to specify whether to validate a single
        startup item or consider json_data to be the full startup data.
        Optional and is False by default.

    Returns:
        bool: True if the validation was successful, False otherwise
    """
    valid_json = False
    schema_file = (
        "startup_item.schema.json" if single_item else "startup_data.schema.json"
    )
    schema_path = ["feature_addons", "startup_data_modifier_tool", "config"]

    results = deps_json.json_reader(schema_path, schema_file)
    read_status = results[0]

    if read_status:
        json_schema = results[2]

        try:
            jsonschema.validate(json_data, json_schema)
            valid_json = True
        except Exception as error:
            err_param = str(type(error).__name__) + " - " + (error.__dict__["message"])
            deps_pretty.prettify_custom_error(err_param, "helper.json_data_validator")

    return valid_json
