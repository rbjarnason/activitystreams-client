from common.pages.base import ApplicationBasePage
from selenium.webdriver.common.by import By
import time


class ActivitySnippetHomePage(ApplicationBasePage):

    _snippet_disabled = (By.CSS_SELECTOR, ".activitysnippet-icon--disabled")

    def __init__(self, driver, base_url):
        super(ActivitySnippetHomePage, self).__init__(driver, base_url)

    @property
    def _page_title(self):
        return 'modules activitysnippet'

    def click_verb_by_position(self, index):
        _verbs = (By.XPATH, "//div[contains(@class, 'activitysnippet')]["
                  + str(index) + "]/span/a/i")
        self.driver_facade.click(_verbs)

    def is_counter_for_verb_by_position_visible(self, index):
        _verbs = (By.XPATH, "//div[contains(@class, 'activitysnippet')]["
                  + str(index) + "]/span/span")
        return self.driver_facade.is_element_visible(_verbs)

    def is_verbs_by_index_visible(self, index):
        _verbs = (By.XPATH, "//div[@class='activitysnippet']["
                  + str(ActivitySnippetHomePage._number_traslator[index])
                  + "]/span/a/i")
        self.driver_facade.is_element_visible(_verbs)

    def are_counter_visible_for_all_verbs(self, max_elements):
        i = 1
        while (i <= max_elements):
            status = self.is_counter_for_verb_by_position_visible(i)
            if not status:
                return status
            i = i + 1
        return status

    def login(self):
        sentence = "window.factory.toggleState()"
        self.driver_facade.execute_java_script(sentence)

    def get_verb_never_verbed(self, max_elements):
        i = 0
        flag = False
        while (i < max_elements and not flag):
            sentence = "return window.factory.snippets[" + str(i) + "].state;"
            status = self.driver_facade.execute_java_script(sentence)
            if str(status) == "False":
                flag = True
                return i + 1
            i = i + 1
        if not flag:
            return 0

    def get_verb_already_verbed(self, max_elements):
        i = 0
        flag = False
        while (i < max_elements and not flag):
            sentence = "return window.factory.snippets[" + str(i) + "].state;"
            status = self.driver_facade.execute_java_script(sentence)
            if str(status) == "True":
                flag = True
                return i + 1
            i = i + 1
        if not flag:
            return 0

    def select_verb(self, verb):
        self.click_verb_by_position(verb)
        time.sleep(1)

    def get_snippet_count_by_index(self, index):
        _verbs = (By.XPATH, "//div[contains(@class, 'activitysnippet')]["
                  + index + "]/span/span")
        return self.driver_facade.get_text(_verbs)

    def is_snippet_disable(self):
        return self.driver_facade.is_element_visible(
            ActivitySnippetHomePage._snippet_disabled)

    def is_snippet_clickeable(self):
        _verbs = (By.XPATH, "//div[@class='activitysnippet'][1]/span/a/i")
        return self.driver_facade.is_element_available(_verbs)
