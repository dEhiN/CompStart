# This will be a command line tool to create and edit the startup_data.json
# file.

"""
Function to read in JSON data from a file

@input: path - string containing a relative or absolute path to the folder with
               JSON file
        file - string containing the filename of the JSON file
@output: currently nothing, but will be some data structure holding JSON data
"""


def json_reader(path: str, file: str):
    # Split the file using "." to validate if file is of type JSON
    print(file.split("."))
    split_file = file.split(".")
    print(len(split_file) - 1)
    if len(split_file) == 1:
        return "Please specify a valid JSON file name"
    elif len(split_file) == 2:
        if split_file[1] == "json":
            return "Valid JSON file name"
        else:
            return f"Invalid JSON file name.\nExpected extension of: json\nReceived extension of: {split_file[1]}"
    else:
        if split_file[len(split_file) - 1] == "json":
            return "Valid JSON file name"
        else:
            return f"Invalid JSON file name.\nExpected extension of: json\nReceived extension of: {split_file[len(split_file) - 1]}"


if __name__ == "__main__":
    # Variable to switch between testing and prod environments
    is_prod = False

    # Variables for location and name of JSON file with startup data
    json_path = ""
    json_filename = ""
    if is_prod:
        json_path = "/data/json_data/"
        json_filename = "startup_data.json"
    else:
        json_path = "./"
        json_filename = "test_data.json"

    # Read JSON data from file
    # json_reader(json_path, json_filename)
    json_reader(json_path, "testjson")
