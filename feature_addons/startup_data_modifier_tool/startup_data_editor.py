# This will be a command line tool to create and edit the startup_data.json
# file.

import json, os
from tkinter import filedialog as file_chooser
from program_files.enum_classes import JsonSchemaKeys as ec_jsk
from program_files.enum_classes import JsonSchemaStructure as ec_jss

# An example of valid startup_data.json data to use while coding
EXAMPLE_JSON = {
    "TotalItems": 1,
    "Items": [
        {
            "ItemNumber": 1,
            "Name": "Notepad",
            "FilePath": "notepad",
            "Description": "A text editor",
            "Browser": False,
            "ArgumentCount": 0,
            "ArgumentList": [],
        }
    ],
}

# A second example of startup data with more items
EXAMPLE_TWO = {
    "TotalItems": 3,
    "Items": [
        {
            "ItemNumber": 1,
            "Name": "Calculator",
            "FilePath": "calc",
            "Description": "A simple calculator",
            "Browser": False,
            "ArgumentCount": 0,
            "ArgumentList": [],
        },
        {
            "ItemNumber": 2,
            "Name": "Dealer-FX Homepage",
            "FilePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
            "Description": "The DFX homepage",
            "Browser": True,
            "ArgumentCount": 3,
            "ArgumentList": [
                "--profile-directory=Default",
                "--new-window",
                "https://www.dealer-fx.com/",
            ],
        },
        {
            "ItemNumber": 3,
            "Name": "Notepad",
            "FilePath": "notepad",
            "Description": "A text editor",
            "Browser": False,
            "ArgumentCount": 0,
            "ArgumentList": [],
        },
    ],
}


def check_overwrite(json_file: str):
    """Helper function to confirm before overwriting the startup file

    If a startup file already exists, this function will check to see if the
    user would like to overwrite it. This function assumes the file exists and
    doesn't check for that.

    Args:
        json_file (str): The file that will be overwritten

    Returns:
        bool: True if user would like to overwrite the existing file, False
        otherwise
    """

    # Loop until user gives a valid response
    quit_loop = False
    overwrite_file = False

    exists_message = f"\n{json_file} already exists!"
    input_message = "Would you like to completely overwrite this file [Y/N]? "
    while not quit_loop:
        # Get user input and validate it
        print(exists_message)
        user_choice = input(input_message)

        if user_choice.upper() == "Y" or user_choice.upper() == "N":
            if user_choice.upper() == "Y":
                overwrite_file = True

            quit_loop = True

    return overwrite_file


def choose_file(item_name: str):
    """Helper function to show a file dialog box

    Args:
        item_name: The existing startup item name

    Returns:
        str: The full path of the file that was selected
    """
    file_name = file_chooser.askopenfilename(
        initialdir="C:/Program Files/",
        title="Choose the program executable for {}".format(item_name),
    )
    return file_name


def parse_full_path(json_path: list, json_filename: str):
    """Helper function to parse the path components to a JSON file

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        string: The full absolute path with filename of the JSON file
    """

    # Get the full path to the JSON file
    full_path = os.getcwd()
    for item in json_path:
        full_path += os.sep + os.path.join(item)

    # Add the full path and JSON filename together
    json_file = full_path + os.sep + json_filename

    return json_file


def edit_startup_path(item_name: str, item_path: str):
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
            new_path = choose_file(item_name)
        elif user_choice.upper() == "N":
            input_msg = "Please enter the new path to the program executable in full or press enter to use the existing path: "
            new_path = input(input_msg)

    if new_path == "":
        print("\nNo change was made...")
        new_path = item_path

    return new_path


def edit_startup_description(item_description: str):
    """Helper function to change the description of a startup item

    Args:
        item_description (str): The existing startup item description

    Returns:
        str: The new startup item description
    """
    print("\nThe current description for this startup item is:", item_description)
    new_description = input(
        "Please enter a new description or press enter to leave the existing description: "
    )

    if new_description == "":
        print("\nNo change was made...")
        new_description = item_description

    return new_description


def edit_startup_name(item_name: str):
    """Helper function to change the name of a startup item

    Args:
        item_name (str): The existing startup item name

    Returns:
        str: The new startup item name
    """
    print("\nThe current name for this startup item is:", item_name)
    new_name = input(
        "Please enter a new name or press enter to leave the existing name: "
    )

    if new_name == "":
        print("\nNo change was made...")
        new_name = item_name

    return new_name


