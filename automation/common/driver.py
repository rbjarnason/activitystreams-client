from selenium import webdriver
from selenium.webdriver import Proxy
from selenium.webdriver.support.select import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import ElementNotVisibleException
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
import time


global_timeout = 0


def create_driver(browser_name, proxy_url, timeout, browser_size):
    global global_timeout
    global_timeout = timeout

    if browser_name == 'firefox':
        driver = _create_firefox_driver(proxy_url)
    elif browser_name == 'chrome':
        driver = _create_chrome_driver(proxy_url)
    else:
        raise ValueError("The driver couldn't be created")

    if browser_size == 'small':
        driver.set_window_size(320, 568)
    elif browser_size == 'medium':
        driver.set_window_size(768, 1024)
    elif browser_size == 'large':
        driver.set_window_size(1280, 1024)

    driver.implicitly_wait(timeout)

    return driver


def _create_firefox_driver(proxy_url):
    _proxy = None
    if proxy_url:
        _proxy = Proxy({
            'proxyType': 'MANUAL',
            'httpProxy': proxy_url,
            'ftpProxy': proxy_url,
            'sslProxy': proxy_url
        })
    return webdriver.Firefox(proxy=_proxy)


def _create_chrome_driver(proxy_url):
    chrome_options = None
    if proxy_url:
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--proxy-server=%s' % proxy_url)

    return webdriver.Chrome(chrome_options=chrome_options)


