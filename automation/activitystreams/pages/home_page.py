from common.pages.base import ApplicationBasePage
from selenium.webdriver.common.by import By

class ActivitySnippetHomePage(ApplicationBasePage):

    _title = (By.CSS_SELECTOR, ".hero-unit>h1")
    _subtitle =(By.CSS_SELECTOR, ".hero-unit>p")
    def __init__(self, driver, base_url):
        super(ActivitySnippetHomePage, self).__init__(driver, base_url)

    @property
    def _page_title(self):
        return 'modules activitysnippet'

    def get_page_title(self):
        return self.driver_facade.get_text(self._title)
    
    def get_page_subtitle(self):
        return self.driver_facade.get_text(self._subtitle)