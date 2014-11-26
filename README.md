[![Build Status](https://travis-ci.org/natgeo/modules-activitysnippet.png)](https://travis-ci.org/natgeo/modules-activitysnippet)

#####Welcome to the Activity Snippet repo!

If you are a developer, please follow the following guidelines:

1. pull requests should go to `develop`
2. include unit tests
3. include documentation if you changed something

If you want to use the snippet:

* Dependencies:
    * Handlebars (latest)

Start by including the activitysnippet.js file on the pages in which you would like to have snippets:
`<script src="activitysnippet.js"></script>`

If you don't want to manage our dependencies on your own, you should also include the activitysnippet.vendor.js file and include it before the activitysnippet.js file:
`<script src="activitysnippet.vendor.js"></script>`

Once including the source files on the page, you would need to add some snippets onto it as well:

    Within body:

    <div class="activitysnippet" data-object-type="appname_model_name" data-object-id="1" data-object-api="http://google.com/" data-verb="favorited"></div>

This element must be a block-level element, and have a class of activitysnippet. You would then define your object type, id, api route and the verb you want the snippet to inhabit.

    data-object-type = appname_modelname (e.g cms_article)
    data-object-id = _Integer_ (e.g. 1)
    data-object-api = restful endpoint representing object (e.g. http://www.api.com/v1/object-type/1/)

Once these divs are in place, you are pretty much set, except for instantiation, which is done via:

    var snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)

Where `options` must have a `ActivityStreamAPI` property pointing to an [activity stream service](https://github.com/natgeo/activitystreams) instance.

#######options:
options.debug - _boolean_ set the debug on/off

options.actor - _object_ set the actor with:

    actor:
    	id: 1
        type: 'appname_model' (e.g db_user)
        api: 'http://www.api.com/v1/appname_model/1/'

options.ActivityStreamAPI - _string_ set the service endpoint:

    ActivitySnippetAPI: 'http://service.api.com/v1

options.activeCallbacks - _array_ / _function_ A single function or an array of functions that will be called when a snippet is clicked and there is an active actor set.  The single function can also be an array.

options.inactiveCallbacks - _array_ /_function_ A single function or an array of functions that will be called when a snippet is clicked and there is no active actor set.  The single function can also be an array.

    If you have a function:
        myCB = function() {
            // code stuff
        }

        anotherCB = function() {
            // code stuff
        }

    then you pass that function in an array in one of the following ways:

        activeCallbacks: myCB
        inactiveCallbacks: [myCB, anotherCB]

---

Once instantiated via the `new ActivitySnippet.ActivityStreamSnippetFactory(options)` all snippets on the page should be fully functional.

