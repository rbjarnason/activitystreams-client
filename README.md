[![Build Status](https://travis-ci.org/natgeo/modules-activitysnippet.png)](https://travis-ci.org/natgeo/modules-activitysnippet)

#Welcome to the Activity Snippet repo!

##Activity Stream front-end module
   If you don't know about Activity Stream, please go to our [repository](https://github.com/natgeo/activitystreams/blob/develop/README.md) and read about the project.    

###Installation:

1. Look for the latest [stable release](https://github.com/natgeo/modules-activitysnippet/releases), download it and uncompress it in your project.
2. Proceed to [Usage](https://github.com/natgeo/modules-activitysnippet/blob/develop/README.md#usage) instructions.

### Environment setup for development

1. First as always it's necessary to clone the repo:

      git clone git@github.com:natgeo/modules-activitysnippet.git

2. Make sure you have Ruby installed by running:

      ruby -v

3. Then execute:

      bundle 

   If bundle install fails, then try executing:

         gem install bundler
   *For linux users use sudo*

4. After install the requirements, please run:

      npm install

5. Then:

      bower install  

   If this fails probably you need to execute

         sudo npm install -g bower 
   *This will install bower globally*


6. Check if it's running, please run:

      grunt serve 

   If grunt is not installed then execute:

         sudo npm install -g grunt-cli
   *The same with bower, this will install grunt globally.*

###Important!
If you are a developer, please follow the following guidelines:

1. pull requests should go to `develop`
2. include unit tests
3. include documentation if you changed something

###Usage

* Dependencies:
    * Handlebars (latest)

Start by including the activitysnippet.js file on the pages in which you would like to have snippets:
``` html
<script src="activitysnippet.js"></script>
```

If you don't want to manage our dependencies on your own, you should also include the activitysnippet.vendor.js file and include it before the activitysnippet.js file:
``` html
<script src="activitysnippet.vendor.js"></script>
```
Once including the source files on the page, you would need to add some snippets onto it as well:

    Within body:
   ``` html
    <div class="activitysnippet" data-object-type="appname_model_name" data-object-id="1" data-object-api="http://google.com/" data-verb="favorited"></div>
   ```
This element must be a block-level element, and have a class of activitysnippet. You would then define your object type, id, api route and the verb you want the snippet to inhabit.
   ``` javascript
    data-object-type = appname_modelname (e.g cms_article)
    data-object-id = _Integer_ (e.g. 1)
    data-object-api = restful endpoint representing object (e.g. http://www.api.com/v1/object-type/1/)
   ``` 
Once these divs are in place, you are pretty much set, except for instantiation, which is done via:
   ``` javascript
    var snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
   ```
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


