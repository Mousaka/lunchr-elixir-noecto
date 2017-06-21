module Luncher exposing (..)

import Html exposing (Html, h1, program, div, button, input, text, p)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, value, class, style)
import RemoteData exposing (RemoteData(..), WebData, map)
import Types exposing (..)
import Api exposing (..)
import Dialog exposing (..)


main : Program Never Model Msg
main =
    program { init = init, subscriptions = (\_ -> Sub.none), update = update, view = view }


init : ( Model, Cmd Msg )
init =
    ( { places = NotAsked
      , reviews = NotAsked
      , addPlaceForm = emptyAddPlaceForm
      , addReviewForm = emptyAddReviewForm
      , showReviewForm = Nothing
      , reviewText = ""
      }
    , Api.places
    )


emptyAddReviewForm : AddReviewForm
emptyAddReviewForm =
    { comment = "", place_id = "", rating = 5.1 }


emptyAddPlaceForm : AddPlaceForm
emptyAddPlaceForm =
    { name = "", cuisine = "" }


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
                    ( { model | addPlaceForm = emptyAddPlaceForm, places = Loading }, Api.places )

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
                    ( { model | addReviewForm = emptyAddReviewForm, reviews = Loading }, Api.reviews )

                Failure err ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                NotAsked ->
                    ( model, Cmd.none )

        GetPlaces ->
            ( { model | places = Loading }
            , Api.places
            )

        GetReviews ->
            ( { model | reviews = Loading }
            , Api.reviews
            )

        AddPlaceFormUpdate addPlaceFormMsg ->
            ( { model | addPlaceForm = updateAddPlaceForm model.addPlaceForm addPlaceFormMsg }, Cmd.none )

        AddPlace ->
            ( model, addPlace model.addPlaceForm )

        ShowReviewForm placeId ->
            ( { model | showReviewForm = Just placeId }, Cmd.none )

        CloseModal ->
            ( { model | showReviewForm = Nothing }, Cmd.none )

        ReviewText review ->
            ( { model | reviewText = review }, Cmd.none )


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
        [ addPlaceForm model.addPlaceForm
        , placeList model.showReviewForm model.places
        , viewPlaces model.places "Places" GetPlaces
        , viewPlaces model.reviews "Reviews" GetReviews
        ]


placeList : Maybe String -> WebData (List Place) -> Html Msg
placeList showRatingOnThisPlaceId places =
    div [] <|
        case places of
            Success data ->
                List.map (viewPlace showRatingOnThisPlaceId) data

            _ ->
                []


viewPlace : Maybe String -> Place -> Html Msg
viewPlace showRatingOnThisPlaceId place =
    div [ style [ ( "border", "1px solid #ccc" ) ] ]
        [ Html.h3 [] [ Html.text ("Namn: " ++ place.name) ]
        , Html.h4 [] [ Html.text ("Beskrivning: " ++ (Maybe.withDefault "" place.description)) ]
        , Html.h4 [] [ Html.text ("Cuisine: " ++ (Maybe.withDefault "" place.cuisine)) ]
        , Html.h4 [] [ Html.text ("Adress: " ++ (Maybe.withDefault "" place.address)) ]
        , Html.h4 [] [ Html.text ("Prisklass: " ++ (Maybe.withDefault "" place.price)) ]
        , Html.h4 []
            [ Html.text ("Ingår kaffe: " ++ (boolToString place.coffee))
            , rating showRatingOnThisPlaceId place.id
            , showPlaceMaybe showRatingOnThisPlaceId
            ]
        ]


rating : Maybe String -> String -> Html Msg
rating showingPlace placeId =
    div [ onClick (ShowReviewForm placeId) ]
        [ Html.span [ class "glyphicon-plus" ] []
        , Html.span [ class "glyphicon-plus" ] []
        , Html.span [ class "glyphicon-plus" ] []
        , Html.span [ class "glyphicon-plus" ] []
        , Html.span [ class "glyphicon-plus" ] []
        ]



-- showPlaceMaybe : Maybe String -> String -> List (Html Msg)


showPlaceMaybe : Maybe String -> Html Msg
showPlaceMaybe showingPlace =
    let
        a =
            case showingPlace of
                Just p ->
                    Debug.log p

                Nothing ->
                    Debug.log "Ingenting"
    in
        Dialog.view
            (case showingPlace of
                Just plId ->
                    Just
                        { closeMessage = Just CloseModal
                        , containerClass = Just "your-container-class"
                        , header = Just (text "Ranka")
                        , body = Just (div [] [ Html.textarea [ style [ ( "resize", "none" ), ( "width", "100%" ) ], (placeholder "Skriv en recension"), onInput ReviewText ] [] ])
                        , footer =
                            Just
                                (button
                                    [ class "btn btn-success"
                                    , onClick GetReviews
                                    ]
                                    [ text "OK" ]
                                )
                        }

                Nothing ->
                    Nothing
            )


boolToString : Maybe Bool -> String
boolToString bool =
    case bool of
        Just b ->
            case b of
                True ->
                    "Ja"

                False ->
                    "Nej"

        Nothing ->
            ""


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
