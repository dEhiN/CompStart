# Dependency to store the helper functions that are used to
# generate JSON data

import copy

import dependencies.enum as deps_enum
import dependencies.helper as deps_helper
import dependencies.pretty as deps_pretty
import demord as app_demord

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_JSS = deps_enum.JsonSchemaStructure


def generate_new_json_data(is_default: bool = False):
    """Helper function to create new startup JSON data

    Depending on the parameters passed in, the function will either:

        1) Create default startup data and create a new startup_data.json file with the
            default data
        2) Create a new startup_data.json file but first have the user specify the data

    Args:
        is_default (bool): Tells this function if, when new_file is True, whether to
        create a file with default values or user-specified ones; default is False.

    Returns:
        dict: The actual JSON data if there is any to return or an empty
        dictionary if not
    """
    # Adding override to use default startup file for when not in production
    if not app_demord.is_production():
        print(
            "This functionality hasn't been fully implemented yet. Creating default startup file..."
        )
        is_default = True

    # Determine what type of JSON data to create
    if is_default:
        json_data = generate_default_startup_data()
    else:
        json_data = generate_user_startup_data()

    return json_data


def generate_default_startup_data():
    """Helper function to create default startup data

    The default startup data opens 3 programs at startup - notepad, calculator and
    Chrome to www.google.com.

    Returns:
        dict: A dictionary of JSON startup data
    """

    return deps_helper.DEFAULT_JSON


def generate_user_startup_data():
    """Helper function to create startup data that the user chooses

    Currently, this function just returns a JSON object with no startup data

    Returns:
        dict: A dictionary of JSON startup data
    """
    # Create empty JSON object / Python dictionary
    json_data = ENUM_JSS.OBJECT.value.copy()
    json_data[ENUM_JSK.TOTALITEMS.value] = 0
    json_data[ENUM_JSK.ITEMS.value] = ENUM_JSS.ARRAY.value.copy()

    print(
        "This functionality hasn't been fully implemented yet. Creating blank"
        " startup file..."
    )

    return json_data


def generate_user_edited_data(
    modified_json_data: dict, item_type: str, orig_json_data: dict = {}
):
    """Helper function to create JSON data from edited startup data

    Creates a dictionary with the new JSON data added in, removed or updated. Uses the Enum class JsonSchemaKey through the variable ENUM_JSK to populate the keys. Uses the Enum class JsonSchemaStructure through the variable ENUM_JSS to create a Python dictionary for a JSON object and a Python list for a JSON array when called for. Because of how Python passes mutable data types, when using the ENUM_JSS members, a copy has to be made of the member value. When working with nested data structures, the function deepcopy needs to be called from the copy module.

    Because there are only certain possible scenarios, the parameter data must
    be validated to determine which scenario and throw an error if the data
    doesn't fit. A helper function called data_validation_scenario is created
    below to do the actual validation. The docstring for that function lists
    the possible scenarios and their criteria.

    Args:
        modified_json_data (dict): Required. A dictionary containing JSON
        data that needs to be written to disk. It can either be a single
        startup item or the full JSON startup data. If it's a single startup item, depending on item_type, it will either be added to or deleted from the existing startup data, or replace a startup item in the existing startup data. If it's full JSON data, it's validated against the startup data JSON schema and returned if valid.

        item_type (str): Required. Specify whether the modified_json_data is to
        be added to orig_json_data, deleted from orig_json_data, or replace a specific startup item in orig_json_data. Since the parameter is an int, invalid values will throw an error. Currently, the only valid values are:

        A = add to the end of orig_json_data
        D = delete from orig_json_data
        R = replace in orig_json_data
        F = modified_json_data is full startup data, so item_type isn't applicable

        In the case of R, since modified_json_data will be a valid startup item, the property ItemNumber will determine which startup item is to be updated.

        orig_json_data (dict): Optional. A dictionary containing the original
        JSON data to be replaced or updated. If nothing is passed in, then it's
        blank by default.

    Returns:
        dict: A dictionary with the updated JSON data
    """
    # Initialize function variables
    new_json_data = ENUM_JSS.OBJECT.value.copy()
    valid_values = ["A", "D", "R", "F"]

    # Check if item_type is a valid value
    if item_type not in valid_values:
        # Item_type isn't a valid value, so print an error and skip the rest of this function
        deps_pretty.prettify_custom_error(
            "The item_type parameter passed in is invalid!",
            "data_generate.generate_user_edited_data",
        )
    else:
        # Item_type is a valid value, so continue
        scenario_number = data_validation_scenario(
            modified_json_data, item_add, orig_json_data
        )

        # Check the status of the data validation
        # If the validation failed, then a blank Python dictionary is returned,
        # so no need to code that in
        match scenario_number:
            case 1:
                # Data validation passed and modified JSON data passed in is a single startup item that is meant to update an existing startup item. Return the original JSON data but with the changed, existing startup item.
                total_items = orig_json_data["TotalItems"]
                change_item_number = modified_json_data["ItemNumber"]

                # Check to make sure the item number is valid
                if change_item_number in range(1, total_items + 1):
                    new_json_data = copy.deepcopy(orig_json_data)
                    new_json_data[ENUM_JSK.ITEMS.value][change_item_number - 1] = (
                        copy.deepcopy(modified_json_data)
                    )
                else:
                    deps_pretty.prettify_custom_error(
                        "Cannot update the JSON data! The startup item number passed in is invalid!",
                        "data_generate.generate_user_edited_data",
                    )
            case 2:
                # Data validation passed and modified JSON data passed in is a single startup item that needs to be deleted from the startup data. Remove the item and update the TotalItems property of the startup data as well as the ItemNumber for all startup items that originally came after the deleted startup item. Return the original JSON data but with the changes.

                # TODO# Code this in!!!
                pass
            case 3:
                # Data validation passed and modified JSON data passed in is full
                # JSON data. Return the modified_json_data variable.
                new_json_data = copy.deepcopy(modified_json_data)
            case 4:
                # Data validation passed and modified JSON data passed in is a single startup item that has to be added to the end. Return the original JSON data but updated with the new startup item added to the end.
                current_total_items = orig_json_data["TotalItems"]
                orig_items_list = orig_json_data["Items"]
                new_total_items = current_total_items + 1

                # Make sure the item number of the new startup item is correct
                if (
                    modified_json_data["ItemNumber"]
                    <= orig_items_list[current_total_items - 1]["ItemNumber"]
                ):
                    modified_json_data["ItemNumber"] = new_total_items

                # Copy the necessary data including adding the new startup item at
                # the end of the items list
                new_items_list = copy.deepcopy(orig_items_list)
                new_items_list.append(copy.deepcopy(modified_json_data))

                new_json_data[ENUM_JSK.TOTALITEMS.value] = new_total_items
                new_json_data[ENUM_JSK.ITEMS.value] = new_items_list

    return new_json_data


