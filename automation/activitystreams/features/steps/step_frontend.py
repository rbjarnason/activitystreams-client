from common.pages.base import PageObjectFactory
from activitystreams.pages.home_page import ActivitySnippetHomePage
from hamcrest import assert_that, is_not, is_


# **************** GIVEN STEPS ****************
@given('I am on the activity snippet home page')
def step(context):
    context.page = PageObjectFactory().create(ActivitySnippetHomePage)
    context.page.open()
    context.index = 1


# **************** WHEN STEPS ****************
@when('I click on the "{index}" eye')
def step(context, index):
    context.page.click_eye_by_index(index)
    context.index = context.index + 1


@when('I click on the "{index}" heart')
def step(context, index):
    context.page.click_heart_by_index(index)
    context.index = context.index + 1


@when('I click on the "Taggle user state" button')
def step(context):
    context.page.click_taggled_user_stat_button()
    context.index = context.index + 1


# **************** THEN STEPS ****************
@then('I should see the "{title}" as title')
def step(context, title):
    assert_that(context.page.get_page_title(), is_(title))


@then('I should see the "{subtitle}" as subtitle')
def step(context, subtitle):
    assert_that(context.page.get_page_subtitle(), is_(subtitle))


@then('I should see the message "{message}"')
def step(context, message):
    assert_that(context.page.get_user_welcome_message(), is_(message))


@then('I should see the "{index}" eye as watched')
def step(context, index):
    assert_that(not(context.page.is_eye_not_watched_by_index(index)))


@then('I should see the "{index}" eye as unwatched')
def step(context, index):
    assert_that(context.page.is_eye_not_watched_by_index(index))


@then('I should see the "{index}" heart as liked')
def step(context, index):
    assert_that(not(context.page.is_heart_not_selected_by_index(index)))


@then('I should see the "{index}" heart as unliked')
def step(context, index):
    assert_that(context.page.is_heart_not_selected_by_index(index))


@then('I should see "taggled user state" button')
def step(context):
    assert_that(context.page.is_toggled_user_button_present())


@then('I should see the "Snippet event list"')
def step(context):
    assert_that(context.page.is_snippet_event_list_present())


@then('I should see the "{message}" message at the bottom of Snippet'
      ' event List')
def step(context, message):
    assert_that(
        context.page.get_text_from_snippet_even_list_by_index(
            context.index), is_(message))
