# Dependency to store the helper functions that are used to
# add a new startup item

import copy

import dependencies.data_generate as deps_data_gen
import dependencies.pretty as deps_pretty
import dependencies.helper as deps_helper
import dependencies.jsonfn as deps_json
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
    status_state, status_message, json_data = deps_json.json_reader(
        json_path, json_filename
    )
    print("\n" + status_message)

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

        new_json_data = deps_data_gen.generate_user_edited_data(
            copy.deepcopy(modified_startup_item),
            False,
            copy.deepcopy(json_data),
        )

        if not app_demord.is_production():
            print(
                "Testing environment found: Printing output of save_startup_item to text file"
            )

            # For testing purposes, print the various dictionaries to a file for
            # easier comparison
            test_file_output = ""

            test_file_output += "The original startup data:\n"
            test_file_output += deps_pretty.prettify_json(json_data)

            test_file_output += "\n\nThe original startup_item:\n"
            test_file_output += deps_pretty.prettify_startup_item(original_startup_item)

            test_file_output += "\n\nThe modified startup item:\n"
            test_file_output += deps_pretty.prettify_startup_item(modified_startup_item)

            test_file_output += (
                "\n\nThe new JSON data created by generate_user_edited_data:\n"
            )
            test_file_output += deps_pretty.prettify_json(new_json_data)

            test_file = deps_helper.parse_full_path(
                ["feature_addons", "startup_data_modifier_tool", "testing"],
                "save_fn_test.txt",
            )

            with open(test_file, "w") as ofile:
                ofile.write(test_file_output)

    else:
        pass

    return (status_state, status_message)


def add_startup_item_arguments_list(arg_list: list = []):
    """Helper function to allow the user to add arguments for a
    startup item

    Args:
        arg_list (list, optional): A list of the existing arguments. Defaults to [].

    Returns:
        list: A new list containing the arguments the user added appended to the existing
            list, if passed in.
    """

    new_arg_list = arg_list.copy()
    num_args = 0

    # Ask user how many arguments they want to add and loop until the user enters a
    # valid integer
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
