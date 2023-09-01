import os, unittest, json
import startup_data_editor


class TestStartupDataEditor(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.COMP_START = startup_data_editor
        cls.expected_message = ""
        cls.sde_func_str_return = ""
        cls.sde_func_tpl_return = ()
        cls.sde_func_dict_return = {}

        # Creating all JSON variables as constants to use in testing
        cls.EXAMPLE_JSON = cls.COMP_START.EXAMPLE_JSON
        cls.JSON_FILENAME = "test_data.json"
        cls.JSON_PATH = [
            "feature_addons",
            "startup_data_modifier_tool",
            "program_files",
        ]
        # Copying code to generate JSON_FILE from startup_data_editor.py
        cls.JSON_FILE = os.getcwd()
        for item in cls.JSON_PATH:
            cls.JSON_FILE += os.sep + os.path.join(item)
        cls.JSON_FILE += os.sep + cls.JSON_FILENAME

        # Creating all TEST variables as constants to use in testing
        # These will be a second set of variables to test against
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
        cls.TEST_FILENAME = "unittest_data.json"
        cls.TEST_PATH = ["feature_addons", "startup_data_modifier_tool"]
        # Copying code to generate TEST_FILE from startup_data_editor.py
        cls.TEST_FILE = os.getcwd()
        for item in cls.TEST_PATH:
            cls.TEST_FILE += os.sep + os.path.join(item)
        cls.TEST_FILE += os.sep + cls.TEST_FILENAME

    def fntest_parse_full_path(self):
        print("\n\nTesting parse_full_path...")

        self.expected_message = "Expected:\n" + self.JSON_FILE
        self.sde_func_str_return = self.COMP_START.parse_full_path(
            self.JSON_PATH, self.JSON_FILENAME
        )

        self.assertEqual(
            self.sde_func_str_return, self.JSON_FILE, self.expected_message
        )

        print(self.sde_func_str_return)
        print(self.JSON_FILE)

    def fntest_generate_default(self):
        print("\n\nTesting generate_default...")

        self.expected_message = "Expected:\n" + str(self.EXAMPLE_JSON)
        self.sde_func_dict_return = self.COMP_START.generate_default()

        self.assertEqual(
            self.sde_func_dict_return, self.EXAMPLE_JSON, self.expected_message
        )

        print(self.sde_func_dict_return)
        print(self.EXAMPLE_JSON)

    def fntest_create_json_data_true(self):
        print("\n\nTesting create_json_data with parameter 'default' as True...")

        self.expected_message = "Expected:\n" + str(self.EXAMPLE_JSON)
        self.sde_func_dict_return = self.COMP_START.create_json_data(True)

        self.assertEqual(
            self.sde_func_dict_return,
            self.EXAMPLE_JSON,
            self.expected_message,
        )

        print(self.sde_func_dict_return)
        print(self.EXAMPLE_JSON)

    def fntest_json_writer_case_zero(self):
        print("\n\nTesting json_writer with parameter 'file_state' as 0...")

        if os.path.isfile(self.TEST_FILE):
            os.remove(self.TEST_FILE)

        self.expected_message = "Expected:\n(True, 'JSON file written successfully!')"
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

        print(self.sde_func_tpl_return)
        print(return_value)

        print("\n...Now checking to see if the data was written properly...")

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

    def fntest_json_reader_no_file_extension(self):
        print(
            "\n\nTesting json_reader with parameter 'json_filename' as a file",
            "with no extension...",
        )

        test_filename = "unittest"
        self.expected_message = (
            "Expected:\n(False, 'Please specify a valid JSON file name', {})"
        )
        self.sde_func_tpl_return = self.COMP_START.json_reader(
            self.TEST_PATH, test_filename
        )
        return_value = (False, "Please specify a valid JSON file name", {})

        self.assertEqual(self.sde_func_tpl_return, return_value, self.expected_message)

        print(self.sde_func_tpl_return)
        print(return_value)

    def fntest_json_reader_wrong_file_extension(self):
        print(
            "\n\nTesting json_reader with parameter 'json_filename' as a file",
            "with an incorrect extension...",
        )

        test_filename = "unittest.test"
        self.expected_message = (
            "Expected:\n(False, 'Invalid JSON file name."
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

        print(self.sde_func_tpl_return)
        print(return_value)

    def notest_check_overwrite(self):
        # Need to fill this in
        print("Skipping test for check_overwrite...")

    def notest_generate_json(self):
        # Need to fill this in
        print("Skipping test for generate_json...")

    def notest_create_json_data_false(self):
        # Need to fill this in
        print("Skipping test for create_json_data with parameter 'default' as False...")

    def notest_json_writer_case_one(self):
        # Need to fill this in
        print("Skipping test for json_writer with parameter 'file_state' as 1...")

    def notest_json_writer_case_two(self):
        # Need to fill this in
        print("Skipping test json_writer with parameter 'file_state' as 2...")

    def notest_json_creator(self):
        # Need to fill this in
        print("Skipping test for json_creator...")

    def untest_json_reader_valid_file(self):
        print(
            "Testing json_reader with parameter 'json_filename' as a valid JSON file..."
        )
        self.expected_message = (
            True,
            "JSON data read in successfully!",
            self.EXAMPLE_JSON,
        )
        self.assertEqual(
            self.COMP_START.json_reader(self.JSON_PATH, self.JSON_FILENAME),
            self.expected_message,
        )


if __name__ == "__main__":
    unittest.main()
