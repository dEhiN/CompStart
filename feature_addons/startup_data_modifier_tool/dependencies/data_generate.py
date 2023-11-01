# Dependency to store the helper functions that are used to
# generate JSON data

from dependencies.helper import DEFAULT_JSON
from dependencies.enum import JsonSchemaKeys as ec_jsk
from dependencies.enum import JsonSchemaStructure as ec_jss


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


def generate_user_edited_data(**kwargs):
    """Helper function to create JSON data from **kwargs parameter

    Creates a dictionary with keys and values taken from **kwargs. Uses the
    Enum class JsonSchemaKey through the variable ec_jsk to populate the keys.
    Uses the Enum class JsonSchemaStructure through the variable ec_jss to
    create a Python dictionary for a JSON object and a Python list for a JSON
    array when called for. Because of how Python passes mutable data types,
    when using the ec_jss members, a copy has to be made of the member value.

    As of 09-Aug-23:
    Haven't yet decided how **kwargs parameter will be structured, but it will
    most likely either be a dictionary itself, or a list of strings.

    Args:
        **kwargs: Optional parameters that contain new JSON data

    Returns:
        dict: A dictionary with the updated JSON data
    """

    # Create empty JSON object / Python dictionary
    temp_data = ec_jss.OBJECT.value.copy()

    # For now return a blank dictionary
    return temp_data


def generate_default_startup_data():
    """Helper function to create default startup data

    The default startup data opens 3 programs at startup - notepad, calculator and
    Chrome to www.google.com.

    Returns:
        dict: A dictionary of JSON startup data
    """

    return DEFAULT_JSON


def generate_user_startup_data():
    """Helper function to create startup data that the user chooses

    Currently, this function just returns a JSON object with no startup data

    Returns:
        dict: A dictionary of JSON startup data
    """
    # Create empty JSON object / Python dictionary
    json_data = ec_jss.OBJECT.value.copy()
    json_data[ec_jsk.TOTALITEMS.value] = 0
    json_data[ec_jsk.ITEMS.value] = ec_jss.ARRAY.value.copy()

    print(
        "This functionality hasn't been fully implemented yet. Creating blank"
        " startup file..."
    )

    return json_data
