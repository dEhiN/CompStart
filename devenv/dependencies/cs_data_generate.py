# Dependency to store the helper functions that are used to generate JSON data

import copy, os.path

import dependencies.cs_enum as deps_enum
import dependencies.cs_helper as deps_helper
import dependencies.cs_pretty as deps_pretty
import dependencies.cs_jsonfn as deps_json
import CompStart as app_cs

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_JSS = deps_enum.JsonSchemaStructure
ENUM_ITV = deps_enum.ItemTypeVals


def generate_new_json_data(is_default: bool = False):
    """Helper function to create new startup JSON data

    Depending on the parameters passed in, the function will either:

        1) Create default startup data and create a new startup_data.json file with the default data
        2) Create a new startup_data.json file but first have the user specify the data

    Args:
        is_default (bool): Tells this function whether to create a file with default values or user-specified ones; default is False.

    Returns:
        bool: True if there is JSON data to return, False if not

        dict: The actual JSON data if there is any to return or an empty dictionary if not
    """
    exists_data = False
    json_data = {}

    # Determine what type of JSON data to create
    if is_default:
        exists_data, json_data = generate_default_startup_data()
    else:
        json_data = generate_blank_startup_data()
        exists_data = True

    return (exists_data, json_data)


def generate_default_startup_data():
    """Helper function to create default startup data

    Reads in the default startup data from the file default_startup.json and returns it

    Returns:
        bool: True if there is JSON data to return, False if not

        dict: A dictionary of JSON startup data
    """
    exists_data = False
    default_json = {}

    config_path = deps_helper.get_prod_path()

    file_name = deps_helper.get_startup_filename(default_json=True)

    json_file = deps_helper.parse_full_path(config_path, file_name)

    if os.path.isfile(json_file):
        # Read in JSON data
        read_success, return_message, default_json = deps_json.json_reader(config_path, file_name)
        if read_success:
            exists_data = True
        else:
            deps_pretty.prettify_custom_error(
                "Could not generate default startup data",
                "generate_default_startup_data",
            )
    else:
        deps_pretty.prettify_custom_error(
            "The default startup data JSON file could not be found",
            "generate_default_startup_data",
        )

    return (exists_data, default_json)


def generate_blank_startup_data():
    """Helper function to create blank startup data for when the user wants to add their own programs

    This function just returns a JSON object with no startup items. This gets passed back to the function json_creator in the module cs_jsonfn to be written to disk. After that, the function json_creator will perform the work necessary to create startup data that the user chooses

    Returns:
        dict: A dictionary of valid JSON startup data with no startup items and the property TotalItems set to 0
    """
    # Create empty JSON object / Python dictionary
    json_data = ENUM_JSS.OBJECT.value.copy()
    json_data[ENUM_JSK.TOTALITEMS.value] = 0
    json_data[ENUM_JSK.ITEMS.value] = ENUM_JSS.ARRAY.value.copy()

    return json_data


