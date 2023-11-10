# Dependency to store the helper functions that are used to
# generate JSON data

import dependencies.enum as deps_enum
import dependencies.helper as deps_helper
import dependencies.pretty as deps_pretty

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_JSS = deps_enum.JsonSchemaStructure


def generate_json_data(new_file: bool = False, is_default: bool = False, **kwargs):
    """Helper function to create JSON data

    Depending on the parameters passed in, the function will either:

        1) Create default startup data and create a new startup_data.json file with the
            default data
        2) Create a new startup_data.json file but first have the user specify the data
        3) Update an existing startup_data.json file with JSON data that's passed in.

    Args:
        new_file (bool): Tells this function whether to create a new file or not; default
        is False

        is_default (bool): Tells this function if, when new_file is True, whether to
        create a file with default values or user-specified ones; default is False.

        **kwargs: Optional parameters that can contain JSON data to update an
        existing startup_data.json file; can be in any format

    Returns:
        dict: The actual JSON data if there is any to return or an empty
        dictionary if not
    """

    # Determine what type of JSON data to create
    if new_file and is_default:
        json_data = generate_default_startup_data()
    elif new_file and not is_default:
        json_data = generate_user_startup_data()
    else:
        json_data = generate_user_edited_data(**kwargs)

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
    modified_json_data: dict, item_add: bool, orig_json_data: dict = {}
):
    """Helper function to create JSON data

    Creates a dictionary with the new JSON data added in or updated. Uses the
    Enum class JsonSchemaKey through the variable ENUM_JSK to populate the keys.
    Uses the Enum class JsonSchemaStructure through the variable ENUM_JSS to
    create a Python dictionary for a JSON object and a Python list for a JSON
    array when called for. Because of how Python passes mutable data types,
    when using the ENUM_JSS members, a copy has to be made of the member value.

    Because there are only certain possible scenarios, the parameter data must
    be validated to determine which scenario and throw an error if the data
    doesn't fit. A helper function called data_validation_scenario is created
    below to do the actual validation. The docstring for that function lists
    the possible scenarios and their criteria.

    Args:
        modified_json_data (dict): Required. A dictionary containing new JSON
        data that needs to be written to disk. It can either be a single
        startup item or the full JSON startup data.

        item_add (bool): Required. Specify whether the modified_json_data is to
        be added to orig_json_data or should replace some or all of it.

        orig_json_data (dict): Optional. A dictionary containing the original
        JSON data to be replaced or updated. If nothing is passed in, then it's
        blank by default.

    Returns:
        dict: A dictionary with the updated JSON data
    """
    # Create empty JSON object / Python dictionary
    temp_data = ENUM_JSS.OBJECT.value.copy()

    scenario_number = data_validation_scenario(
        modified_json_data, item_add, orig_json_data
    )

    if scenario_number == 0:
        return temp_data

    # Create empty JSON object / Python dictionary
    new_json_data = ENUM_JSS.OBJECT.value.copy()
    new_json_data[ENUM_JSK.TOTALITEMS.value] = 0
    new_json_data[ENUM_JSK.ITEMS.value] = ENUM_JSS.ARRAY.value.copy()

    # Start populating it
    total_items = orig_json_data["TotalItems"]
    new_json_data[ENUM_JSK.TOTALITEMS.value] = total_items

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
    # listed in the docstring above is the case
    data_validation = {
        "Add item": item_add,
        "Exists orig data": True if len(orig_json_data) > 0 else False,
        "Valid orig data": False,
        "Valid mod data": False,
        "Mod single item": False,
    }

    # If the orig_json_data dictionary isn't blank, check that it contains
    # properly formed data
    if data_validation[1]:
        data_validation[2] = deps_helper.startup_data_validator(orig_json_data)

    # Check if modified_json_data contains properly formed data
    if ENUM_JSK.TOTALITEMS.value in modified_json_data:
        # Full startup data
        data_validation[3] = deps_helper.startup_data_validator(modified_json_data)
    elif ENUM_JSK.ITEMNUMBER.value in modified_json_data:
        # Single startup item
        data_validation[3] = deps_helper.startup_data_validator(
            modified_json_data, True
        )
        data_validation[4] = True

    # Check for each of the 3 scenarios listed in the docstring:
    scenario_number, validation_results = match_scenario(data_validation)

    # If the validation failed, print the error message
    if scenario_number == 0:
        deps_pretty.prettify_custom_error(
            validation_results, "data_generate.generate_user_edited_data"
        )

    return scenario_number


def match_scenario(data_validation: dict):
    """A small helper function to perform the actual match-case block for
    the function data_validation_scenario. This function was created to split
    up the code and make is easier to read, test and maintain.

    Args:
        data_validation (dict): A dictionary containing the boolean values
        needed to validate the data for the function data_validation_scenario.

    Returns:
        tuple: Consists of an int and a string defined as follows:
                int: A scenario number that indicates which scenario is
                applicable. See the docstring for data_validation_scenario for
                more information.

                string: A message to print out if the validation failed.
    """
    scenario_number = 0
    validation_results = ""
    match data_validation:
        case {
            "Add item": False,
            "Exists orig data": True,
            "Valid orig data": True,
            "Valid mod data": True,
            "Mod single item": True,
        }:
            scenario_number = 1
        case {
            "Add item": False,
            "Exists orig data": False,
            "Valid mod data": True,
            "Mod single item": False,
        }:
            scenario_number = 2
        case {
            "Add item": True,
            "Exists orig data": True,
            "Valid orig data": True,
            "Valid mod data": True,
            "Mod single item": True,
        }:
            scenario_number = 3
        case {
            "Add item": True,
            "Exists orig data": True,
            "Valid orig data": True,
            "Valid mod data": True,
            "Mod single item": False,
        } | {
            "Add item": False,
            "Exists orig data": True,
            "Valid orig data": True,
            "Valid mod data": True,
            "Mod single item": False,
        }:
            validation_results = (
                "Expected a single startup item for the modified JSON data "
                "but didn't receive that. Cannot proceed."
            )
        case {
            "Add item": False,
            "Exists orig data": False,
            "Valid mod data": True,
            "Mod single item": True,
        }:
            validation_results = (
                "Expected full startup data for the modified JSON data but "
                "didn't receive that. Cannot proceed."
            )
        case {
            "Add item": True,
            "Exists orig data": True,
            "Valid orig data": True,
            "Valid mod data": False,
        } | {
            "Add item": False,
            "Exists orig data": True,
            "Valid orig data": True,
            "Valid mod data": False,
        } | {
            "Add item": False,
            "Exists orig data": False,
            "Valid mod data": False,
        }:
            validation_results = (
                "The modified JSON data passed in is not properly formed. "
                "Cannot proceed."
            )
        case {
            "Add item": True,
            "Exists orig data": True,
            "Valid orig data": False,
        } | {
            "Add item": False,
            "Exists orig data": True,
            "Valid orig data": False,
        }:
            validation_results = (
                "Original JSON data passed in is not properly formed. "
                "Cannot proceed."
            )
        case {
            "Add item": True,
            "Exists orig data": False,
        }:
            validation_results = (
                "Original JSON data cannot be found. Please provide original "
                "JSON data when adding a new startup item."
            )

    return (scenario_number, validation_results)
