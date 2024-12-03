# Dependency to store the helper functions that are used to add a new startup item as well as save a startup item

import copy

import dependencies.cs_data_generate as deps_data_gen
import dependencies.cs_helper as deps_helper
import dependencies.cs_chooser as deps_chooser
import dependencies.cs_jsonfn as deps_json
import dependencies.cs_enum as deps_enum
import dependencies.cs_pretty as deps_pretty

ENUM_JSS = deps_enum.JsonSchemaStructure
ENUM_JSK = deps_enum.JsonSchemaKeys
ENUM_ITV = deps_enum.ItemTypeVals


def add_startup_item(last_item_num: int = -1):
    """Helper function to add, or create, a new startup item

    Args:
        last_item_num (int): An integer to use to keep track of the total number of existing startup items. When it's specified, the function will add 1 to this parameter and use that for the new startup item's ItemNumber property. If it's not specified, it will default to -1. This will trigger a call to the function get_count_total_items from the cs_helper module to track the total number of existing startup items. The function will then add 1 to that total. This will allow for a calling function to manipulate the ItemNumber property of the new startup item, if needed, but there is no validation currently done to confirm the value passed in is correct.

    Returns:
        dict: The new startup item formed correctly and validated according to the startup_item.schema.json file.
    """
    # Print out introduction to this section for creating a startup item
    # print("\nWelcome to Add a Startup Item. In this section, you can set a name and description for the startup item. You can also choose the path of the program and set any parameters or arguments to pass to the program. An argument would be, for example, if you want to have a specific file immediately open in Microsoft Word. After you add the startup item, if you made any mistakes in setting the details, you can use the other menu options to change any of the startup item details.")
    # input("\nPress any key to continue...")

    # Create blank JSON object / Python dictionary
    new_item = ENUM_JSS.OBJECT.value.copy()

    # Create keys with default values for a startup item
    new_item.update(
        {
            ENUM_JSK.ITEMNUMBER.value: 0,
            ENUM_JSK.NAME.value: "",
            ENUM_JSK.FILEPATH.value: "",
            ENUM_JSK.DESCRIPTION.value: "",
            ENUM_JSK.BROWSER.value: False,
            ENUM_JSK.ARGUMENTCOUNT.value: 0,
            ENUM_JSK.ARGUMENTLIST.value: ENUM_JSS.ARRAY.value,
        }
    )

    menu_choices = [
        "Create the startup item",
        "Edit the item name",
        "Edit the item description",
        "Edit the program path to the item",
        "Edit or add arguments to the item",
        "View the startup item",
        "Save the startup item",
        "Return to the previous menu",
    ]

    # Loop through to allow the user to create the startup item
    quit_loop = False
    while not quit_loop:
        user_choice = deps_chooser.user_menu_chooser(menu_choices, False)

        # Check to see if the user chose another option besides 1 but hasn't yet created a startup item
        if user_choice == len(menu_choices):
            # User has chosen to return to the previous menu
            quit_loop = True
        elif user_choice > 1 and new_item[ENUM_JSK.ITEMNUMBER.value] == 0:
            # Alert the user to create a startup item first
            print("\nPlease create a startup item first")
        else:
            # Continue on with regular execution
            match user_choice:
                case 1:
                    # Determine the next item number for this item
                    if last_item_num == -1:
                        curr_total_items = deps_helper.get_count_total_items()
                    else:
                        curr_total_items = last_item_num

                    # Add the Name, Description, FilePath, and ArgumentList parameters
                    startup_item_setup(new_item)

                    # Update the ItemNumber property
                    new_item[ENUM_JSK.ITEMNUMBER.value] = curr_total_items + 1

                    # Set the ArgumentCount property
                    arg_count = len(new_item[ENUM_JSK.ARGUMENTLIST.value])
                    new_item[ENUM_JSK.ARGUMENTCOUNT.value] = arg_count

                    # Adjust the Browser property, if need be
                    split_path = new_item[ENUM_JSK.FILEPATH.value].split("\\")
                    program_name = split_path[len(split_path) - 1].split(".")
                    browser_list = ["chrome", "msedge", "firefox"]
                    if program_name[0].lower() in browser_list:
                        new_item[ENUM_JSK.BROWSER.value] = True
                    else:
                        new_item[ENUM_JSK.BROWSER.value] = False
                case 2:
                    new_item[ENUM_JSK.NAME.value] = add_startup_item_name()
                case 3:
                    new_item[ENUM_JSK.DESCRIPTION.value] = add_startup_item_description()
                case 4:
                    new_item[ENUM_JSK.FILEPATH.value] = add_startup_item_program_path(
                        new_item[ENUM_JSK.NAME.value]
                    )
                case 5:
                    new_item[ENUM_JSK.ARGUMENTLIST.value] = add_startup_item_arguments_list()
                case 6:
                    startup_item = deps_pretty.prettify_startup_item(new_item)
                    print(startup_item)
                case 7:
                    file_path = deps_helper.get_prod_path()
                    file_name = deps_helper.get_startup_filename(default_json=False)
                    save_status, save_message = save_new_startup_item(
                        new_item, file_path, file_name
                    )
                    print(save_message)

    return copy.deepcopy(new_item)