def generate_user_edited_data(modified_json_data: dict, item_type: str, orig_json_data: dict = {}):
    """Helper function to create JSON data from edited startup data

    Creates a dictionary with the new JSON data added in, removed or updated. Uses the Enum class JsonSchemaKey through the variable ENUM_JSK to populate the keys. Uses the Enum class JsonSchemaStructure through the variable ENUM_JSS to create a Python dictionary for a JSON
    object and a Python list for a JSON array when called for. Because of how Python passes mutable data types, when using the ENUM_JSS members, a copy has to be made of the member value. When working with nested data structures, the function deepcopy needs to be called from the copy
    module.

    Because there are only certain possible scenarios, the parameter data must be validated to determine which scenario and throw an error if the data doesn't fit. A helper function called data_validation_scenario is created below to do the actual validation. The docstring for that function lists the possible scenarios and their criteria.

    Args:
        modified_json_data (dict): Required. A dictionary containing JSON data that can either be a single startup item or the full JSON startup data. If it's a single startup item, depending on item_type, it will either be added to or deleted from the existing startup data, or replace a startup item in the existing startup data. If it's full JSON data, it's validated against the startup data JSON schema and returned if valid.

        item_type (str): Required. Specify whether the modified_json_data is to be added to orig_json_data, deleted from orig_json_data, or replace a specific startup item in orig_json_data. Since the parameter is an int, invalid values will throw an error. Currently, the only valid values are:

        1 = add to the end of orig_json_data
        2 = delete from orig_json_data
        3 = replace in orig_json_data
        4 = modified_json_data is full startup data

        In the case of R, since modified_json_data will be a valid startup item, the property ItemNumber will determine which startup item is to be updated.

        orig_json_data (dict): Optional. A dictionary containing the original JSON data to be replaced or updated. If nothing is passed in, then it's blank by default.

    Returns:
        dict: A dictionary with the updated JSON data
    """
    # Create empty JSON object / Python dictionary
    new_json_data = ENUM_JSS.OBJECT.value.copy()

    # Check if item_type is a valid value
    if not deps_helper.check_item_type(item_type):
        # Item_type isn't a valid value, so print an error and skip the rest of this function
        deps_pretty.prettify_custom_error(
            "The item_type parameter passed in is invalid!",
            "data_generate.generate_user_edited_data",
        )
    else:
        # Item_type is a valid value, so continue
        scenario_number = data_validation_scenario(modified_json_data, item_type, orig_json_data)

        # Check the status of the data validation
        # If the validation failed, then a blank Python dictionary is returned, so no need to code that in
        match scenario_number:
            case 1:
                # Data validation passed and modified JSON data passed in is a single startup item that has to be added to the end. Return the original JSON data but updated with the new startup item added to the end.
                current_total_items = orig_json_data[ENUM_JSK.TOTALITEMS.value]
                orig_items_list = orig_json_data[ENUM_JSK.ITEMS.value]
                new_total_items = current_total_items + 1

                # Make sure the item number of the new startup item is correct
                if (
                    modified_json_data[ENUM_JSK.ITEMNUMBER.value]
                    <= orig_items_list[current_total_items - 1][ENUM_JSK.ITEMNUMBER.value]
                ):
                    modified_json_data[ENUM_JSK.ITEMNUMBER.value] = new_total_items

                # Copy the necessary data including adding the new startup item at the end of the items list
                new_items_list = copy.deepcopy(orig_items_list)
                new_items_list.append(copy.deepcopy(modified_json_data))

                new_json_data[ENUM_JSK.TOTALITEMS.value] = new_total_items
                new_json_data[ENUM_JSK.ITEMS.value] = new_items_list
            case 2:
                # Data validation passed and modified JSON data passed in is a single startup item that needs to be deleted from the startup data. Remove the item and update the TotalItems property of the startup data as well as the ItemNumber for all startup items that originally came after the deleted startup item. Return the original JSON data but with the changes.

                total_items = orig_json_data[ENUM_JSK.TOTALITEMS.value]
                delete_item_number = modified_json_data[ENUM_JSK.ITEMNUMBER.value]

                # Check to make sure the item number is valid
                if delete_item_number in range(1, total_items + 1):
                    # Create a copy of the original JSON data
                    new_json_data = copy.deepcopy(orig_json_data)

                    # Grab a new reference as a list to the JSON data Items array
                    new_items_data = new_json_data[ENUM_JSK.ITEMS.value]

                    # Remove the startup item to be deleted
                    new_items_data.pop(delete_item_number - 1)

                    # Update the Total Items property
                    new_json_data[ENUM_JSK.TOTALITEMS.value] = total_items - 1

                    # Check to see if the Items array needs to be updated:
                    # 1. If there was only one item in the Items array, then nothing needs to be updated
                    # 2. If there is more than one item but the deleted startup item was the last in the Items array, then nothing needs to be updated
                    if total_items > 1 and delete_item_number < total_items:
                        # The deleted startup item was an item in the middle of the Items array
                        ## TODO: Code this in!!
                        item_count = 1
                        for item in new_items_data:
                            item[ENUM_JSK.ITEMNUMBER.value] = item_count
                            item_count += 1
                else:
                    deps_pretty.prettify_custom_error(
                        "Cannot update the JSON data! The startup item number passed in is invalid!",
                        "data_generate.generate_user_edited_data",
                    )

            case 3:
                # Data validation passed and modified JSON data passed in is a single startup item that is meant to update an existing startup item. Return the original JSON data but with the changed, existing startup item.
                total_items = orig_json_data[ENUM_JSK.TOTALITEMS.value]
                change_item_number = modified_json_data[ENUM_JSK.ITEMNUMBER.value]

                # Check to make sure the item number is valid
                if change_item_number in range(1, total_items + 1):
                    new_json_data = copy.deepcopy(orig_json_data)
                    new_json_data[ENUM_JSK.ITEMS.value][change_item_number - 1] = copy.deepcopy(
                        modified_json_data
                    )
                else:
                    deps_pretty.prettify_custom_error(
                        "Cannot update the JSON data! The startup item number passed in is invalid!",
                        "data_generate.generate_user_edited_data",
                    )
            case 4:
                # Data validation passed and modified JSON data passed in is full JSON data. Return the modified_json_data variable.
                new_json_data = copy.deepcopy(modified_json_data)

    return new_json_data


