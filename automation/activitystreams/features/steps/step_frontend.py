from common.pages.base import PageObjectFactory
from activitystreams.pages.home_page import ActivitySnippetHomePage
from hamcrest import assert_that, is_


# **************** GIVEN STEPS ****************
@given('I am on the activity snippet home page')
def step(context):
    context.page = PageObjectFactory().create(ActivitySnippetHomePage)
    context.page.open()


@then('I should see the "{title}" as title')
def step(context, title):
    assert_that(context.page.get_page_title(), is_(title))


@then('I should see the "{subtitle}" as subtitle')
def step(context, subtitle):
    assert_that(context.page.get_page_subtitle(), is_(subtitle))
