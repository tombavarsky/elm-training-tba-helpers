module TBAInfo exposing (..)

import Browser
import Html
import Http
import Json.Decode as D


type Msg
    = GotInfo (Result Http.Error String)


type Model
    = Failure
    | Loading
    | Success String


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = \msg model -> ( update msg model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        }


init : Model -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://www.thebluealliance.com/api/v3/team/frc1690"
        , expect = Http.expectString GotInfo
        }
    )


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotInfo result ->
            case result of
                Ok info ->
                    Success info

                Err _ ->
                    Failure


view : Model -> Html.Html Msg
view model =
    case model of
        Failure ->
            Html.text "couldn't find any info"

        Loading ->
            Html.text "loading..."

        Success info ->
            Html.pre [] [ Html.text info ]