def data_validation_scenario(modified_json_data: dict, item_type: str, orig_json_data: dict):
    """Helper function for the function generate_user_edited_data to handle the data validation and determining which scenario is applicable based on the following possible valid scenarios:

    1) Need to add a single startup item
        - modified_json_data will be a fully-formed, single startup item
        - item_type will be A
        - orig_json_data will be full JSON startup data
    2) Need to remove a single startup item
        - modified_json_data will be a fully-formed, single startup item
        - item_type will be D
        - orig_json_data will be full JSON startup data
    3) Need to replace a single startup item that already exists
        - modified_json_data will be a fully-formed, single startup item
        - item_type will be R
        - orig_json_data will be full JSON startup data
    4) Need to update the full JSON data
        - modified_json_data will be full JSON startup data
        - item_type will be F
        - orig_json_data will be blank

    This function takes in the same arguments passed to generate_user_edited_data with the exception that the last parameter is required instead of optional.

    Args:
        modified_json_data (dict): Required. A dictionary containing JSON data that needs to be written to disk. It can either be a single startup item or the full JSON startup data. If it's a single startup item, depending on item_type, it will either be added to or deleted from the existing startup data, or replace a startup item in the existing startup data. If it's full JSON data, it's validated against the startup data JSON schema and returned if valid.

        item_type (str): Required. Specify whether the modified_json_data is to be added to orig_json_data, deleted from orig_json_data, or replace a specific startup item in orig_json_data. Since the parameter is an int, invalid values will throw an error. Currently, the only valid values are:

        A = add to the end of orig_json_data
        D = delete from orig_json_data
        R = replace in orig_json_data
        F = modified_json_data is full startup data

        In the case of R, since modified_json_data will be a valid startup item, the property
        ItemNumber will determine which startup item is to be updated.

        orig_json_data (dict): Required. A dictionary containing the original JSON data to be
        replaced or updated. If there is no original JSON data to work with, depending on the
        scenario, then this parameter will be blank.

    Returns:
        int: A scenario number based on the following legend:
                0 - The validation failed and the function generate_user_edited_data shouldn't
                proceed
                1 - Scenario 1 listed above is applicable
                2 - Scenario 2 listed above is applicable
                3 - Scenario 3 listed above is applicable
                4 - Scenario 4 listed above is applicable
    """
    # Dictionary to validate the data before proceeding and track which scenario
    # listed in the docstring above is the case. The keys are as follows:
    # Item-Type: whether to add/delete/replace a single startup item or replace the full startup data
    # Orig-Exists: whether orig_json_data is blank or not
    # Orig-Valid: if orig_json_data exists, is the data valid
    # Mod-Single: if modified_json_data contains a single startup item or full startup data
    # Mod-Valid: if modified_json_data is valid
    data_validation = {
        "Item-Type": item_type,
        "Orig-Exists": True if len(orig_json_data) > 0 else False,
        "Orig-Valid": False,
        "Mod-Single": False,
        "Mod-Valid": False,
    }

    # If the orig_json_data dictionary isn't blank, check that it contains properly formed data
    if data_validation["Orig-Exists"]:
        data_validation["Orig-Valid"] = deps_helper.json_data_validator(orig_json_data)

    # Check if modified_json_data contains properly formed data
    if ENUM_JSK.TOTALITEMS.value in modified_json_data:
        # Full startup data
        data_validation["Mod-Valid"] = deps_helper.json_data_validator(modified_json_data)
    elif ENUM_JSK.ITEMNUMBER.value in modified_json_data:
        # Single startup item
        data_validation["Mod-Single"] = True
        data_validation["Mod-Valid"] = deps_helper.json_data_validator(modified_json_data, True)

    # Check for each of the 3 scenarios listed in the docstring:
    scenario_number, validation_results = match_scenario(data_validation)

    # If the validation failed, print the error message
    if scenario_number == 0:
        deps_pretty.prettify_custom_error(
            validation_results, "data_generate.data_validation_scenario"
        )

    return scenario_number


