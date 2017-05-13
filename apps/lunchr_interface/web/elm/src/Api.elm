module Api exposing (..)

import JsonConverter exposing (..)
import RemoteData.Http
import Types exposing (..)


reviews : Cmd Msg
reviews =
    RemoteData.Http.get "/api/reviews/" HandleReviewsResponse decodeReviewsData


places : Cmd Msg
places =
    RemoteData.Http.get "/api/places/" HandlePlacesResponse decodePlacesData


addPlace : AddPlaceForm -> Cmd Msg
addPlace place =
    RemoteData.Http.post "/api/places/" HandlePostPlace decodePlace (encodeAddPlaceForm place)