def data_validation_scenario(
    modified_json_data: dict, item_add: bool, orig_json_data: dict
):
    """Helper function for the function generate_user_edited_data to handle
    the data validation and determining which scenario is applicable based on
    the following possible valid scenarios:

    1) Need to update a single, existing startup item
        - modified_json_data will be a fully-formed, single startup item
        - item_add will be False
        - orig_json_data will be full JSON startup data
    2) Need to update the full JSON data
        - modified_json_data will be full JSON startup data
        - item_add will be False
        - orig_json_data will be blank
    3) Need to add a single startup item
        - modified_json_data will be a fully-formed, single startup item
        - item_add will be True
        - orig_json_data will be full JSON startup data

    This function takes in the same arguments passed to
    generate_user_edited_data with the exception that the last parameter is
    required instead of optional.

    Args:
        modified_json_data (dict): Required. A dictionary containing new JSON
        data that needs to be written to disk. It can either be a single
        startup item or the full JSON startup data.

        item_add (bool): Required. Specify whether the modified_json_data is to
        be added to orig_json_data or should replace some or all of it.

        orig_json_data (dict): Required. A dictionary containing the original
        JSON data to be replaced or updated. If nothing is passed in, then it's
        blank by default.

    Returns:
        int: A scenario number based on the following legend:
                0 - The validation failed and the function
                generate_user_edited_data shouldn't proceed
                1 - Scenario 1 listed above is applicable
                2 - Scenario 2 listed above is applicable
                3 - Scenario 3 listed above is applicable
    """
    # Dictionary to validate the data before proceeding and track which scenario
    # listed in the docstring above is the case. The keys are as follows:
    # Item-Add: whether to add an item
    # Orig-Exists: whether orig_json_data is blank or not
    # Orig-Valid: if orig_json_data exists, is the data valid
    # Mod-Valid: if modified_json_data is valid
    # Item-Single: if modified_json_data contains a single startup item
    data_validation = {
        "Item-Add": item_add,
        "Orig-Exists": True if len(orig_json_data) > 0 else False,
        "Orig-Valid": False,
        "Mod-Valid": False,
        "Item-Single": False,
    }

    # If the orig_json_data dictionary isn't blank, check that it contains
    # properly formed data
    if data_validation["Orig-Exists"]:
        data_validation["Orig-Valid"] = deps_helper.json_data_validator(orig_json_data)

    # Check if modified_json_data contains properly formed data
    if ENUM_JSK.TOTALITEMS.value in modified_json_data:
        # Full startup data
        data_validation["Mod-Valid"] = deps_helper.json_data_validator(
            modified_json_data
        )
    elif ENUM_JSK.ITEMNUMBER.value in modified_json_data:
        # Single startup item
        data_validation["Mod-Valid"] = deps_helper.json_data_validator(
            modified_json_data, True
        )
        data_validation["Item-Single"] = True

    # Check for each of the 3 scenarios listed in the docstring:
    scenario_number, validation_results = match_scenario(data_validation)

    # If the validation failed, print the error message
    if scenario_number == 0:
        deps_pretty.prettify_custom_error(
            validation_results, "data_generate.data_validation_scenario"
        )

    return scenario_number