def match_scenario(data_validation: dict):
    """A small helper function to perform the actual match-case block for the function data_validation_scenario. This function was created to split up the code and make is easier to read, test and maintain.

    The valid scenarios, with the corresponding scenario number, are:

    1) Need to add a single startup item
        - modified_json_data will be a fully-formed, single startup item
        - item_type will be A
        - orig_json_data will be full JSON startup data
    2) Need to remove a single startup item
        - modified_json_data will be a fully-formed, single startup item
        - item_type will be D
        - orig_json_data will be full JSON startup data
    3) Need to replace a single startup item that already exists
        - modified_json_data will be a fully-formed, single startup item
        - item_type will be R
        - orig_json_data will be full JSON startup data
    4) Need to update the full JSON data
        - modified_json_data will be full JSON startup data
        - item_type will be F
        - orig_json_data will be blank


    Args:
        data_validation (dict): A dictionary containing the boolean values needed to validate the data for the function data_validation_scenario. The keys are as follows:
            - Item-Type: whether to add/delete/replace a single startup item or replace the full startup data
            - Orig-Exists: whether orig_json_data is blank or not
            - Orig-Valid: if orig_json_data exists, is the data valid
            - Mod-Single: if modified_json_data contains a single startup item or full startup data
            - Mod-Valid: if modified_json_data is valid

    Returns:
        tuple: Consists of an int and a string defined as follows:
                int: A scenario number that indicates which scenario is applicable. See the
                docstring for data_validation_scenario for more information.

                string: A message to print out if the validation failed.
    """
    # Initialize the function variables
    valid_scenario_number = 0
    error_scenario_number = 0
    validation_results = ""

    # Expand the data_validation dictionary keys to separate variables for the conditional block
    item_type, orig_exists, orig_valid, mod_single, mod_valid = data_validation.values()

    # Set up the different error scenario texts
    error_scenario_numbers = [
        "Expected original JSON data but that cannot be found.",
        "Original JSON data passed in is not properly formed.",
        "Expected modified JSON data to be a single startup item but didn't receive that.",
        "Expected modified JSON data to be a full startup data but didn't receive that.",
        "The modified JSON data passed in is not properly formed.",
    ]

    # This will be added to the end of each error scenario text
    error_ending = "Cannot proceed."

    # Check for a possible valid or error scenario
    if not mod_valid:
        error_scenario_number = 5
    else:
        if item_type == "F":
            if not mod_single:
                valid_scenario_number = 4
            else:
                error_scenario_number = 4
        else:
            if mod_single:
                if orig_exists:
                    if orig_valid:
                        if item_type == "A":
                            valid_scenario_number = 1
                        elif item_type == "D":
                            valid_scenario_number = 2
                        else:
                            valid_scenario_number = 3
                    else:
                        error_scenario_number = 2
                else:
                    error_scenario_number = 1
            else:
                error_scenario_number = 3

    # If the validation failed, print the error message
    if valid_scenario_number == 0:
        if error_scenario_number == 0:
            validation_results = "Error validating scenario! Both the valid_scenario_number and error_scenario_number variables have a value of 0!"
        else:

            validation_results = (
                error_scenario_numbers[error_scenario_number - 1] + " " + error_ending
            )
        deps_pretty.prettify_custom_error(validation_results, "data_generate.match_scenario")

    return (valid_scenario_number, validation_results)
