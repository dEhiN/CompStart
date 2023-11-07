# Dependency to store the helper functions that are used to
# add a new startup item

from dependencies.imports import *
import demord as app_demord


def save_startup_item(modified_startup_item: dict, json_path: list, json_filename: str):
    """Helper function to save a modified startup item

    Args:
        modified_startup_item (dict): A dictionary with the single startup item, which
        will be saved to disk

        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be
        written to disk or a message that it was written successfully
    """
    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = app_demord.json_reader(
        json_path, json_filename
    )

    if status_state:
        # Get the item number of the startup item being worked with
        # and then the original version of that startup item
        modified_item_number = modified_startup_item["ItemNumber"]
        original_startup_item = json_data["Items"][modified_item_number - 1]

        # Check to see if the data was actually changed
        if modified_startup_item == original_startup_item:
            return (
                False,
                "\nThe startup data hasn't changed. There was nothing to save!",
            )

        deps_data_gen.generate_user_edited_data(modified_startup_item, json_data)
    else:
        pass

    return (status_state, status_message)


def add_startup_item_arguments_list(arg_list: list = []):
    """Helper function to allow the user to add arguments for a
    startup item

    Args:
        arg_list (list, optional): _description_. Defaults to [].

    Returns:
        list: A list containing the arguments the user added or
        blank if there aren't any
    """
    # For now, just return arg_list as is
    print(
        "\nUnable to add arguments to startup item. That functionality hasn't been"
        " implemented yet..."
    )

    return arg_list
