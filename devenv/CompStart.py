# This will be a command line tool to create and edit the startup_data.json file
import dependencies.cs_jsonfn as deps_json
import dependencies.cs_helper as deps_helper
import dependencies.cs_chooser as deps_chooser
import dependencies.cs_pretty as deps_pretty

# Global Variables

# Specifies whether the tool is in production or testing
is_prod = False

# If there are any errors, print this out at the end
final_err_msg = "Please see the error message(s) above and report them to the development team"

# Program starting point
if __name__ == "__main__":
    # Set the starting directory
    deps_helper.set_start_dir()

    # Variables for location and name of JSON file with startup data
    json_path = deps_helper.get_prod_path()
    json_filename = deps_helper.get_startup_filename(default_json=False)

    # Print welcome message
    print("\nWelcome to CompStart: The computer startup tool that will make your life easier")

    # Initialize status variables
    status_state = False
    status_message = "No action taken..."
    quit_loop = False

    # Menu choices to present to user during main loop
    menu_choices = [
        "Program description",
        "Create a new startup file",
        "View the existing startup file",
        "Edit the existing startup file",
    ]

    # Main loop to allow user to navigate program options
    while not quit_loop:
        user_choice = deps_chooser.user_menu_chooser(menu_choices)

        match user_choice:
            case 1:
                deps_helper.program_info()
            case 2:
                # Find out which type of new file the user wants
                is_default, create_file = deps_chooser.new_file_chooser()

                if create_file:
                    # Create a new JSON file
                    status_state, status_message = deps_json.json_creator(
                        json_path, json_filename, is_default
                    )

                # If there were any errors, let the user know to check the error messages
                if not status_state and not status_message.startswith("Skipped"):
                    status_message = final_err_msg

                # Print out the status message
                print(f"\n{status_message}")
            case 3:
                # Read in existing JSON file and store the return results of the json_read function, then print out if the read was successful
                status_state, status_message, json_data = deps_json.json_reader(
                    json_path, json_filename
                )

                # If there were any errors, let the user know to check the error messages
                if not status_state:
                    status_message = final_err_msg

                # Print out the status message
                print(f"\n{status_message}")

                # If there was data read in, print it out in a prettified way
                if status_state:
                    input("Press enter when ready to view the startup data...")
                    print(deps_pretty.prettify_json(json_data))
                    input("\nPress enter when ready to return to the previous menu...")
            case 4:
                status_state, status_message = deps_json.json_editor(json_path, json_filename)

                # If there were any errors, let the user know to check the error messages
                if not status_state:
                    status_message = final_err_msg

                # Print out the status message
                print(f"\n{status_message}")

            case 5:
                # This case will never really be addressed since the function user_menu_chooser adds an option by default to quit the program
                # If the user picks that option, the function calls sys.exit so execution should never return to this loop
                # However, just in case execution does return (i.e., some bug that gets introduced), this will prevent an infinite loop
                quit_loop = True
