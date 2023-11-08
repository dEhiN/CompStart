# Dependency to store the helper functions that are used to
# generate JSON data

from dependencies.imports import *

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
    doesn't fit. The following scenarios will be considered valid and will be
    checked for:

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

    # Validate the data before proceeding - see docstring for details
    valid_mod_data = False
    mod_data_num_keys = len(modified_json_data.keys())
    exists_orig_data = True if len(orig_json_data) > 0 else False
    validation_proceed = True
    validation_err_msg = ""

    # List of all valid keys in the full JSON startup data
    startup_keys_to_check = [ENUM_JSK.TOTALITEMS.value, ENUM_JSK.ITEMS.value]
    num_startup_keys = 2

    # List of all valid keys in a startup item dictionary
    item_keys_to_check = [
        ENUM_JSK.ITEMNUMBER.value,
        ENUM_JSK.NAME.value,
        ENUM_JSK.FILEPATH.value,
        ENUM_JSK.DESCRIPTION.value,
        ENUM_JSK.BROWSER.value,
        ENUM_JSK.ARGUMENTLIST.value,
        ENUM_JSK.ARGUMENTCOUNT.value,
    ]
    num_item_keys = 7

    # Check if modified_json_data contains properly formed data
    if ENUM_JSK.TOTALITEMS.value in modified_json_data:
        # Full startup data
        valid_mod_data = [
            True for key in startup_keys_to_check if key in modified_json_data
        ]
    elif ENUM_JSK.ITEMNUMBER.value in modified_json_data:
        # Startup item data
        valid_mod_data = [
            True for key in item_keys_to_check if key in modified_json_data
        ]

    # Check for each of the 3 scenarios listed in the docstring
    if valid_mod_data:
        if not item_add:
            # Scenarios 1 and 2
            if (exists_orig_data and mod_data_num_keys != num_item_keys) or (
                not exists_orig_data and mod_data_num_keys != num_startup_keys
            ):
                validation_proceed = False
                validation_err_msg = "The modified JSON data passed in is not properly formed. Cannot proceed."
        else:
            if not exists_orig_data:
                validation_proceed = False
                validation_err_msg = "Original JSON data cannot be found. Please provide original JSON data when updating."

    if not validation_proceed:
        deps_pretty.prettify_custom_error(
            validation_err_msg, "data_generate.generate_user_edited_data"
        )
        return temp_data

    # Create empty JSON object / Python dictionary
    new_json_data = ENUM_JSS.OBJECT.value.copy()
    new_json_data[ENUM_JSK.TOTALITEMS.value] = 0
    new_json_data[ENUM_JSK.ITEMS.value] = ENUM_JSS.ARRAY.value.copy()

    # Start populating it
    total_items = orig_json_data["TotalItems"]
    new_json_data[ENUM_JSK.TOTALITEMS.value] = total_items

    return new_json_data