def edit_startup_item(startup_item: dict):
    """Helper function to edit a single startup item

    This function will take the specific startup item passed in, display it and
    allow the user to edit any part of that item

    Args:
        startup_item (dict): A dictionary with the single startup item

    Returns:
        ##TODO##
    """
    # Show startup item selected
    prettified_item = prettify_startup_item(startup_item)
    print(prettified_item)

    # Loop through to and ask the user what they want to do
    quit_loop = False

    user_choices = (
        "Choose one of the following item properties to edit, or type R to return to the previous screen:\n"
        "[1] Item name\n"
        "[2] Item description\n"
        "[3] Item program path\n"
        "[4] Item arguments\n"
    )
    max_choices = 4

    while not quit_loop:
        print("\n" + user_choices)
        user_choice = input("What would you like to do? ")

        # Validate input
        valid_choice = (user_choice.isalpha() and user_choice.upper() == "R") or (
            user_choice.isnumeric()
            and int(user_choice) >= 1
            and int(user_choice) <= max_choices
        )

        if not valid_choice:
            print("\nPlease enter a valid choice\n")
        elif user_choice.isalpha():
            quit_loop = True
        else:
            # User chose a valid option, process accordingly
            user_choice = int(user_choice)

            match user_choice:
                case 1:
                    startup_item["Name"] = edit_startup_name(startup_item["Name"])
                    print(prettify_startup_item(startup_item))
                case 2:
                    startup_item["Description"] = edit_startup_description(
                        startup_item["Description"]
                    )
                    print(prettify_startup_item(startup_item))
                case 3:
                    startup_item["FilePath"] = edit_startup_path(
                        startup_item["Name"], startup_item["FilePath"]
                    )
                    print(prettify_startup_item(startup_item))
                case _:
                    print(startup_item)
                    print("That functionality hasn't been implemented yet...")


def prettify_error(error: Exception, file_mode: str = ""):
    """Helper function to prettify an error or exception

    This function will take an Exception and create a more human-readable
    output for the error

    Args:
        error (Exception): The Exception that was caught (might be most likely
        through a try-except block).

        file_mode (str, optional): If the Exception was caught while working
        with files, this parameter will tell which file mode or what action was
        being taken. Acceptable values are "r" for reading, "w" for writing.
        Defaults to "". If the default value is used or a non-acceptable value
        is used, only the Exception will be returned without any extra
        messaging.

    Returns:
        str: The Exception printed out in a way that makes sense
    """
    return_message = ""
    match file_mode:
        case "r":
            return_message += "Unable to read startup data. Error information is below:\n"
        case "w":
            return_message += (
                "Unable to write startup data. Error information is below:\n"
            )
        case _:
            pass
    return_message += str(type(error).__name__) + " - " + str(error)
    return return_message


def prettify_startup_item(startup_item: dict):
    """Helper function to prettify the passed-in JSON data

    This function will go through the JSON data dictionary and format the data
    to display it in a human readable manner

    Args:
        startup_item (dict): A dictionary representing the JSON data for one startup item.

    Returns:
        str: The startup item JSON data in a nicely formatted manner as a string
    """
    # Used to add a new line or tab
    line = "\n"
    tab = "\t"

    startup_data = ""

    # Add the startup item number
    startup_data += line + line + "Startup item #" + str(startup_item["ItemNumber"])

    # Add the startup item name
    startup_data += line + tab + "Item name: " + startup_item["Name"]

    # Add the startup description
    startup_data += line + tab + "Item description: " + startup_item["Description"]

    # Add the file path
    startup_data += line + tab + "Item program path: " + startup_item["FilePath"]

    # Add any argument information
    startup_data += line + tab + "Does this item use arguments: "
    arg_count = startup_item["ArgumentCount"]
    if arg_count > 0:
        startup_data += "Yes"

        # Get the total number of arguments
        startup_data += line + tab + "Total number of arguments used: " + str(arg_count)
        arg_list = startup_item["ArgumentList"]

        # Go through each argument
        if arg_count >= 2:
            counter = 0
            for argument in arg_list:
                counter += 1
                if type(argument) == list:
                    argument = " ".join(argument)

                startup_data += (
                    line
                    + tab
                    + tab
                    + "Argument "
                    + str(counter)
                    + ": "
                    + '"'
                    + argument
                    + '"'
                )
        else:
            startup_data += line + tab + tab + "Argument: " + '"' + arg_list + '"'
    else:
        startup_data += "No"

    return startup_data


