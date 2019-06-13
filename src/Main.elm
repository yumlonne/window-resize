module Main exposing (main)

import Browser

-- VIEW import

import Html exposing (Html)

-- elm-ui

import Element exposing (..)
import Element.Input as Input



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { resizeWidth : Bool
    , resizeHeight : Bool
    , velocity : Float
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { resizeWidth = False
        , resizeHeight = False
        , velocity = 1.0
    }
    , Cmd.none
    )


-- UPDATE


type Msg
    = OnClickWidthCheckbox Bool
    | OnClickHeightCheckbox Bool
    | OnChangeVelocity Float


update : Msg -> Model -> (Model, Cmd Msg)
update msg model=
    case msg of
        OnClickWidthCheckbox check ->
            ( { model | resizeWidth = check }
            , Cmd.none
            )

        OnClickHeightCheckbox check ->
            ( { model | resizeHeight = check }
            , Cmd.none
            )

        OnChangeVelocity velocity ->
            ( { model | velocity = velocity }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions = always Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "resize window"
    , body = body model
    }

body : Model -> List (Html Msg)
body model =
    List.singleton
        <| layout []
        <| column []
            [ Input.checkbox []
                { onChange = OnClickWidthCheckbox
                , icon = Input.defaultCheckbox
                , checked = model.resizeWidth
                , label = Input.labelRight [] <| text "よこ"
                }
            , Input.checkbox []
                { onChange = OnClickHeightCheckbox
                , icon = Input.defaultCheckbox
                , checked = model.resizeHeight
                , label = Input.labelRight [] <| text "たて"
                }
            , Input.slider []
                { onChange = OnChangeVelocity
                , label = Input.labelBelow [] <| text "速さ"
                , min = 0.5
                , max = 1.5
                , value = model.velocity
                , thumb = Input.defaultThumb
                , step = Just 0.1
                }
            ]

