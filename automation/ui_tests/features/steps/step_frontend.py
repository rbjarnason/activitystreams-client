from common.pages.base import PageObjectFactory
from ui_tests.pages.home_page import ActivitySnippetHomePage
from hamcrest import assert_that, is_


# **************** GIVEN STEPS ****************
@given('I am on the activity snippet test page')
def step(context):
    context.page = PageObjectFactory().create(ActivitySnippetHomePage)
    context.page.open()
    context.index = 1
    context.page.start_login()


# **************** WHEN STEPS ****************
@when('I verb the object')
def step(context):
    context.page.select_verb(context.noverb)


@when('I loged in an object never verbed')
def step(context):
    context.page.login(context.utils.get_cookie())
    context.noverb = context.page.get_verb_never_verbed(4)
    context.count = context.page.get_snippet_count_by_index(str(
        context.noverb))


@when('I loged in an object already verbed')
def step(context):
    context.page.login(context.utils.get_cookie())
    context.noverb = context.page.get_verb_already_verbed(4)
    context.count = context.page.get_snippet_count_by_index(str(
        context.noverb))


# **************** THEN STEPS ****************
@then('I should see the current count of time that the verbs has been chosen')
def step(context):
    assert_that(context.page.are_counter_visible_for_all_verbs(4))


@then('I should see the snippet count incremented by 1')
def step(context):
    assert_that(
        context.page.get_snippet_count_by_index(str(
            context.noverb)), is_(str(int(context.count) + 1)))


@then('I should see the snippet count decremented by 1')
def step(context):
    assert_that(
        context.page.get_snippet_count_by_index(str(
            context.noverb)), is_(str(int(context.count) - 1)))


@then('I should see the snippet greyed out')
def step(context):
    assert_that(context.page.is_snippet_disable())


@then('I should not be able to interact with the snippet')
def step(context):
    assert_that(context.page.is_snippet_clickeable())
