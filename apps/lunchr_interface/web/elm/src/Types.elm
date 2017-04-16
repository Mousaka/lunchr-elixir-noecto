module Types exposing (..)

import RemoteData exposing (RemoteData(..), WebData)


type alias Model =
    { places : WebData (List Place)
    , addPlaceForm : AddPlaceForm
    }


type alias PlacesData =
    { data : List Place
    }


type alias PlaceData =
    { data : Place
    }


type alias Place =
    { name : String
    , id : Int
    , cuisine : String
    }


type alias AddPlaceForm =
    { name : String
    , cuisine : String
    }


init : ( Model, Cmd Msg )
init =
    ( { places = NotAsked
      , addPlaceForm = emptyAddPlaceForm
      }
    , Cmd.none
    )


emptyAddPlaceForm : AddPlaceForm
emptyAddPlaceForm =
    { name = "", cuisine = "" }


type Msg
    = GetPlaces
    | HandlePlacesResponse (WebData PlacesData)
    | HandlePostPlace (WebData PlaceData)
    | AddPlaceFormUpdate AddPlaceFormMsg
    | AddPlace


type AddPlaceFormMsg
    = Name String
    | Cuisine String
