module JsonConverter exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline exposing (required)
import Types exposing (..)


decodePlacesData : Json.Decode.Decoder PlacesData
decodePlacesData =
    Json.Decode.Pipeline.decode PlacesData
        |> required "data" (Json.Decode.list decodePlace1)


encodePlaces : PlacesData -> Json.Encode.Value
encodePlaces record =
    Json.Encode.object
        [ ( "data", Json.Encode.list <| List.map encodePlace <| record.data )
        ]


decodePlace : Json.Decode.Decoder PlaceData
decodePlace =
    Json.Decode.Pipeline.decode PlaceData
        |> required "data" decodePlace1


decodePlace1 : Json.Decode.Decoder Place
decodePlace1 =
    Json.Decode.Pipeline.decode Place
        |> required "name" (Json.Decode.string)
        |> required "id" (Json.Decode.int)
        |> required "cuisine" (Json.Decode.string)


encodePlace1 : Place -> Json.Encode.Value
encodePlace1 record =
    Json.Encode.object
        [ ( "name", Json.Encode.string <| record.name )
          --        , ( "id", Json.Encode.int <| record.id )
        , ( "cuisine", Json.Encode.string <| record.cuisine )
        ]


encodePlace : Place -> Json.Encode.Value
encodePlace record =
    Json.Encode.object
        [ ( "place", encodePlace1 <| record )
        ]
