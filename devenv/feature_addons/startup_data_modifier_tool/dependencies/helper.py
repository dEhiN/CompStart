# Dependency to store miscellaneous helper functions that don't fit anywhere else as well as the default JSON data

import os, jsonschema

import dependencies.pretty as deps_pretty
import dependencies.jsonfn as deps_json
import dependencies.enum as deps_enum
import comp_start as app_cs

ENUM_ITV = deps_enum.ItemTypeVals


def set_start_dir():
    dirs_list = os.getcwd().split(os.sep)
    len_dirs_list = len(dirs_list) - 1
    start_dir = "CompStart"

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
        "\nWhat is CompStart?\n"
        "CompStart is a computer startup tool designed to make your life easier.\n\n"
        "What does that mean?\n"
        "Have you ever wished to be able to log into your laptop at work and\n"
        "have all of your programs automatically start up? Or, maybe you are\n"
        "working on some personal project at home and don't want to be reopening\n"
        "the file or program you're using every time you turn on your desktop\n"
        "computer. With CompStart, you you can have any program automatically open\n"
        "when you log in, including your favourite browser to any websites you\n"
        "desire as well as any files you want, such as a Word document."
    )
    print(program_information)
    print("\nThis menu option is still under construction...come back later...")
    input("\nPress any key to return to the main menu... ")


def parse_full_path(json_path: list, json_filename: str):
    """Helper function to parse the path components to a JSON file

    Args:
        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

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

    If a startup file already exists, this function will check to see if the user would like to overwrite it. This function assumes the file exists and doesn't check for that.

    Args:
        json_file (str): The file that will be overwritten

    Returns:
        bool: True if user would like to overwrite the existing file, False otherwise
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
    """Helper function to validate startup JSON data, including both full data and a single startup item, against the JSON Schema defined in startup_data.schema.json or startup_item.schema.json, depending on what needs to be validated.

    Args:
        json_data (dict): The JSON data to validate

        single_item (bool): A boolean to specify whether to validate a single startup item or consider json_data to be the full startup data. Optional and is False by default.

    Returns:
        bool: True if the validation was successful, False otherwise
    """
    valid_json = False
    schema_file = "startup_item.schema.json" if single_item else "startup_data.schema.json"
    schema_path = get_prod_path()
    schema_path.extend(["config"])

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


def get_prod_path():
    """Helper function to get a starting location based on the production environment.

    The purpose of this function is to return a starting location from which to find or open a file. This depends on the environment being used. Since there are currently at least two locations where this functionality is needed, the logic was extrapolated to its own function.

    Currently, the starting location for all calls to this helper function will be derived from
    /devenv, where / is the CompStart project folder. For the production environment, the starting location will be /devenv/data/json_data. For the development environment, the starting location will be /devenv/feature_addons/startup_data_modifier_tool.

    Returns:
        list: A list of strings, with each string representing a sub-directory going from left to right. Example: ["grandparent", "parent", "child"]
    """
    prod_path = ["devenv"]
    if app_cs.is_production():
        prod_path.extend(["data", "json_data"])
    else:
        prod_path.extend(["feature_addons", "startup_data_modifier_tool"])

    return prod_path


def check_item_type(item_type: str):
    """Helper function to check the passed in item_type parameter against the valid values allowed for that argument

    The Enum class ItemTypeVals in the enum module contains all the valid values that this parameter can hold as members. This function will compare against each member and return True if the passed in parameter has a valid value, or False if not.

    Args:
        item_type (str): This variable is a parameter used by the function generate_user_edited_data in the module data_generate. It currently only accepts certain values, which are:

        A = add to the end of orig_json_data
        D = delete from orig_json_data
        R = replace in orig_json_data
        F = modified_json_data is full startup data

    Returns:
        bool: True if the value of item_type is valid, False if not.
    """
    ret_value = False
    for enum_member in ENUM_ITV:
        if enum_member.value == item_type:
            ret_value = True
            break

    return ret_value
