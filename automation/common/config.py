from common.driver import create_driver
from os.path import expanduser
import ConfigParser
import os


def get_root_path():
    return os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))


class ConfigurationParser(object):

    def __init__(self, particular_config_file=None):
        self._config_parser = ConfigParser.ConfigParser()
        self._root_path = get_root_path()
        url = self._get_config_file_url('setup.cfg')
        self._config_parser.readfp(open(url))
        if particular_config_file:
            self._config_parser.read(particular_config_file)

    def get_browser_name(self):
        return self._config_parser.get('selenium', 'browser')

    def get_browser_size(self):
        if self._config_parser.has_option('selenium', 'browser_size'):
            return self._config_parser.get('selenium', 'browser_size')
        return None

    def get_proxy_url(self):
        if self._config_parser.has_option('selenium', 'proxy'):
            return self._config_parser.get('selenium', 'proxy')
        return None

    def get_timeout(self):
        return self._config_parser.get('selenium', 'timeout')

    def _get_config_file_url(self, conf_file_name):
        home = expanduser("~")
        home_setup_file_path = os.path.join(home, conf_file_name)
        if os.path.isfile(home_setup_file_path):
            url = home_setup_file_path
        else:
            url = os.path.join(self._root_path, conf_file_name)
        return url

    def get_screenshot_directory(self):
        return os.path.join(self._root_path,
                            self._config_parser.get('general',
                                                    'screenshot_folder'))

    def get_base_url(self):
        return self._config_parser.get('general', 'base_url')


class ApplicationUtils(object):

    def __init__(self, config_file_path=None):
        self.configuration_parser = ConfigurationParser(config_file_path)

    def get_browser_name(self):
        browser_name = os.environ.get('BROWSER_NAME')
        if not browser_name:
            browser_name = self.configuration_parser.get_browser_name()

        return browser_name

    def get_browser_size(self):
        browser_size = os.environ.get('BROWSER_SIZE')
        if not browser_size:
            browser_size = self.configuration_parser.get_browser_size()

        return browser_size

    def get_proxy_url(self):
        proxy_url = os.environ.get('PROXY_URL')
        if not proxy_url:
            proxy_url = self.configuration_parser.get_proxy_url()

        return proxy_url

    def get_timeout(self):
        return self.configuration_parser.get_timeout()

    def get_base_url(self):
        base_url = os.environ.get('BASE_URL')
        if not base_url:
            base_url = self.configuration_parser.get_base_url()
        return base_url

    def create_driver(self):
        return create_driver(self.get_browser_name(), self.get_proxy_url(),
                             self.get_timeout(), self.get_browser_size())

    def get_screenshot_directory(self):
        return self.configuration_parser.get_screenshot_directory()
