# This will be a command line tool to create and edit the
# startup_data.json file
import os
import dependencies.jsonfn as deps_json
import dependencies.helper as deps_helper
import dependencies.chooser as deps_chooser
import dependencies.pretty as deps_pretty

# Global variable to specify is in testing or production environment
is_prod = False


def is_production():
    """Small helper function to return the variable
    is_prod.

    This can be used by other modules to skip certain
    menu choices for testing purposes.

    Returns:
        bool: The variable is_prod which is False when in testing and True
        otherwise.
    """
    return is_prod


if __name__ == "__main__":
    # Set the starting directory
    deps_helper.set_start_dir()

    # Variables for location and name of JSON file with startup data
    json_path = deps_helper.get_prod_path()
    json_filename = "startup_data.json"

    # Print welcome message
    print(
        "\nWelcome to CompStart: The computer startup tool that will make your"
        " life easier."
    )

    # Initialize status variables
    status_state = False
    status_message = "No action taken..."

    # Main loop to allow user to navigate program options
    menu_choices = (
        "[1] What is CompStart?\n"
        "[2] Create a new startup file\n"
        "[3] View the existing startup file\n"
        "[4] Edit the existing startup file\n"
    )
    total_menu_choices = 4
    quit_loop = False

    while not quit_loop:
        user_choice = deps_chooser.user_menu_chooser(menu_choices, total_menu_choices)

        match user_choice:
            case 1:
                deps_helper.program_info()
            case 2:
                # Find out which type of new file the user wants
                is_default, to_continue = deps_chooser.new_file_chooser()

                if to_continue:
                    # Create a new JSON file
                    status_state, status_message = deps_json.json_creator(
                        json_path, json_filename, is_default
                    )
                print(f"\n{status_message}")
            case 3:
                # Read in existing JSON file and store the return results of the
                # json_read function, then print out if the read was successful
                status_state, status_message, json_data = deps_json.json_reader(
                    json_path, json_filename
                )
                print(f"\n{status_message}\n")

                # If there was data read in, print it out in a prettified way
                if status_state:
                    input("Press enter when ready to view the startup data...")
                    print(deps_pretty.prettify_json(json_data))
                    input("\nPress enter when ready to return to the previous menu...")
            case 4:
                deps_json.json_editor(json_path, json_filename)
