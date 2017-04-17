module Luncher exposing (..)

import Html exposing (Html, h1, program, div, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, value)
import JsonConverter exposing (..)
import RemoteData exposing (RemoteData(..), WebData, map)
import RemoteData.Http
import Types exposing (..)


main : Program Never Model Msg
main =
    program { init = init, subscriptions = (\_ -> Sub.none), update = update, view = view }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandlePlacesResponse data ->
            ( { model | places = RemoteData.map .data data }
            , Cmd.none
            )

        HandlePostPlace data ->
            case data of
                Success _ ->
                    ( { model | addPlaceForm = Types.emptyAddPlaceForm, places = Loading }, RemoteData.Http.get "/api/places/" HandlePlacesResponse decodePlacesData )

                Failure err ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                NotAsked ->
                    ( model, Cmd.none )

        HandleReviewsResponse data ->
            ( { model | reviews = RemoteData.map .data data }
            , Cmd.none
            )

        HandlePostReview data ->
            case data of
                Success _ ->
                    ( { model | addReviewForm = Types.emptyAddReviewForm, reviews = Loading }, RemoteData.Http.get "/api/reviews/" HandleReviewsResponse decodeReviewsData )

                Failure err ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                NotAsked ->
                    ( model, Cmd.none )

        GetPlaces ->
            ( { model | places = Loading }
            , RemoteData.Http.get "/api/places/" HandlePlacesResponse decodePlacesData
            )

        GetReviews ->
            ( { model | reviews = Loading }
            , RemoteData.Http.get "/api/reviews/" HandleReviewsResponse decodeReviewsData
            )

        AddPlaceFormUpdate addPlaceFormMsg ->
            ( { model | addPlaceForm = updateAddPlaceForm model.addPlaceForm addPlaceFormMsg }, Cmd.none )

        AddPlace ->
            ( model, postNewPlace model.addPlaceForm )


postNewPlace : AddPlaceForm -> Cmd Msg
postNewPlace place =
    RemoteData.Http.post "/api/places/" HandlePostPlace decodePlace (encodeAddPlaceForm place)


updateAddPlaceForm : AddPlaceForm -> AddPlaceFormMsg -> AddPlaceForm
updateAddPlaceForm addPlaceForm msg =
    case msg of
        Name n ->
            { addPlaceForm | name = n }

        Cuisine c ->
            { addPlaceForm | cuisine = c }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ Html.text "Lunchr" ]
        , addPlaceForm model.addPlaceForm
        , viewPlaces model.places "Places" GetPlaces
        , viewPlaces model.reviews "Reviews" GetReviews
        ]


addPlaceForm : AddPlaceForm -> Html Msg
addPlaceForm addPlaceForm =
    div []
        [ input [ placeholder "name", value addPlaceForm.name, onInput (addMsg Name) ] []
        , input [ placeholder "cuisine", value addPlaceForm.cuisine, onInput (addMsg Cuisine) ] []
        , button [ onClick AddPlace ] [ Html.text "Nytt plejs!" ]
        ]


addMsg : (String -> AddPlaceFormMsg) -> String -> Msg
addMsg msg str =
    AddPlaceFormUpdate (msg str)


viewPlaces : WebData (List a) -> String -> Msg -> Html Msg
viewPlaces webData dataname buttonAction =
    case webData of
        Loading ->
            Html.text "Fetching webData..."

        Success data ->
            Html.text ("Recieved webData: " ++ toString data)

        Failure error ->
            Html.text ("This went wrong: " ++ toString error)

        NotAsked ->
            button [ onClick buttonAction ] [ Html.text ("Get " ++ dataname ++ " from the server") ]
