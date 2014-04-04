from common.driver import WebDriverFacade


class PageObject(object):

    def __init__(self, driver):
        self.driver_facade = WebDriverFacade(driver)

    @property
    def driver(self):
        return self.driver_facade.driver

    @staticmethod
    def create(page_object_type, **kwargs):
        return PageObjectFactory().create(page_object_type, **kwargs)


class BasePage(PageObject):
    """Base class abstraction that represents a web page"""

    @property
    def page_title(self):
        """Returns the page title from Selenium.

        This is different from _page_title,
        which is defined for a specific page object and is the expected
        title of the page.

        """
        return self.driver_facade.get_current_page_title_when_available(30)

    @property
    def page_url(self):
        raise ValueError("You must define an URL for this page")

    def is_the_current_page(self):
        """
        Returns true if the actual page title matches the expected title
        stored in _page_title.

        """
        if self._page_title:
            return self.page_title == self._page_title

    def is_text_visible_in_body(self, text):
        """
        Checks whether the given text is present in the html body element of
        this page

        """
        return self.driver_facade.is_text_visible(text)

    def open(self):
        """Opens the page and validates it"""
        self.driver_facade.open(self.page_url)

    def take_screenshot(self, filepath):
        self.driver_facade.take_screenshot(filepath)

    def click_navigate_back_button(self, explicit_wait_back=None):
        """Goes one step backward in the browser history"""
        self.driver_facade.click_navigate_back_button(explicit_wait_back)


class ApplicationBasePage(BasePage):
    """
    Base class abstraction for an application's web page whose URL shares the
    same domain

    Domain: http://www.common-domain.com

    Pages URL: http://www.common-domain.com/pageA
               http://www.common-domain.com/pageB
    """

    def __init__(self, driver, base_url):
        self.driver_facade = WebDriverFacade(driver)
        self.base_url = base_url

    @property
    def page_url(self):
        return self.base_url


class BasePopup(PageObject):

    def __init__(self, driver, popup_name):
        super(BasePopup, self).__init__(driver)
        self.parent_handler = driver.current_window_handle
        self.popup_name = popup_name
        self.popup_handler = None

    def switch_to_pop_up(self):
        self.popup_handler = self.driver_facade.switch_to_window_by_title(
            self.popup_name)

    def close(self):
        self.driver.close() if not self.is_closed()\
            else self.switch_to_parent()

    def is_closed(self):
        return self.popup_handler not in self.driver.window_handles

    def switch_to_parent(self):
        self.driver.switch_to_window(self.parent_handler)


class PageObjectFactory(object):

    _singleton = None

    def __new__(cls, *args, **kwargs):
        if not cls._singleton:
            cls._singleton = super(PageObjectFactory, cls).__new__(cls, *args,
                                                                   **kwargs)
        return cls._singleton

    @property
    def base_url(self):
        return self._base_url

    @base_url.setter
    def base_url(self, base_url):
        self._base_url = base_url

    @property
    def driver(self):
        return self._driver

    @driver.setter
    def driver(self, driver):
        self._driver = driver

    def create(self, page_object_type, **kwargs):
        if issubclass(page_object_type, ApplicationBasePage):
            kwargs["base_url"] = self._base_url
        return page_object_type(self._driver, **kwargs)