def startup_item_setup(startup_item: dict):
    """Helper function to set a startup item's parameters

    Since Python passes by reference, the calling function can just pass in the dictionary it's working with and this function will directly update the values or, the startup item's parameters

    Args:
        startup_item (dict): The blank startup item to set up.
    """
    startup_item[ENUM_JSK.NAME.value] = add_startup_item_name()
    startup_item[ENUM_JSK.DESCRIPTION.value] = add_startup_item_description()
    startup_item[ENUM_JSK.FILEPATH.value] = add_startup_item_program_path(
        startup_item[ENUM_JSK.NAME.value]
    )
    startup_item[ENUM_JSK.ARGUMENTLIST.value] = add_startup_item_arguments_list()


def add_startup_item_name():
    """Helper function to set the name of a startup item

    Args:
        None

    Returns:
        str: The new startup item name.
    """
    new_name = ""
    while new_name == "":
        new_name = input("\nPlease enter the name you would like to use: ")
        if new_name == "":
            print("The item name cannot be blank")

    return new_name


def add_startup_item_description():
    """Helper function to set the description for a startup item

    Args:
        None

    Returns:
        str: The new startup item description.
    """
    new_description = ""
    while new_description == "":
        new_description = input("\nPlease enter the description you would like to use: ")
        if new_description == "":
            print("The item description cannot be blank")

    return new_description


def add_startup_item_program_path(item_name: str):
    """Helper function to set the path of a startup item

    Note: While the add functions for name and description allow the user to change what they initially entered via a loop, this add function doesn't. At present, it makes sense to only check for if the user didn't enter anything or make a choice, and loop in that case. However, there is argument for a scenario where a user chooses the wrong file by accident or enters the wrong path. For now, this function won't worry about that, which means the calling function will need to validate the user input.

    Args:
        item_name (str): Optional. The name of the startup item for which the user has to set the program path. If none is provided, the name will be set to "Startup Item".

    Returns:
        str: The new startup item absolute path
    """
    # Initialize function variables
    new_path = ""
    loop_quit = False

    if item_name == "":
        item_name = "Startup Item"

    # Loop until user chooses or enters a path
    while not loop_quit:
        user_menu = [
            f"Use the file chooser window to select the program path for {item_name}",
            f"Manually enter the program path for {item_name}",
        ]

        user_choice = deps_chooser.user_menu_chooser(user_menu, False)

        match user_choice:
            case 1:
                new_path = deps_chooser.existing_file_chooser(item_name)
            case 2:
                input_msg = (
                    "\nPlease enter the new path to the program executable as an absolute path: "
                )
                new_path = input(input_msg)

        if new_path == "":
            print("The program path cannot be blank")
        else:
            loop_quit = True

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
            new_argument = input(f"\nPlease type in argument {arg_num + 1}: ")

            # Check if the input exists
            if new_argument:
                quit_loop = True

                # Add the new argument to the argument list
                new_arg_list.append(new_argument)
                print('\nSuccessfully added "' + new_argument + '"!')
            else:
                print("The argument cannot be blank")

    return new_arg_list


def save_new_startup_item(new_startup_item: dict, json_path: list, json_filename: str):
    """Helper function to save a new startup item

    Args:
        new_startup_item (dict): A dictionary with the single startup item, which will be saved to disk

        json_path (list): A list containing the relative or absolute path to the JSON file with each list item representing one subfolder from Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if the JSON data was written successfully. False is the JSON data wasn't written successfully or if the existing data couldn't be read in successfully

        string: An error message to display if the JSON data couldn't be written to disk or the existing data couldn't be read in, or a message that it was written successfully
    """
    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = deps_json.json_reader(json_path, json_filename)

    if status_state:
        new_json_data = deps_data_gen.generate_user_edited_data(
            copy.deepcopy(new_startup_item),
            ENUM_ITV.ADD.value,
            copy.deepcopy(json_data),
        )

        data_file = deps_helper.parse_full_path(json_path, json_filename)
        status_state, status_message = deps_json.json_writer(data_file, 2, new_json_data)

    if not status_state:
        status_message = "Could not save the startup item"
        deps_pretty.prettify_custom_error(status_message, "save_new_startup_item")

    return (status_state, status_message)