def match_scenario(data_validation: dict):
    """A small helper function to perform the actual match-case block for
    the function data_validation_scenario. This function was created to split
    up the code and make is easier to read, test and maintain.

    Args:
        data_validation (dict): A dictionary containing the boolean values
        needed to validate the data for the function data_validation_scenario.
        The keys are as follows:
        - Item-Add: whether to add an item
        - Orig-Exists: whether orig_json_data is blank or not
        - Orig-Valid: if orig_json_data exists, is the data valid
        - Mod-Valid: if modified_json_data is valid
        - Item-Single: if modified_json_data contains a single startup item

    Returns:
        tuple: Consists of an int and a string defined as follows:
                int: A scenario number that indicates which scenario is
                applicable. See the docstring for data_validation_scenario for
                more information.

                string: A message to print out if the validation failed.
    """
    scenario_number = 0
    validation_results = ""

    if not app_demord.is_production():
        print("\nThe dictionary passed to match_scenario:", data_validation)

    match data_validation:
        case {
            "Item-Add": False,
            "Orig-Exists": True,
            "Orig-Valid": True,
            "Mod-Valid": True,
            "Item-Single": True,
        }:
            scenario_number = 1
        case {
            "Item-Add": False,
            "Orig-Exists": False,
            "Mod-Valid": True,
            "Item-Single": False,
        }:
            scenario_number = 2
        case {
            "Item-Add": True,
            "Orig-Exists": True,
            "Orig-Valid": True,
            "Mod-Valid": True,
            "Item-Single": True,
        }:
            scenario_number = 3
        case {
            "Item-Add": True,
            "Orig-Exists": True,
            "Orig-Valid": True,
            "Mod-Valid": True,
            "Item-Single": False,
        } | {
            "Item-Add": False,
            "Orig-Exists": True,
            "Orig-Valid": True,
            "Mod-Valid": True,
            "Item-Single": False,
        }:
            validation_results = (
                "Expected a single startup item for the modified JSON data "
                "but didn't receive that. Cannot proceed."
            )
        case {
            "Item-Add": False,
            "Orig-Exists": False,
            "Mod-Valid": True,
            "Item-Single": True,
        }:
            validation_results = (
                "Expected full startup data for the modified JSON data but "
                "didn't receive that. Cannot proceed."
            )
        case (
            {
                "Item-Add": True,
                "Orig-Exists": True,
                "Orig-Valid": True,
                "Mod-Valid": False,
            }
            | {
                "Item-Add": False,
                "Orig-Exists": True,
                "Orig-Valid": True,
                "Mod-Valid": False,
            }
            | {
                "Item-Add": False,
                "Orig-Exists": False,
                "Mod-Valid": False,
            }
        ):
            validation_results = (
                "The modified JSON data passed in is not properly formed. "
                "Cannot proceed."
            )
        case {
            "Item-Add": True,
            "Orig-Exists": True,
            "Orig-Valid": False,
        } | {
            "Item-Add": False,
            "Orig-Exists": True,
            "Orig-Valid": False,
        }:
            validation_results = (
                "Original JSON data passed in is not properly formed. "
                "Cannot proceed."
            )
        case {
            "Item-Add": True,
            "Orig-Exists": False,
        }:
            validation_results = (
                "Original JSON data cannot be found. Please provide original "
                "JSON data when adding a new startup item."
            )

    # If the validation failed, print the error message
    if scenario_number == 0:
        deps_pretty.prettify_custom_error(
            validation_results, "data_generate.match_scenario"
        )

    return (scenario_number, validation_results)
