from common.pages.base import ApplicationBasePage
from selenium.webdriver.common.by import By


class ActivitySnippetHomePage(ApplicationBasePage):

    _title = (By.CSS_SELECTOR, ".hero-unit>h1")
    _subtitle = (By.CSS_SELECTOR, ".hero-unit>p")
    _user_logged = (By.ID, "user")
    _number_traslator = {
        "First": 1,
        "Second": 2,
    }
    _toggle_user_button = (By.ID, "toggleState")
    _snippet_even_list = (By.ID, "eventList")

    def __init__(self, driver, base_url):
        super(ActivitySnippetHomePage, self).__init__(driver, base_url)

    @property
    def _page_title(self):
        return 'modules activitysnippet'

    def get_page_title(self):
        return self.driver_facade.get_text(ActivitySnippetHomePage._title)

    def get_page_subtitle(self):
        return self.driver_facade.get_text(ActivitySnippetHomePage._subtitle)

    def get_user_welcome_message(self):
        return self.driver_facade.get_text(
            ActivitySnippetHomePage._user_logged)

    def click_eye_by_index(self, index):
        _eye = (By.XPATH, "//div[@data-verb='WATCHED']["
                + str(ActivitySnippetHomePage._number_traslator[index])
                + "]/span/a/i")
        self.driver_facade.click(_eye)

    def click_heart_by_index(self, index):
        _heart = (By.XPATH, "//div[@data-verb='FAVORITED']["
                  + str(ActivitySnippetHomePage._number_traslator[index])
                  + "]/span/a/i")
        self.driver_facade.click(_heart)

    def is_eye_not_watched_by_index(self, index):
        _eye = (By.XPATH, "//div[@data-verb='WATCHED']["
                + str(ActivitySnippetHomePage._number_traslator[index])
                + "]/span/a/i[contains(@class, 'fa-eye-slash')]")
        return self.driver_facade.is_element_visible(_eye)

    def is_heart_not_selected_by_index(self, index):
        _heart = (By.XPATH, "//div[@data-verb='FAVORITED']["
                  + str(ActivitySnippetHomePage._number_traslator[index])
                  + "]/span/a/i[contains(@class,'fa-heart-o')]")
        return self.driver_facade.is_element_visible(_heart)

    def is_toggled_user_button_present(self):
        return self.driver_facade.is_element_visible(
            ActivitySnippetHomePage._toggle_user_button)

    def is_snippet_event_list_present(self):
        return self.driver_facade.is_element_visible(
            ActivitySnippetHomePage._snippet_even_list)

    def get_text_from_snippet_even_list_by_index(self, index):
        _locator = (By.XPATH, ".//*[@id='eventList']/li[" + str(index) + "]")
        return self.driver_facade.get_text(_locator)

    def click_taggled_user_stat_button(self):
        self.driver_facade.click(ActivitySnippetHomePage._toggle_user_button)