def prettify_json(json_data: dict):
    """Helper function to prettify the passed-in JSON data

    This function will go through the JSON data dictionary and format the data
    to display it in a human readable manner

    Args:
        json_data (dict): The JSON data to prettify

    Returns:
        str: The JSON data in a nicely formatted manner as a string
    """
    # Create and initialize our function variables
    pretty_data = ""
    total_items = json_data["TotalItems"]
    items_list = json_data["Items"]

    # Start populating pretty_data
    pretty_data += "Number of startup items: " + str(total_items)

    # Go through all the startup items
    for i in range(total_items):
        # Get the specific startup item
        item = items_list[i]

        # Prettify the startup item data
        pretty_data += prettify_startup_item(item)

    return pretty_data


def generate_user_edited_data(**kwargs):
    """Helper function to create JSON data from **kwargs parameter

    As of 09/08/23:
    Haven't yet decided how **kwargs parameter will be structured, but it will
    most likely either be a dictionary itself, or a list of strings.

    Args:
        **kwargs: Optional parameters that contain new JSON data

    Returns:
        dict: The same dictionary passed in but now filled with JSON data
    """

    # For now return a blank dictionary
    return {}


def generate_default_startup_data():
    """Helper function to create default startup data

    The default startup data opens notepad and contains what's in EXAMPLE_JSON.

    Returns:
        dict: A dictionary of JSON startup data
    """

    # Create empty JSON object / Python dictionary
    json_data = ec_jss.OBJECT.value.copy()

    """
    Populate the dictionary with the keys and values specified in the 
    docstring. Use the Enum class JsonSchemaKey through the variable ec_jsk to 
    populate the keys. Use the Enum class JsonSchemaStructure through the 
    variable ec_jss to create a Python dictionary for a JSON object and a 
    Python list for a JSON array when called for. Because of how Python passes 
    mutable data types, when using the ec_jss members, a copy has to be made of
    the member value. Additionally, in order to make the code easier to read 
    and follow, the variables json_arr and json_items are used as reference 
    aliases.
    """
    json_data[ec_jsk.TOTALITEMS.value] = 1
    json_data[ec_jsk.ITEMS.value] = ec_jss.ARRAY.value.copy()
    json_arr = json_data[ec_jsk.ITEMS.value]
    json_arr.append(ec_jss.OBJECT.value.copy())
    json_items = json_arr[0]
    json_items[ec_jsk.ITEMNUMBER.value] = 1
    json_items[ec_jsk.NAME.value] = "Notepad"
    json_items[ec_jsk.FILEPATH.value] = "notepad"
    json_items[ec_jsk.DESCRIPTION.value] = "A text editor"
    json_items[ec_jsk.BROWSER.value] = False
    json_items[ec_jsk.ARGUMENTCOUNT.value] = 0
    json_items[ec_jsk.ARGUMENTLIST.value] = ec_jss.ARRAY.value.copy()

    return json_data


def generate_user_startup_data():
    # For now return a blank dictionary
    return {}


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


def json_editor(json_path: list, json_filename: str):
    """Function to allow the user to edit existing JSON data

    This function will display the existing JSON data and then allow the
    user to edit each startup item one at a time, including delete startup
    items and add new ones

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        ##TODO##
    """
    # Read in existing JSON file and store the return results of the json_read function
    status_state, status_message, json_data = json_reader(json_path, json_filename)

    print(f"\n{status_message}")

    # If the data was read in successfully, display it when the user is ready
    if status_state:
        # input("Press any key when ready to see the startup data...")

        # Get the total items
        total_items = json_data["TotalItems"]
        items = json_data["Items"]
        # print(f"\n{prettify_json(json_data)}")

        # Print out the total number of items and list each startup item
        print(f"\nNumber of startup items: {total_items}")
        # for i in range(total_items):
        #    print(f"Startup item # {i + 1}")

        # Loop through to allow the user to edit the JSON data until they are ready
        # to return to the main menu
        quit_loop = False
        while not quit_loop:
            user_choice = input(
                "\nEnter the startup item number you want to edit"
                + f" [1-{total_items}]"
                + ", type A to add a new startup item"
                + ", type D to delete a startup item"
                + ", or type Q to return to the main menu: "
            )

            # Confirm the user entered a valid choice
            valid_choice = (
                user_choice.isalpha() and user_choice.upper() in ["Q", "A", "D"]
            ) or (
                user_choice.isnumeric()
                and int(user_choice) >= 1
                and int(user_choice) <= total_items
            )

            if not valid_choice:
                print("Please enter a valid choice")
            else:
                # Format the user input for the match-case block
                if user_choice.isalpha():
                    user_choice = user_choice.upper()
                else:
                    user_choice = int(user_choice) - 1

                match user_choice:
                    case "Q":
                        quit_loop = True
                    case "A":
                        print("That functionality hasn't yet been implemented!")
                    case "D":
                        print("That functionality hasn't yet been implemented")
                    case _:
                        # TODO Add ability to edit a startup item
                        edit_startup_item(items[user_choice])


