# Dependency to store the helper functions that are used to add a new startup item as well as save a startup item

import copy

import dependencies.data_generate as deps_data_gen
import dependencies.helper as deps_helper
import dependencies.chooser as deps_chooser
import dependencies.jsonfn as deps_json
import dependencies.enum as deps_enum

ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_ITV = deps_enum.ItemTypeVals


def add_startup_item():
    """Helper function to add, or create, a new startup item

    Args:
        None

    Returns:
        dict: The new startup item formed correctly and validated according to the startup_item.schema.json file.
    """
    print(
        "\nWelcome to the add a startup item section. In this section, you can set a name and description for the startup item. You can also choose the path of the program and set any parameters or arguments to pass to the program. An argument would be, for example, if you want to have a specific file immediately open in Microsoft Word on.\n\nWhen you choose from the menu below to set each section of the startup item, you will get an opportunity to confirm whatever you enter before it is saved. That means, for example, if you enter a name for the startup item and you don't like it, or you misspelled something, you will be able to correct it before the name is recorded. However, even if you decide you want to make changes afterward, you can always do so from the main menu by selecting the option to edit an existing startup item."
    )
    input("\nPress any key to continue...")
    menu_choices = [
        "Set the startup item name",
        "Set the startup item description",
        "Choose the startup item full program path",
        "Set any arguments for the startup item",
    ]
    user_choice = deps_chooser.user_menu_chooser(menu_choices, False)
    print(user_choice)
    pass


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

        user_menu = [
            f"Keep '{new_name}' as the name for this startup item and return to the previous menu",
            "Restart the naming process",
        ]

        user_choice = deps_chooser.user_menu_chooser(user_menu, False)

        if user_choice == 1:
            loop_quit = True

    return new_name


def add_startup_item_description():
    """Helper function to set the description for a startup item

    Args:
        None

    Returns:
        str: The new startup item description.
    """
    # Initialize function variables
    new_name = ""
    loop_quit = False

    # Loop until user enters a name
    while not loop_quit:
        new_description = input("\nPlease enter the description you would like to use: ")

        user_menu = [
            f"Keep the following as the description for this startup item and return to the previous menu: '{new_description}'",
            "Reenter the description",
        ]

        user_choice = deps_chooser.user_menu_chooser(user_menu, False)

        if user_choice == 1:
            loop_quit = True

    return new_description


def add_startup_item_program_path(item_name: str = "Startup Item"):
    """Helper function to set the path of a startup item

    Note: While the add functions for name and description allow the user to change what they initially entered via a loop, this add function doesn't. At present, it makes sense to only check for if the user didn't enter anything or make a choice, and loop in that case. However, there is argument for a scenario where a user chooses the wrong file by accident or enters the wrong path. For now, this function won't worry about that, which means the calling function will need to validate the user input.

    Args:
        item_name (str): Optional. The name of the startup item for which the user has to set the program path. If none is provided, the default will be "Startup Item".

    Returns:
        str: The new startup item absolute path
    """
    # Initialize function variables
    new_path = ""
    loop_quit = False
    check_blank = False

    # Loop until user chooses or enters a path
    while not loop_quit:
        user_menu = (
            f"[1] Use the file chooser window to select the program executable path for {item_name}\n"
            + f"[2] Enter the full path manually for {item_name}\n"
            + f"[3] Return to the previous menu without setting a path for {item_name}\n"
        )

        user_choice = deps_chooser.user_menu_chooser(user_menu, 3, False)

        match user_choice:
            case 1:
                new_path = deps_chooser.edit_file_chooser(item_name)
                check_blank = True
            case 2:
                input_msg = (
                    "\nPlease enter the new path to the program executable as an absolute path: "
                )
                new_path = input(input_msg)
                check_blank = True
            case 3:
                loop_quit = True

        if check_blank:
            if new_path:
                loop_quit = True
            else:
                print(
                    "\nPath cannot be blank! If you don't want to select a path, please choose menu option 3..."
                )
                check_blank = False

    return new_path


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


def save_startup_item(modified_startup_item: dict, json_path: list, json_filename: str):
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

    else:
        pass

    return (status_state, status_message)


"""
The below copy-pasted function definitions and doc strings from the startup_edit module are to be 
the template for creating the new functions in this module, startup_add.

Specifically the functions need to be redone as follows:

1. They each need to be renamed according to the following naming scheme (C = completed):
    edit_startup_item > add_startup_item
    edit_startup_item_name > add_startup_item_name (C)
    edit_startup_item_description > add_startup_item_description (C)
    edit_startup_item_program_path > add_startup_item_program_path (C)

2. The function definition needs to be refactored namely for the parameters list but also for the 
return variable (if need be)

3. The doc string for each function will need to be updated
"""
