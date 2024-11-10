# Dependency to store the helper functions that are used when editing a startup item

import copy

import dependencies.data_generate as deps_data_gen
import dependencies.helper as deps_helper
import dependencies.chooser as deps_chooser
import dependencies.jsonfn as deps_json
import dependencies.enum as deps_enum
import dependencies.pretty as deps_pretty
import dependencies.startup_add as deps_item_add

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_ITV = deps_enum.ItemTypeVals


def edit_startup_item(orig_startup_item: dict, json_path: list, json_filename: str):
    """Helper function to edit a single startup item

    This function will take the specific startup item passed in, display it and allow the user to edit any part of that item. A copy of the startup item dictionary is created to work with and that copy is what's returned.

    Args:
        orig_startup_item (dict): A dictionary with the single startup item

        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        dict: The modified and updated startup item dictionary passed in.
    """
    # Create a copy of the orig_startup_item dictionary
    startup_item = copy.deepcopy(orig_startup_item)

    # Show startup item selected
    prettified_item = deps_pretty.prettify_startup_item(startup_item)
    print(prettified_item)
    input("\nPress enter when ready to continue...")

    # Loop through to and ask the user what they want to do
    menu_choices = [
        "Edit item name",
        "Edit item description",
        "Edit item program path",
        "Edit or add item arguments",
        "View startup item",
        "Save startup item data to disk",
        "Return to the previous menu",
    ]
    quit_loop = False

    while not quit_loop:
        user_choice = deps_chooser.user_menu_chooser(menu_choices)

        match user_choice:
            case 1:
                startup_item[ENUM_JSK.NAME.value] = edit_startup_item_name(
                    startup_item[ENUM_JSK.NAME.value]
                )
            case 2:
                startup_item[ENUM_JSK.DESCRIPTION.value] = edit_startup_item_description(
                    startup_item[ENUM_JSK.DESCRIPTION.value]
                )
            case 3:
                startup_item[ENUM_JSK.FILEPATH.value] = edit_startup_item_program_path(
                    startup_item[ENUM_JSK.NAME.value], startup_item[ENUM_JSK.FILEPATH.value]
                )
            case 4:
                arg_count = startup_item[ENUM_JSK.ARGUMENTCOUNT.value]
                temp_arg_list = []

                # Check if startup item has arguments
                if arg_count > 0:
                    temp_arg_list = edit_startup_item_arguments_list(
                        True, startup_item[ENUM_JSK.ARGUMENTLIST.value]
                    ).copy()
                else:
                    temp_arg_list = edit_startup_item_arguments_list(False)

                # Update the startup_item dictionary
                startup_item[ENUM_JSK.ARGUMENTCOUNT.value] = len(temp_arg_list)
                startup_item[ENUM_JSK.ARGUMENTLIST.value] = temp_arg_list.copy()
            case 5:
                print(deps_pretty.prettify_startup_item(startup_item))
            case 6:
                write_status, return_message = save_modified_startup_item(
                    startup_item, json_path, json_filename
                )

                if not write_status:
                    print(return_message)
            case 7:
                quit_loop = True

    return copy.deepcopy(startup_item)


def edit_startup_item_name(item_name: str):
    """Helper function to change the name of a startup item

    Args:
        item_name (str): The existing startup item name

    Returns:
        str: The new startup item name
    """
    print("\nThe current name for this startup item is:", item_name)
    new_name = input("Please enter a new name or press enter to leave the existing name: ")

    if not new_name:
        print("\nNo change was made...")
        new_name = item_name

    return new_name


def edit_startup_item_description(item_description: str):
    """Helper function to change the description of a startup item

    Args:
        item_description (str): The existing startup item description

    Returns:
        str: The new startup item description
    """
    print("\nThe current description for this startup item is:", item_description)
    new_description = input(
        "Please enter a new description or press enter to leave the existing" " description: "
    )

    if not new_description:
        print("\nNo change was made...")
        new_description = item_description

    return new_description


def edit_startup_item_program_path(item_name: str, item_path: str):
    """Helper function to change the path of a startup item

    Args:
        item_name (str): The existing startup item name
        item_path (str): The existing startup item absolute path

    Returns:
        str: The new startup item absolute path
    """
    new_path = ""
    print("\nThe current file path for this startup item is:", item_path)
    user_choice = input(
        "Would you like to use the file chooser window to select the new file path [Y/N]? "
    )

    if user_choice.isalpha():
        if user_choice.upper() == "Y":
            new_path = deps_chooser.existing_file_chooser(item_name)
        elif user_choice.upper() == "N":
            input_msg = (
                "Please enter the new path to the program executable in full"
                " or press enter to use the existing path: "
            )
            new_path = input(input_msg)

    if not new_path:
        print("\nNo change was made...")
        new_path = item_path

    return new_path


