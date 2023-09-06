import os, unittest, json
from unittest.mock import patch
import startup_data_editor


class TestStartupDataEditor(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Creating and initializing class variables
        cls.COMP_START = startup_data_editor
        cls.expected_message = "Expected: "
        cls.sde_func_str_return = ""
        cls.sde_func_tpl_return = ()
        cls.sde_func_dict_return = {}
        cls.sde_func_bool_return = False

        # Creating all JSON variable constants to use in testing
        cls.EXAMPLE_JSON = cls.COMP_START.EXAMPLE_JSON
        cls.JSON_FILENAME = "test_data.json"
        cls.JSON_PATH = [
            "feature_addons",
            "startup_data_modifier_tool",
            "program_files",
        ]

        # Copied code to generate JSON_FILE from startup_data_editor.py
        cls.JSON_FILE = os.getcwd()
        for item in cls.JSON_PATH:
            cls.JSON_FILE += os.sep + os.path.join(item)
        cls.JSON_FILE += os.sep + cls.JSON_FILENAME

        # Creating all TEST variable constants to use in testing. These will be
        # a second set of JSON data to test against
        cls.EXAMPLE_TEST = {
            "TotalItems": 2,
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
            ],
        }
        cls.APPEND_EXAMPLE_TEST = {
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
        cls.TEST_FILENAME = "unittest_data.json"
        cls.TEST_PATH = ["feature_addons", "startup_data_modifier_tool"]

        # Copying code to generate TEST_FILE from startup_data_editor.py
        cls.TEST_FILE = os.getcwd()
        for item in cls.TEST_PATH:
            cls.TEST_FILE += os.sep + os.path.join(item)
        cls.TEST_FILE += os.sep + cls.TEST_FILENAME

    def test_parse_full_path(self):
        print("\n\n1) Testing parse_full_path...")

        self.expected_message += self.TEST_FILE
        self.sde_func_str_return = self.COMP_START.parse_full_path(
            self.TEST_PATH, self.TEST_FILENAME
        )
        return_value = self.TEST_FILE

        self.assertEqual(self.sde_func_str_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + self.sde_func_str_return)

    def test_generate_default(self):
        print("\n\n2) Testing generate_default...")

        self.expected_message += json.dumps(self.EXAMPLE_JSON)
        self.sde_func_dict_return = self.COMP_START.generate_default()
        return_value = self.EXAMPLE_JSON.copy()

        self.assertEqual(self.sde_func_dict_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_dict_return))

    def test_create_json_data_true(self):
        print("\n\n3) Testing create_json_data with parameter 'new_file' as True...")

        self.expected_message += json.dumps(self.EXAMPLE_JSON)
        self.sde_func_dict_return = self.COMP_START.create_json_data(True)
        return_value = self.EXAMPLE_JSON.copy()

        self.assertEqual(
            self.sde_func_dict_return,
            return_value,
            self.expected_message,
        )

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_dict_return))

    def test_create_json_data_false(self):
        print("\n\n4) Testing create_json_data with parameter 'new_file' as False...")

        self.expected_message += "[]"
        self.sde_func_dict_return = self.COMP_START.create_json_data(False)
        return_value = self.COMP_START.generate_json()

        self.assertEqual(
            self.sde_func_dict_return,
            return_value,
            self.expected_message,
        )

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_dict_return))

    def test_json_writer_case_zero(self):
        print("\n\n5) Testing json_writer with parameter 'file_state' as 0...")

        if os.path.isfile(self.TEST_FILE):
            os.remove(self.TEST_FILE)

        self.expected_message += "(True, 'JSON file written successfully!')"
        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 0, self.EXAMPLE_TEST
        )
        return_value = (True, "JSON file written successfully!")
        temp_data = []

        self.assertEqual(
            self.sde_func_tpl_return,
            return_value,
            self.expected_message,
        )

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_tpl_return))

        print("...Now checking to see if the data was written properly...")

        if os.path.isfile(self.TEST_FILE):
            try:
                with open(self.TEST_FILE, "r") as file:
                    temp_data = json.load(file)
            except Exception:
                print(Exception)

            if temp_data == self.EXAMPLE_TEST:
                print("...The data was written properly as expected!")
            else:
                print(
                    "...Uh oh, something went wrong! The data wasn't what was expected!"
                )
        else:
            print("...Uh oh, something went wrong! Cannot find " + self.TEST_FILE)

    def test_json_writer_case_two(self):
        print("\n\n7) Testing json_writer with parameter 'file_state' as 2...")

        if os.path.isfile(self.TEST_FILE):
            os.remove(self.TEST_FILE)

        try:
            with open(self.TEST_FILE, "w") as file:
                json.dump(self.EXAMPLE_TEST, file)
        except Exception as e:
            err_msg = (
                "...Uh oh, something went wrong! Cannot find or create "
                + self.TEST_FILE
            )
            raise self.failureException(err_msg)

        self.expected_message += "(True, 'JSON file written successfully!')"
        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 2, self.APPEND_EXAMPLE_TEST
        )
        return_value = (True, "JSON file written successfully!")
        temp_data = []

        self.assertEqual(
            self.sde_func_tpl_return,
            return_value,
            self.expected_message,
        )

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_tpl_return))

        print("...Now checking to see if the data was written properly...")

        if os.path.isfile(self.TEST_FILE):
            try:
                with open(self.TEST_FILE, "r") as file:
                    temp_data = json.load(file)
            except Exception as error:
                return_message = (
                    "Unable to read JSON data. Error information is below:\n"
                    + str(type(error).__name__)
                    + " - "
                    + str(error)
                )

                print(return_message)

            if temp_data == self.APPEND_EXAMPLE_TEST:
                print("...The data was written properly as expected!")
            else:
                print(
                    "...Uh oh, something went wrong! The data wasn't what was expected!"
                )
        else:
            print("...Uh oh, something went wrong! Cannot find " + self.TEST_FILE)

    def test_json_creator(self):
        print("\n\n8) Testing json_creator...")

        if os.path.isfile(self.TEST_FILE):
            os.remove(self.TEST_FILE)

        self.expected_message += "(True, 'JSON file written successfully!')"
        self.sde_func_tpl_return = self.COMP_START.json_creator(
            self.TEST_PATH, self.TEST_FILENAME
        )
        return_value = (True, "JSON file written successfully!")
        temp_data = []

        self.assertEqual(self.sde_func_tpl_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_tpl_return))

        print("...Now checking to see if the data was written properly...")

        if os.path.isfile(self.TEST_FILE):
            try:
                with open(self.TEST_FILE, "r") as file:
                    temp_data = json.load(file)
            except Exception as error:
                return_message = (
                    "Unable to read JSON data. Error information is below:\n"
                    + str(type(error).__name__)
                    + " - "
                    + str(error)
                )

                print(return_message)

            if temp_data == self.EXAMPLE_JSON:
                print("...The data was written properly as expected!")
            else:
                print(
                    "...Uh oh, something went wrong! The data wasn't what was expected!"
                )
        else:
            print("...Uh oh, something went wrong! Cannot find " + self.TEST_FILE)

    def test_json_reader_no_file_extension(self):
        print(
            "\n\n9) Testing json_reader with parameter 'json_filename' as a file",
            "with no extension...",
        )

        test_filename = "unittest"
        self.expected_message += "(False, 'Please specify a valid JSON file name', {})"
        self.sde_func_tpl_return = self.COMP_START.json_reader(
            self.TEST_PATH, test_filename
        )
        return_value = (False, "Please specify a valid JSON file name", {})

        self.assertEqual(self.sde_func_tpl_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_tpl_return))

    def test_json_reader_wrong_file_extension(self):
        print(
            "\n\n10) Testing json_reader with parameter 'json_filename' as a file",
            "with an incorrect extension...",
        )

        test_filename = "unittest.test"
        self.expected_message += (
            "(False, 'Invalid JSON file name."
            + "\\nReceived extension of: test\\nExpected extension of: json',"
            + "{})"
        )
        self.sde_func_tpl_return = self.COMP_START.json_reader(
            self.TEST_PATH, test_filename
        )
        return_value = (
            False,
            "Invalid JSON file name.\n"
            "Received extension of: test\n"
            "Expected extension of: json",
            {},
        )

        self.assertEqual(self.sde_func_tpl_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_tpl_return))

    def test_json_reader_valid_file(self):
        print(
            "\n\n11) Testing json_reader with parameter 'json_filename' as a",
            "valid JSON file...",
        )

        self.expected_message += (
            "(True, 'JSON data read in successfully', "
            + json.dumps(self.EXAMPLE_JSON)
            + ")"
        )
        self.sde_func_tpl_return = self.COMP_START.json_reader(
            self.JSON_PATH, self.JSON_FILENAME
        )
        return_value = (
            True,
            "JSON data read in successfully!",
            self.EXAMPLE_JSON.copy(),
        )

        self.assertEqual(self.sde_func_tpl_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_tpl_return))

    @patch("builtins.input", lambda _: "Y")
    def test_check_overwrite_yes(self):
        print("\n\n12) Testing check_overwrite mocking input as 'Y'...")

        self.expected_message += "True"
        self.sde_func_bool_return = self.COMP_START.check_overwrite(self.TEST_FILE)
        return_value = True

        self.assertEqual(self.sde_func_bool_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_bool_return))

    @patch("builtins.input", lambda _: "N")
    def test_check_overwrite_no(self):
        print("\n\n13) Testing check_overwrite mocking input as 'N'...")

        self.expected_message += "False"
        self.sde_func_bool_return = self.COMP_START.check_overwrite(self.TEST_FILE)
        return_value = False

        self.assertEqual(self.sde_func_bool_return, return_value, self.expected_message)

        print(self.expected_message)
        print("Actual: " + str(self.sde_func_bool_return))

    def notest_generate_json(self):
        # Need to fill this in
        print("Skipping test for generate_json...")

    def notest_json_writer_case_one(self):
        # Need to fill this in
        print("Skipping test for json_writer with parameter 'file_state' as 1...")


if __name__ == "__main__":
    unittest.main()