class WebDriverFacade(object):
    """Facade that encapsulates all the interactions with web driver"""

    def __init__(self, driver):
        self.driver = driver

    def get_current_url(self):
        return self.driver.current_url

    def _get_element(self, locator, index=0):
        if index < 0:
            raise ValueError("Index must be a greater than or equals zero")

        elements = self.driver.find_elements(*locator)
        if not elements:
            raise NoSuchElementException(
                "There couldn't be found any elements with the following "
                "selector: %s" % str(locator))
        return elements[index]

    def send_keys(self, locator, keys):
        """Sends keys to the given locator"""
        self.driver.find_element(*locator).send_keys(keys)

    def clear_and_send_keys(self, locator, keys):
        """Clear the given locator and then Sends keys"""
        self.driver.find_element(*locator).clear()
        self.driver.find_element(*locator).send_keys(keys)

    def get_text(self, locator, index=0):
        """Returns the text of the element at the given index from locator"""
        return self._get_element(locator, index).text

    def get_attribute_value(self, locator, attribute, index=0):
        """Returns the attribute's value of the element
        at the given index from locator

        """
        return self._get_element(locator, index).get_attribute(attribute)

    def contains_text(self, locator, text):
        """Returns true if the text is present in the given locator"""
        element = self.driver.find_element(*locator)
        return text in element.text

    def get_text_from_body_in_frame(self, frame_locator):
        """
        Gets the text from the frame_element_locator which is located inside
        the frame_locator

        """
        self.driver.switch_to_frame(self.driver.find_element(*frame_locator))
        text = self.driver.find_element_by_css_selector("body").text
        self.driver.switch_to_default_content()
        return text

    def write_into_body_frame(self, frame_locator, text):
        """
        Writes the given text into the frame_body_locator which is located
        inside the frame_locator

        """
        self.driver.switch_to_frame(self.driver.find_element(*frame_locator))
        ActionChains(self.driver).send_keys(Keys.CONTROL, "a").perform()
        self.driver.execute_script("document.body.innerHTML='" + text + "'")
        ActionChains(self.driver).send_keys(Keys.CONTROL).perform()
        self.driver.switch_to_default_content()

    def click(self, locator, explicit_wait_after_click=None, index=0):
        """Clicks on the element at the given index from locator"""
        self._get_element(locator, index).click()
        if explicit_wait_after_click:
            time.sleep(explicit_wait_after_click)

    def double_click(self, locator, explicit_wait_after_click=None, index=0):
        """Performs a double click on the element at the given index"""
        element = self._get_element(locator, index)
        ActionChains(self.driver).double_click(element).perform()
        if explicit_wait_after_click:
            time.sleep(explicit_wait_after_click)

    def open(self, url):
        """Opens the page at the given url"""
        self.driver.get(url)

    def is_element_visible(self, locator, index=0):
        """
        Returns true if the element at the specified locator is visible in the
        browser at the given index from locator
        Note: It uses an implicit wait if it cannot find the element
        immediately.

        """
        self.driver.implicitly_wait(0)
        try:
            return self._get_element(locator, index).is_displayed()
        except NoSuchElementException:
            return False
        finally:
            self.driver.implicitly_wait(global_timeout)

    def is_text_visible(self, text):
        """
        Returns true if the specified text is visible in the html body element
        of the page this driver is currently at

        """
        body = self.driver.find_element_by_tag_name("body")
        return text in body.text

    def get_current_page_title_when_available(self, timeout):
        """
        Returns the page title from Selenium, this is, the page the current
        driver is at

        """
        WebDriverWait(self.driver, timeout).until(lambda s: s.title)
        return self.driver.title

    def clear_element_value(self, locator):
        """Clears the element associated to the given locator"""
        self.driver.find_element(*locator).clear()

    def select_row_by_predicate(self, rows_selector, checkbox_selector,
                                predicate):
        """
        Selects every row from the list of the given rows_selector that
        matches the given predicate.
        The selection is made by clicking on the checkbox_selector

        """
        rows = self.driver.find_elements(*rows_selector)
        for row in rows:
            wrapper = WebDriverFacade(row)
            match = predicate(wrapper)
            if match:
                wrapper.click(checkbox_selector)

    def select_option_by_value(self, locator, value):
        """
        Selects the option from locator whose value matches the given value

        """
        select = Select(self.driver.find_element(*locator))
        select.select_by_value(value)

    def switch_to_window_by_title(self, title):
        """Switches focus to the specified window"""
        for handle in self.driver.window_handles:
            self.driver.switch_to_window(handle)
            if self.driver.title == title:
                return self.driver.current_window_handle
        raise ValueError("There couldn't be found a "
                         "window with title: {0}".format(title))

    def select_option_by_visible_text(self, locator, text, index=0):
        """
        Selects the option from locator whose visible text matches the given
        value and index from locator

        """
        select = Select(self._get_element(locator, index))
        select.select_by_visible_text(text)

    def click_and_execute_in_window(self, locator, function):
        old_handle = self.driver.current_window_handle
        new_handle = self._get_new_window_handler(locator, 20)
        self.driver.switch_to_window(new_handle)
        value = function(self.driver)
        #Check if the new window is active. If so, we close it.
        if new_handle in self.driver.window_handles:
            self.driver.close()
        self.driver.switch_to_window(old_handle)
        return value

    def click_and_switch_to_window(self, locator, timeout=1):
        new_handle = self._get_new_window_handler(locator, timeout)
        self.driver.switch_to_window(new_handle)

    def _get_new_window_handler(self, locator, timeout):
        existing_handlers = self.driver.window_handles
        self.click(locator)
        #Give some time for the window to appear
        time.sleep(5)
        end_time = time.time() + timeout
        while time.time() < end_time:
            for current_handler in self.driver.window_handles:
                if current_handler not in existing_handlers:
                    return current_handler
            time.sleep(0.5)

        raise TimeoutException("The window couldn't be opened")

    def click_link_by_visible_text(self, visible_text, locator=None):
        """
        Clicks on a link contained in the given locator by its visible text

        """
        elements = self.driver.find_element(*locator) if locator \
            else self.driver
        links = elements.find_elements_by_tag_name("a")
        for link in links:
            if (link.get_attribute('title') == visible_text or
                    link.get_attribute('text') == visible_text or
                    link.text == visible_text):
                link.click()
                return

        message_error = "Couldn't find any link named '%s' " % visible_text
        if locator:
            message_error += "inside this selector: %s" % str(locator)
        raise Exception(message_error)

    def click_menu_option_by_visible_text(self, menu_locator,
                                          list_of_menu_options):
        """
        Performs a move_to_element action on every link <a...> contained in
        menu_locator if its visible text matches any of the names defined in
        list_of_menu_options and clicks on the last matching link.


        """
        menu_options = self.driver.find_elements(*menu_locator)
        actions = ActionChains(self.driver)
        menu_index = 0
        expected_option = None
        for option in menu_options:
            if menu_index >= len(list_of_menu_options):
                break
            if expected_option is None:
                expected_option = list_of_menu_options[menu_index].strip()

            if (option.get_attribute('title') == expected_option or
                    option.get_attribute('text') == expected_option or
                    option.text == expected_option):
                actions.move_to_element(option)
                menu_index += 1
                expected_option = None
        actions.click()
        actions.perform()

    def is_element_available(self, locator):
        #As specified in the selenium documentation:
        #Element is Clickable - it is Displayed and Enabled
        self.driver.implicitly_wait(0)
        try:
            return EC.element_to_be_clickable(locator)(self.driver)
        except (NoSuchElementException, ElementNotVisibleException):
            return False
        finally:
            self.driver.implicitly_wait(global_timeout)

    def wait_for_element_to_be_available(self, locator, timeout):
        self.wait_until(lambda s: s.is_element_available(locator), timeout,
                        "Element {0} is not displayed or enabled".format(
                            str(locator)))

    def wait_while(self, function, intervals_in_seconds=10, max_times=10):
        matches = False
        times = 0
        while times < max_times and not matches:
            end_time = time.time() + intervals_in_seconds
            while True:
                time.sleep(1)
                matches = function(self)
                if not matches or time.time() > end_time:
                    break
            times += 1

        if not matches:
            raise TimeoutException(
                "Timeout when executing the given function."
                " Intervals in seconds: {0}. Tried: {1} times".format(
                    intervals_in_seconds, max_times))

    def wait_until(self, function, timeout, timeout_msg_error=''):
        wait = WebDriverWait(self.driver, timeout)
        value = wait.until(lambda s: function(self), timeout_msg_error)
        return value

    def are_ajax_calls_inactive(self):
        return self.driver.execute_script("return jQuery.active == 0")

    def wait_for_ajax_calls_to_complete(self, intervals_in_seconds=10):
        self.wait_until(lambda s: s.are_ajax_calls_inactive(),
                        intervals_in_seconds)

    def is_element_enabled(self, locator, index=0):
        """Given a list of elements, it checks whether the element
        at 'index' position is enabled

        """
        return self._get_element(locator, index).is_enabled()

    def set_checkbox_status(self, locator, check):
        """
        Marks the given checkbox as checked if the given boolean is True.
        Otherwise, it will be unchecked.

        """
        checkbox = self.driver.find_element(*locator)
        if ((checkbox.is_selected() and not check) or
                (not checkbox.is_selected() and check)):
            checkbox.click()

    def switch_to_frame(self, locator):
        """Switches focus to the specified locator"""
        self.driver.switch_to_frame(self.driver.find_element(*locator))

    def switch_to_default_content(self):
        """Switch focus to the default frame"""
        self.driver.switch_to_default_content()

    def scroll_page_to_element(self, locator, index=0,
                               explicit_wait_after_scroll=None):
        """Scrolls to a specific element on page given index from locator"""
        element = self._get_element(locator, index)
        element.location_once_scrolled_into_view
        if explicit_wait_after_scroll:
            time.sleep(explicit_wait_after_scroll)

    def scroll_to_end_of_element(self, locator,
                                 explicit_wait=None):
        """Scrolls down to the end of an element"""
        element = self.driver.find_element(*locator)
        self.driver.execute_script(
            "arguments[0].scrollTop = 1;", element)
        self.driver.execute_script(
            "arguments[0].scrollTop = arguments[0].scrollHeight;", element)
        if explicit_wait:
            time.sleep(explicit_wait)

    def scroll_to_top_of_element(self, locator):
        """Scrolls up to the top of an element"""
        element = self.driver.find_element(*locator)
        self.driver.execute_script(
            "arguments[0].scrollTop = 0;", element)

    def scroll_to_end_page(self, explicit_wait=0):
        self.driver.execute_script(
            "window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(explicit_wait)

    def get_total_elements(self, locator):
        return len(self.driver.find_elements(*locator))

    def get_total_visible_elements(self, locator):
        elements = self.driver.find_elements(*locator)
        count_visible = 0
        for element in elements:
            if element.is_displayed():
                count_visible = count_visible + 1
        return count_visible

    def is_element_on_the_top_viewport(self, locator):
        """Checks whether the given element is on the portion of the page
        that the user can currently see

        """
        element = self.driver.find_element(*locator)
        y_axis_location = self.get_element_location_by_axis(locator, "y")
        return element.is_displayed() and y_axis_location >= 0

    def take_screenshot(self, filepath):
        self.driver.get_screenshot_as_file(filepath)

    def click_navigate_back_button(self, explicit_wait=0):
        self.driver.back()
        time.sleep(explicit_wait)

    def mouse_over_to_element(self, locator, index=0):
        """Move the mouse over the selected locator"""
        element = self._get_element(locator, index)
        actions = ActionChains(self.driver)
        actions.move_to_element(element)
        actions.perform()

    def get_css_property_value(self, locator, css_property, index=0):
        return self.driver.find_elements(*locator)[index] \
            .value_of_css_property(css_property)

    def get_element_location_by_axis(self, locator, axis):
        element = self.driver.find_element(*locator)
        return element.location[axis]

    def get_size(self, locator, index=0):
        """Returns the size of the element at the given index from locator"""
        return self._get_element(locator, index).size

    def is_element_selected(self, locator):
        """
        Returns true if the element is selected, otherwise, returns false.

        """
        return self.driver.find_element(*locator).is_selected()

    def get_dropdown_values(self, locator):
        elements = self.driver.find_element(*locator).text.replace("\n", ", ")
        list_elements = []
        list_elements.append(elements)
        return list_elements

    def get_computed_css_style(self, locator, pseudo_selector, css_required):
        """    def scroll_to_end_page(self, explicit_wait=0):
        self.driver.execute_script(
            "window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(explicit_wait)
        Returns the conputed property of a given selector
        Selector must be an ID or a CSS class
        """
        if locator[0] == "id":
            element = "#" + locator[1]
        elif locator[0] == "css selector":
            element = locator[1]
        else:
            raise Exception("Selector must be and Id or a CSS class")
        if pseudo_selector in ["after", "before"]:
            return self.driver.execute_script(
                "return getComputedStyle(document.querySelector('"
                "" + element + "'),':" + pseudo_selector +
                "').getPropertyValue('" + css_required + "')")
        else:
            raise Exception("Pseudo selector must be 'before' or 'after'")

    def execute_java_script(self, sentence):
        return self.driver.execute_script(sentence)
