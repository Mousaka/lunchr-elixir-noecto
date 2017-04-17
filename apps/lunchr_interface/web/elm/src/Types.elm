module Types exposing (..)

import RemoteData exposing (RemoteData(..), WebData)


type alias Model =
    { places : WebData (List Place)
    , reviews : WebData (List Review)
    , addPlaceForm : AddPlaceForm
    , addReviewForm : AddReviewForm
    }


type alias PlacesData =
    { data : List Place
    }


type alias ReviewsData =
    { data : List Review
    }


type alias PlaceData =
    { data : Place
    }


type alias Place =
    { name : String
    , id : String
    , cuisine : String
    }


type alias AddReviewForm =
    { rating : Float
    , comment : String
    , place_id : String
    }


type alias Review =
    { id : String
    , user_id : String
    , place_id : String
    , rating : Float
    , comment : String
    }


type alias AddPlaceForm =
    { name : String
    , cuisine : String
    }


init : ( Model, Cmd Msg )
init =
    ( { places = NotAsked
      , reviews = NotAsked
      , addPlaceForm = emptyAddPlaceForm
      , addReviewForm = emptyAddReviewForm
      }
    , Cmd.none
    )


emptyAddReviewForm : AddReviewForm
emptyAddReviewForm =
    { comment = "", place_id = "", rating = 5.1 }


emptyAddPlaceForm : AddPlaceForm
emptyAddPlaceForm =
    { name = "", cuisine = "" }


type Msg
    = GetPlaces
    | GetReviews
    | HandlePlacesResponse (WebData PlacesData)
    | HandlePostPlace (WebData PlaceData)
    | HandleReviewsResponse (WebData ReviewsData)
    | HandlePostReview (WebData ReviewsData)
    | AddPlaceFormUpdate AddPlaceFormMsg
    | AddPlace


type AddPlaceFormMsg
    = Name String
    | Cuisine String