def json_writer(json_file: str, file_state: int, json_data: dict):
    """Function to write the actual JSON data to file

    Based on the value of the file_state variable, the file to be written is
    handled differently:

    0 - The file doesn't exist and mode "w" is to be used
    1 - The file exists but mode "w" is to be used so first need to confirm is
        user is alright with overwriting existing file
    2 - The file exists but the JSON data needs to be updated; see note below

    Note: Initially, the plan was to open the file in "append" mode when
    'file_state' is 2, but this doesn't work. Due to how the 'json.dump'
    function writes JSON data, it's not possible to just append newer JSON
    data to an existing file. As a result, existing startup JSON data will
    need to be read in, any modifications made - such as adding new startup
    data or editing existing startup data, and then written back to the file
    by overwriting what exists. However, this function will not be responsible
    for modifying any JSON data. This function will assume that 'json_data'
    contains the correct startup JSON data and if a 'file_state' of 2 is passed
    in, this function will overwrite the existing file data.

    Args:
        json_file (str): The full absolute path of the JSON file including
        filename and extension

        file_state (int): An indicator of how the file to be written should be
        handled. See extended summary above.

        json_data (dict): The JSON data to write to file. See note above.

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be
        written to disk or a message that it was written successfully
    """

    # Initialize return variables
    write_json_success = False
    return_message = "Startup file written successfully!"
    file_mode = ""

    # Check for valid file_state value
    match file_state:
        case 0:
            # Write JSON data to file
            file_mode = "w"
        case 1:
            # Check if user wants to overwrite the existing file
            if check_overwrite(json_file):
                # Write JSON data to file
                file_mode = "w"
            else:
                return_message = "Skipped writing startup file!"
        case 2:
            # Check to see if the current JSON data in the file is different
            # from json_data
            try:
                with open(json_file, "r") as file:
                    existing_data = json.load(file)
            except Exception as error:
                existing_data = json_data
                return_message = prettify_error(error, "r")

            if not json_data == existing_data:
                file_mode = "w"
            else:
                return_message = (
                    "Existing startup data and new startup data are the same. Not"
                    + f" updating {json_file} because there is no point."
                )
        case _:
            return_message = (
                "Invalid file state! Could not write startup data. Please try again."
            )

    # Write to file if needed
    if not file_mode == "":
        try:
            with open(json_file, file_mode) as file:
                json.dump(json_data, file)

            # Created file successfully
            write_json_success = True
        except Exception as error:
            return_message = prettify_error(error, file_mode)

    return write_json_success, return_message


def json_reader(json_path: list, json_filename: str):
    """Function to read in JSON data from a file

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

    Returns:
        bool: True if there is JSON data to return, False if not

        string: An error message to display if there's no JSON data to return
        or blank otherwise

        dict: The actual JSON data if there is any to return or an empty
        dictionary if not
    """

    # Create return values
    read_json_success = False
    return_message = "Startup data read in successfully!"
    json_data = {}

    # Split the filename into its components of name and extension
    split_filename = json_filename.split(".")

    # Validate if correct JSON file
    if len(split_filename) == 1:
        # The filename has no extension component
        return_message = "Please specify a valid startup file name"
    else:
        # Grab the extension
        last_item = split_filename[len(split_filename) - 1]

        # Check the extension is "json"
        if last_item != "json":
            return_message = (
                "Invalid startup file name.\n"
                f"Received extension of: .{last_item}\n"
                "Expected extension of: .json"
            )
        else:
            # Get the full path to the file in string format
            json_file = parse_full_path(json_path, json_filename)

            # Read in JSON data
            try:
                with open(json_file, "r") as json_file:
                    json_data = json.load(json_file)

                # Read was successful
                read_json_success = True
            except Exception as error:
                return_message = prettify_error(error, "r")

    return read_json_success, return_message, json_data


