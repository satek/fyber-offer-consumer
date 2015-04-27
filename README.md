#Fyber Offer Consumer

This application uses [Fyber Mobile Offer API](http://developer.fyber.com/content/ios/offer-wall/offer-api/) to retrieve mobile add offers.

It can be seen deployed on Heroku [HERE](https://tranquil-crag-4307.herokuapp.com/).

##Framework and server

I have chosen ROR as framework for no particular reason except to speed up view building and test setup. Managing calls to the API is separated in a service class and independent of the framework. Puma is chosen as a server for deployment since the app manages blocking API calls, and Puma allows parallelization with threads and worker processes. It is not truly parallel (except for worker processes) since it is deployed on MRI ruby with its GIL but in this case it shouldn't matter much and the app should still benefit from parallel calls.

##Managing secrets

To avoid sharing API related secrets they are managed in .env file that is not versioned. Environment variables defined there are then used in secrets.yml to define secrets which are then used in API service class.

##Managing API calls

API logic management is implemented in a single service class FyberAPI which uses [Active Interaction](https://github.com/orgsync/active_interaction) to help define parameters and validation. 

It may seem as overkill for an application as simple as this one but extracting logic in a separate class instead of implementing it in controllers and models is always a good idea. It keeps controllers skinny and allows testing in isolation. If someone were to chose to implement the same thing, for example, using Sinatra in the backend and Angular in frontend the most important part of the app along with tests cold easily be reused. Also, if this app were more complex, requiring multiple types of API calls, service class could be extended and reused to keep the code DRY.

Since the application doesn't store data and no models are defined, FyberAPI instance is used for form building withSimpleForm and it is possible because ActiveIntegration quacks like ActiveRecord.

##Presenting offers

OffersController#index is presenting users with a form which is posted via AJAX. The returned API response is then inserted in the page. I may seem a bit strange but the point was to avoid saving API responses in the middle in 
cache or database. That way application only serves as a conduit between the user and Fyber API.

## Testing

Minitest with spec flavour is used for testing. FyberAPI spec is used to test API logic and OffersController spec totest if correct views are rendered. 

[VCR](https://github.com/vcr/vcr) is used to record API responses so they can be replayed on later testing.
