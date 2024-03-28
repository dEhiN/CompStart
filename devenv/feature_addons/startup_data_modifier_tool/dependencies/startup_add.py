# Dependency to store the helper functions that are used to add a new startup item as well as save a startup item

import copy

import dependencies.data_generate as deps_data_gen
import dependencies.helper as deps_helper
import dependencies.chooser as deps_chooser
import dependencies.jsonfn as deps_json
import dependencies.enum as deps_enum

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_ITV = deps_enum.ItemTypeVals


def add_startup_item_name():
    """Helper function to set the name of a startup item

    Args:
        None

    Returns:
        str: The new startup item name.
    """
    # Initialize function variables
    new_name = ""
    loop_quit = False

    # Loop until user enters a name
    while not loop_quit:
        new_name = input("\nPlease enter the name you would like to use: ")

        user_menu = (
            f"[1] Keep '{new_name}' as the name for this startup item and return to the previous menu\n"
            + "[2] Restart the naming process\n"
        )

        user_choice = deps_chooser.user_menu_chooser(user_menu, 2, False)

        if user_choice == 1:
            loop_quit = True

    return new_name


def add_startup_item_arguments_list(arg_list: list = []):
    """Helper function to allow the user to add arguments for a startup item

    Args:
        arg_list (list, optional): A list of the existing arguments. Defaults to [].

    Returns:
        list: A new list containing the arguments the user added appended to the existing list, if passed in.
    """

    new_arg_list = arg_list.copy()
    num_args = 0

    # Ask user how many arguments they want to add and loop until the user enters a valid integer
    while True:
        try:
            num_args = int(input("\nHow many arguments would you like to add? "))
        except ValueError:
            print("Please enter a valid number...")
            continue
        else:
            break

    for arg_num in range(num_args):
        # Loop until the user enters an actual argument
        quit_loop = False

        while not quit_loop:
            new_argument = input("\nPlease type in the new argument: ")

            # Check if the input exists
            if new_argument:
                quit_loop = True

                # Add the new argument to the argument list
                new_arg_list.append(new_argument)
                print('\nSuccessfully added "' + new_argument + '"!')
            else:
                print("Argument cannot be blank!")

    return new_arg_list


def save_startup_item(
    modified_startup_item: dict, json_path: list, json_filename: str
):
    """Helper function to save a modified startup item

    Args:
        modified_startup_item (dict): A dictionary with the single startup item, which will be saved to disk

        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the JSON data was written successfully. False is the JSON data wasn't written successfully or if the existing data couldn't be read in successfully

        string: An error message to display if the JSON data couldn't be written to disk or the existing data couldn't be read in, or a message that it was written successfully
    """
    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = deps_json.json_reader(
        json_path, json_filename
    )
    print("\n" + status_message)

    if status_state:
        # Get the item number of the startup item being worked with and then the original version of that startup item
        modified_item_number = modified_startup_item[ENUM_JSK.ITEMNUMBER.value]
        original_startup_item = json_data[ENUM_JSK.ITEMS.value][
            modified_item_number - 1
        ]

        # Check to see if the data was actually changed
        if modified_startup_item == original_startup_item:
            return (
                False,
                "\nThe startup data hasn't changed. There was nothing to save!",
            )

        new_json_data = deps_data_gen.generate_user_edited_data(
            copy.deepcopy(modified_startup_item),
            ENUM_ITV.REPLACE.value,
            copy.deepcopy(json_data),
        )

        data_file = deps_helper.parse_full_path(json_path, json_filename)
        status_state, status_message = deps_json.json_writer(
            data_file, 2, new_json_data
        )

    else:
        pass

    return (status_state, status_message)


"""
The below copy-pasted function definitions and doc strings from the startup_edit module are to be 
the template for creating the new functions in this module, startup_add.

Specifically the functions need to be redone as follows:

1. They each need to be renamed according to the following naming scheme:
    edit_startup_item > add_startup_item
    edit_startup_item_name > add_startup_item_name
    edit_startup_item_description > add_startup_item_description
    edit_startup_item_program_path > add_startup_item_program_path

2. The function definition needs to be refactored namely for the parameters list but also for the 
return variable (if need be)

3. The doc string for each function will need to be updated
"""
# def edit_startup_item(orig_startup_item: dict, json_path: list, json_filename: str):
#    """Helper function to edit a single startup item
#    This function will take the specific startup item passed in, display it and allow the user to edit any part of that item. A copy of the startup item dictionary is created to work with and that copy is what's returned.
#    Args:
#        orig_startup_item (dict): A dictionary with the single startup item
#        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)
#        json_filename (str): The filename of the JSON file
#    Returns:
#        dict: The modified and updated startup item dictionary passed in.
#    """

# def edit_startup_item_name(item_name: str):
#    """Helper function to change the name of a startup item
#    Args:
#        item_name (str): The existing startup item name
#    Returns:
#        str: The new startup item name
#    """

# def edit_startup_item_description(item_description: str):
#    """Helper function to change the description of a startup item
#    Args:
#        item_description (str): The existing startup item description
#    Returns:
#        str: The new startup item description
#    """

# def edit_startup_item_program_path(item_name: str, item_path: str):
#    """Helper function to change the path of a startup item
#    Args:
#        item_name (str): The existing startup item name
#        item_path (str): The existing startup item absolute path
#    Returns:
#        str: The new startup item absolute path
#    """
