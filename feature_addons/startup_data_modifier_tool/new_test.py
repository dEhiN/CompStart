import os, unittest, json, subprocess
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

    def confirm_written_data(self, check_dict: dict):
        print("...Now checking to see if the data was written properly", end="")
        temp_data = []

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

            if temp_data == check_dict:
                print("...The data was written as expected!")
            else:
                print(
                    "...Uh oh, something went wrong! The data wasn't what was expected!"
                )
        else:
            print("...Uh oh, something went wrong! Cannot find " + self.TEST_FILE)

    def print_results(self, results):
        print(self.expected_message)
        print("Returned: " + str(results))

    def generate_test_message(
        self, func_name: str, test_num: int, msg_addons: bool, msg_extras: list = []
    ):
        print(f"\n\nTest #{test_num}: Testing function {func_name}", end="")
        if msg_addons:
            num_addons = len(msg_extras)
            print(f" with {msg_extras[0]}", end="")

            if num_addons > 1:
                for i in range(1, num_addons):
                    print(f" and {msg_extras[i]}", end="")

        print("...")

    def clear_test_file(self):
        if os.path.isfile(self.TEST_FILE):
            os.remove(self.TEST_FILE)

    # String
    def test_001_parse_full_path(self):
        self.generate_test_message(
            test_num=1, func_name="parse_full_path", msg_addons=False
        )

        self.sde_func_str_return = self.COMP_START.parse_full_path(
            self.TEST_PATH, self.TEST_FILENAME
        )
        return_value = self.TEST_FILE
        self.expected_message += return_value

        self.assertEqual(self.sde_func_str_return, return_value)
        self.print_results(results=self.sde_func_str_return)

    # Boolean
    @patch("builtins.input", lambda _: "Y")
    def test_002_check_overwrite_yes(self):
        self.generate_test_message(
            test_num=2,
            func_name="check_overwrite",
            msg_addons=True,
            msg_extras=["input mocked as 'Y'"],
        )

        self.sde_func_bool_return = self.COMP_START.check_overwrite(self.TEST_FILE)
        return_value = True
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_bool_return, return_value)
        self.print_results(results=self.sde_func_bool_return)

    # Boolean
    @patch("builtins.input", lambda _: "N")
    def test_003_check_overwrite_no(self):
        self.generate_test_message(
            test_num=3,
            func_name="check_overwrite",
            msg_addons=True,
            msg_extras=["input mocked as 'N'"],
        )

        self.sde_func_bool_return = self.COMP_START.check_overwrite(self.TEST_FILE)
        return_value = False
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_bool_return, return_value)
        self.print_results(results=self.sde_func_bool_return)

    # Dictionary
    def test_004_generate_json(self):
        # Need to fill this in
        self.generate_test_message(
            test_num=4, func_name="generate_json", msg_addons=False
        )

        self.sde_func_dict_return = self.COMP_START.generate_json()
        return_value = []
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_dict_return, return_value)
        self.print_results(results=self.sde_func_dict_return)

    # Dictionary
    def test_005_generate_default(self):
        self.generate_test_message(
            test_num=5, func_name="generate_default", msg_addons=False
        )

        self.sde_func_dict_return = self.COMP_START.generate_default()
        return_value = self.EXAMPLE_JSON.copy()
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_dict_return, return_value)
        self.print_results(results=self.sde_func_dict_return)

    # Dictionary
    def test_006_create_json_data_true(self):
        self.generate_test_message(
            test_num=6,
            func_name="create_json_data",
            msg_addons=True,
            msg_extras=["parameter 'new_file' as True"],
        )

        self.sde_func_dict_return = self.COMP_START.create_json_data(True)
        return_value = self.EXAMPLE_JSON.copy()
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_dict_return, return_value)
        self.print_results(results=self.sde_func_dict_return)

    # Dictionary
    def test_007_create_json_data_false(self):
        self.generate_test_message(
            test_num=7,
            func_name="create_json_data",
            msg_addons=True,
            msg_extras=["parameter 'new_file' as False"],
        )

        self.sde_func_dict_return = self.COMP_START.create_json_data(False)
        return_value = self.COMP_START.generate_json()
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_dict_return, return_value)
        self.print_results(results=self.sde_func_dict_return)

    # Tuple
    def test_008_json_writer_case_zero(self):
        self.generate_test_message(
            test_num=8,
            func_name="json_writer",
            msg_addons=True,
            msg_extras=["parameter 'file_state' as 0"],
        )

        self.clear_test_file()

        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 0, self.EXAMPLE_TEST
        )
        return_value = (True, "JSON file written successfully!")
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)
        self.confirm_written_data(check_dict=self.EXAMPLE_TEST)

    # Tuple
    @patch("builtins.input", lambda _: "Y")
    def test_009_json_writer_case_one_yes(self):
        # Need to fill this in
        self.generate_test_message(
            test_num=9,
            func_name="json_writer",
            msg_addons=True,
            msg_extras=["parameter 'file_state' as 1", "input mocked as 'Y'"],
        )

        self.clear_test_file()

        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 1, self.EXAMPLE_TEST
        )
        return_value = (True, "JSON file written successfully!")
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)
        self.confirm_written_data(check_dict=self.EXAMPLE_TEST)

    # Tuple
    @patch("builtins.input", lambda _: "N")
    def test_010_json_writer_case_one_no(self):
        # Need to fill this in
        self.generate_test_message(
            test_num=10,
            func_name="json_writer",
            msg_addons=True,
            msg_extras=["parameter 'file_state' as 1", "input mocked as 'N'"],
        )

        self.clear_test_file()

        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 1, self.EXAMPLE_TEST
        )
        return_value = (False, "Skipped writing JSON file!")
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)

    # Tuple
    def test_011_json_writer_case_two_diff_data(self):
        self.generate_test_message(
            test_num=11,
            func_name="json_writer",
            msg_addons=True,
            msg_extras=["parameter 'file_state' as 2", "using updated JSON data"],
        )

        self.clear_test_file()
        self.COMP_START.json_writer(self.TEST_FILE, 0, self.EXAMPLE_TEST)

        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 2, self.APPEND_EXAMPLE_TEST
        )
        return_value = (True, "JSON file written successfully!")
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)
        self.confirm_written_data(check_dict=self.APPEND_EXAMPLE_TEST)

    # Tuple
    def test_012_json_writer_case_two_same_data(self):
        self.generate_test_message(
            test_num=12,
            func_name="json_writer",
            msg_addons=True,
            msg_extras=["parameter 'file_state' as 2", "using the same JSON data"],
        )

        self.clear_test_file()
        self.COMP_START.json_writer(self.TEST_FILE, 0, self.EXAMPLE_TEST)

        self.sde_func_tpl_return = self.COMP_START.json_writer(
            self.TEST_FILE, 2, self.EXAMPLE_TEST
        )
        return_value = (
            False,
            "Existing JSON data and new JSON data are the same. Not"
            + f" updating {self.TEST_FILE} because there is no point.",
        )
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)

    # Tuple
    def test_013_json_creator(self):
        self.generate_test_message(
            test_num=13, func_name="json_creator", msg_addons=False
        )

        self.clear_test_file()

        self.sde_func_tpl_return = self.COMP_START.json_creator(
            self.TEST_PATH, self.TEST_FILENAME
        )
        return_value = (True, "JSON file written successfully!")
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)
        self.confirm_written_data(check_dict=self.EXAMPLE_JSON)

    # Tuple
    def test_014_json_reader_no_file_extension(self):
        self.generate_test_message(
            test_num=14,
            func_name="json_reader",
            msg_addons=True,
            msg_extras=["parameter 'json_filename' as a file with no extension"],
        )

        test_filename = "unittest"
        self.sde_func_tpl_return = self.COMP_START.json_reader(
            self.TEST_PATH, test_filename
        )
        return_value = (False, "Please specify a valid JSON file name", {})
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)

    # Tuple
    def test_015_json_reader_wrong_file_extension(self):
        self.generate_test_message(
            test_num=15,
            func_name="json_reader",
            msg_addons=True,
            msg_extras=[
                "parameter 'json_filename' as a file with an incorrect extension"
            ],
        )

        test_filename = "unittest.test"
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
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)

    # Tuple
    def test_016_json_reader_valid_file(self):
        self.generate_test_message(
            test_num=16,
            func_name="json_reader",
            msg_addons=True,
            msg_extras=["parameter 'json_filename' as a valid JSON file"],
        )

        self.sde_func_tpl_return = self.COMP_START.json_reader(
            self.JSON_PATH, self.JSON_FILENAME
        )
        return_value = (
            True,
            "JSON data read in successfully!",
            self.EXAMPLE_JSON.copy(),
        )
        self.expected_message += str(return_value)

        self.assertEqual(self.sde_func_tpl_return, return_value)
        self.print_results(results=self.sde_func_tpl_return)


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
    # Make sure we start in the correct directory
    set_startdir()

    unittest.main()
