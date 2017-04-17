module JsonConverter exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline exposing (required)
import Types exposing (..)


decodePlacesData : Json.Decode.Decoder PlacesData
decodePlacesData =
    Json.Decode.Pipeline.decode PlacesData
        |> required "data" (Json.Decode.list decodePlace1)


decodeReviewsData : Json.Decode.Decoder ReviewsData
decodeReviewsData =
    Json.Decode.Pipeline.decode ReviewsData
        |> required "data" (Json.Decode.list decodeReview1)


decodePlace : Json.Decode.Decoder PlaceData
decodePlace =
    Json.Decode.Pipeline.decode PlaceData
        |> required "data" decodePlace1


decodePlace1 : Json.Decode.Decoder Place
decodePlace1 =
    Json.Decode.Pipeline.decode Place
        |> required "name" (Json.Decode.string)
        |> required "id" (Json.Decode.string)
        |> required "cuisine" (Json.Decode.string)


decodeReview1 : Json.Decode.Decoder Review
decodeReview1 =
    Json.Decode.Pipeline.decode Review
        |> required "id" (Json.Decode.string)
        |> required "user_id" (Json.Decode.string)
        |> required "place_id" (Json.Decode.string)
        |> required "rating" (Json.Decode.float)
        |> required "comment" (Json.Decode.string)


encodeAddPlaceForm1 : AddPlaceForm -> Json.Encode.Value
encodeAddPlaceForm1 record =
    Json.Encode.object
        [ ( "name", Json.Encode.string <| record.name )
          --        , ( "id", Json.Encode.int <| record.id )
        , ( "cuisine", Json.Encode.string <| record.cuisine )
        ]


encodeAddPlaceForm : AddPlaceForm -> Json.Encode.Value
encodeAddPlaceForm record =
    Json.Encode.object
        [ ( "place", encodeAddPlaceForm1 <| record )
        ]


encodeAddReviewForm1 : AddReviewForm -> Json.Encode.Value
encodeAddReviewForm1 record =
    Json.Encode.object
        [ ( "rating", Json.Encode.float <| record.rating )
          --        , ( "id", Json.Encode.int <| record.id )
        , ( "comment", Json.Encode.string <| record.comment )
        , ( "place_id", Json.Encode.string <| record.place_id )
        ]


encodeAddReviewForm : AddReviewForm -> Json.Encode.Value
encodeAddReviewForm record =
    Json.Encode.object
        [ ( "review", encodeAddReviewForm1 <| record )
        ]