def json_creator(json_path: list, json_filename: str, default_mode: bool):
    """Function to create a new JSON file

    There are two possibilities here:

        1) The user wants to use the default startup data for creating a new file
        2) The user wants to specify the data themselves

    The third argument or parameter passed in will tell this function which is the case

    Args:
        json_path (list): A list containing the relative or absolute path to
        the JSON file with each list item representing one subfolder from
        Current Working Directory (CWD)

        json_filename (str): The filename of the JSON file

        default_mode (bool): If True, create a new file with startup data. If False,
                            allow the user to specify their own startup data.

    Returns:
        bool: True if the JSON data was written successfully, False if not

        string: An error message to display if the JSON data couldn't be
        written to disk or a message that it was written successfully
    """

    # Initialize variables
    write_json_success = False
    return_message = ""
    file_state = 0

    # Get the full path to the file in string format
    json_file = parse_full_path(json_path, json_filename)

    # Create default JSON data to add to the startup_data.json file
    json_data = dict(generate_json_data(new_file=True, is_default=default_mode))

    # If the file exists, make sure we confirm from the user before overwriting
    # the file
    if os.path.isfile(json_file):
        file_state = 1

    # Write the file to disk and get the return values
    write_json_success, return_message = json_writer(json_file, file_state, json_data)

    return write_json_success, return_message


def set_startdir():
    dirs_list = os.getcwd().split(os.sep)
    len_dirs_list = len(dirs_list) - 1
    start_dir = "CompStart"

    if start_dir in dirs_list:
        idx_start_dir = dirs_list.index(start_dir)

        if len_dirs_list == idx_start_dir:
            return
        else:
            num_dirs_diff = len_dirs_list - idx_start_dir
            while num_dirs_diff > 0:
                os.chdir("..")
                num_dirs_diff -= 1


if __name__ == "__main__":
    # Set the starting directory
    set_startdir()

    # Variable to switch between testing and prod environments
    is_prod = False

    # Variables for location and name of JSON file with startup data
    json_path = []
    json_filename = ""

    if is_prod:
        json_path.extend(["data", "json_data"])
        json_filename = "startup_data.json"
    else:
        json_path.extend(
            ["feature_addons", "startup_data_modifier_tool", "program_files"]
        )
        json_filename = "test_data.json"

    # Main loop to allow user to navigate program options
    quit_loop = False

    user_choices = (
        "Choose one of the following:\n"
        "[1] Create a new startup file with defaults\n"
        "[2] Create a new startup file with your own values\n"
        "[3] View the existing startup file\n"
        "[4] Edit the existing startup file\n"
        "[5] Quit the program\n"
    )
    max_choices = 5

    # Initialize status variables
    status_state = False
    status_message = "No action taken..."

    while not quit_loop:
        print("\n" + user_choices)
        user_choice = input("What would you like to do? ")

        # Validate input
        if (
            not user_choice.isnumeric()
            or int(user_choice) < 1
            or int(user_choice) > max_choices
        ):
            print("\nPlease enter a valid choice\n")
        else:
            # User chose a valid option, process accordingly
            user_choice = int(user_choice)

        match user_choice:
            case 1, 2:
                # Create a new JSON file
                is_default = False
                if user_choice == 1:
                    is_default = True
                status_state, status_message = json_creator(
                    json_path, json_filename, is_default
                )
                print(f"\n{status_message}")
            case 3:
                # Read in existing JSON file and store the return results of the
                # json_read function
                status_state, status_message, json_data = json_reader(
                    json_path, json_filename
                )

                print(f"\n{status_message}\n")
                input("Press any key to view the startup data...")

                # If there was data read in, print it out in a prettified way
                if status_state:
                    print(prettify_json(json_data))
                    input("\nPress any key to continue...")
            case 4:
                json_editor(json_path, json_filename)
            case 5:
                quit_loop = True

        # Print the status message if user isn't exiting the program
        if quit_loop:
            print("\nThank you for using CompStart. Have a wonderful day.")