def edit_startup_item_arguments_list(args_exist: bool, arg_list: list = []):
    """Helper function to change the arguments list of a startup item

    If there are no arguments, this function will ask the user if they want to add arguments. If
    there are arguments, this function will allow the user to edit, delete, or add arguments. It
    does so all within this function and only calls add_startup_arguments if there are no arguments and the user wants to add some.

    Args:
        args_exist (bool): Required to let the function know if there are arguments.

        arg_list (list, optional): A list of the arguments. Defaults to [].

    Returns:
        list: A list containing the edited startup items, including any additions or deletions. If there aren't any arguments, an empty list is returned.
    """
    new_arg_list = arg_list.copy()
    new_argument = ""
    arg_count = len(arg_list)

    # Check if there are existing arguments
    if args_exist and arg_count > 0:
        # Loop through the menu until the user cancels
        quit_loop = False
        while not quit_loop:
            # Create a menu listing all the arguments
            item_menu = []
            for index in range(0, arg_count):
                item_menu.append(f"Edit argument {index + 1}: {new_arg_list[index]}")

            # Generate the full menu
            add_choice = arg_count + 1
            delete_choice = arg_count + 2
            cancel_choice = arg_count + 3
            menu_footer = [
                "Add a new argument",
                "Delete an argument",
                "Return to the previous menu",
            ]
            item_menu.extend(menu_footer)

            # Find out what the user wants to do
            user_choice = deps_chooser.user_menu_chooser(item_menu, False)

            # Depending on user choice, perform the next action
            if user_choice == cancel_choice:
                # User chose to cancel out of this menu
                quit_loop = True
            elif user_choice == add_choice:
                # User chose to add a new argument
                new_arg_list = deps_item_add.add_startup_item_arguments_list(new_arg_list).copy()
                arg_count = len(new_arg_list)
            elif user_choice == delete_choice:
                # User chose to delete an existing argument

                # Generate delete menu listing all the arguments
                delete_menu = []
                for index in range(0, arg_count):
                    delete_menu.append(f"Remove argument {index + 1}: {new_arg_list[index]}")
                cancel_choice = arg_count + 1
                delete_menu.append("Cancel deletion")

                # Find out what the user wants to do
                user_choice = deps_chooser.user_menu_chooser(delete_menu, False)

                if user_choice < cancel_choice:
                    # User chose a specific argument to delete
                    # Calculate which list index we're working with
                    changed_argument_index = user_choice - 1
                    try:
                        deleted_arg = new_arg_list.pop(changed_argument_index)
                        arg_count = len(new_arg_list)
                        print('\nSuccessfully deleted "' + deleted_arg + '"!')
                    except IndexError:
                        print(
                            "\nUnable to delete argument "
                            + deleted_arg
                            + ". Encountered an IndexError."
                        )
            elif user_choice > 0 and user_choice < arg_count + 1:
                # User chose to edit an existing argument
                new_argument = input(
                    "Please enter the replacement argument or press enter to cancel: "
                )

                if not new_argument:
                    print("\nNo change was made...")
                    continue

                # Calculate which list index we're working with
                changed_argument_index = user_choice - 1

                # Edit the existing argument and update the argument list menu
                new_arg_list[changed_argument_index] = new_argument
    else:
        # Check if user wants to add arguments
        user_choice = input(
            "There are currently no arguments. Would you like to add some" " arguments (Y/[N])? "
        )

        if user_choice.isalpha() and user_choice.upper() == "Y":
            new_arg_list = deps_item_add.add_startup_item_arguments_list().copy()
        else:
            print("\nNo change was made...")
            new_arg_list = arg_list.copy()

    return new_arg_list


def save_modified_startup_item(modified_startup_item: dict, json_path: list, json_filename: str):
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
    status_state, status_message, json_data = deps_json.json_reader(json_path, json_filename)
    print("\n" + status_message)

    if status_state:
        # Get the item number of the startup item being worked with and then the original version of that startup item
        modified_item_number = modified_startup_item[ENUM_JSK.ITEMNUMBER.value]
        original_startup_item = json_data[ENUM_JSK.ITEMS.value][modified_item_number - 1]

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
        status_state, status_message = deps_json.json_writer(data_file, 2, new_json_data)

    return (status_state, status_message)

    # def testing_shortcut_arguments_list(arg_list: list, is_add: bool):
    """A helper function to automatically add or delete an argument from the arguments list passed in. This is so we can shortcut the steps needed to update an arguments list for testing, such as testing the save function, etc.

    Args:
        arg_list (list): Required. The list of existing arguments.

        is_add (bool): Required. Specifies whether to add an argument or delete one.

    Returns:
        list: A list containing the edited or added startup items.
    """
    new_arg_list = arg_list

    if is_add:
        new_arg_list.append("test argument")
    else:
        if len(new_arg_list) > 0:
            new_arg_list.pop()

    return new_arg_list
