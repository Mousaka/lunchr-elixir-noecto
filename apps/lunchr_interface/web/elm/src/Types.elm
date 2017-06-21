module Types exposing (..)

import RemoteData exposing (RemoteData(..), WebData)


type alias Model =
    { places : WebData (List Place)
    , reviews : WebData (List Review)
    , addPlaceForm : AddPlaceForm
    , addReviewForm : AddReviewForm
    , showReviewForm : Maybe String
    , reviewText : String
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
    , cuisine : Maybe String
    , address : Maybe String
    , price : Maybe String
    , coffee : Maybe Bool
    , description : Maybe String
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


type Msg
    = GetPlaces
    | GetReviews
    | HandlePlacesResponse (WebData PlacesData)
    | HandlePostPlace (WebData PlaceData)
    | HandleReviewsResponse (WebData ReviewsData)
    | HandlePostReview (WebData ReviewsData)
    | AddPlaceFormUpdate AddPlaceFormMsg
    | AddPlace
    | ShowReviewForm String
    | CloseModal
    | ReviewText String


type AddPlaceFormMsg
    = Name String
    | Cuisine String
