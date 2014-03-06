from common.pages.base import PageObjectFactory
from common.config import ApplicationUtils
from common.driver import WebDriverFacade
import os
import re


def before_all(context):
    context.utils = ApplicationUtils()
    context.create_driver = lambda: context.utils.create_driver()
    context.base_url = context.utils.get_base_url()


def before_scenario(context, scenario):
    context.driver = context.create_driver()
    #PageFactory initialization
    page_factory = PageObjectFactory()
    page_factory.driver = context.driver
    page_factory.base_url = context.base_url


def after_scenario(context, scenario):
    if "failed" == scenario.status:
        take_screenshot(context, scenario)
    context.driver.quit()


def take_screenshot(context, scenario):
    new_scenario_name = scenario.name[0:30]
    new_scenario_name = re.sub(r'[\W_]+', '_', new_scenario_name)
    png_file_name = new_scenario_name + ".png"
    file = os.path.join(context.utils.get_screenshot_directory(),
                        png_file_name)
    WebDriverFacade(context.driver).take_screenshot(file)
